import 'package:random_recipe_app/models/recipe.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

class DatabaseService {
  static final DatabaseService instance = DatabaseService._init();
  static Database? _database;

  DatabaseService._init();

  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDB('recipes.db');
    return _database!;
  }

  Future<Database> _initDB(String filePath) async {
    final dbPath = await getDatabasesPath();
    final path = join(dbPath, filePath);

    return await openDatabase(
      path,
      version: 1,
      onCreate: _createDB,
      // This line ensures that if a Recipe is deleted, its ingredients are too!
      onConfigure: (db) async => await db.execute('PRAGMA foreign_keys = ON'),
    );
  }

  Future _createDB(Database db, int version) async {
    // 1. Recipes Table
    await db.execute('''
      CREATE TABLE recipes (
        id TEXT PRIMARY KEY,
        name TEXT NOT NULL,
        summary TEXT,
        cookingTime INTEGER,
        thumbnailPath TEXT
      )
    ''');

    // 2. Ingredients Table
    await db.execute('''
      CREATE TABLE ingredients (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        recipe_id TEXT NOT NULL,
        name TEXT NOT NULL,
        amount REAL,
        unit TEXT,
        FOREIGN KEY (recipe_id) REFERENCES recipes (id) ON DELETE CASCADE
      )
    ''');

    // 3. Steps Table
    await db.execute('''
      CREATE TABLE steps (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        recipe_id TEXT NOT NULL,
        instruction TEXT NOT NULL,
        FOREIGN KEY (recipe_id) REFERENCES recipes (id) ON DELETE CASCADE
      )
    ''');
  }

  Future<void> createRecipe(Recipe recipe) async {
    final db = await instance.database;

    await db.transaction((txn) async {
      // 1. Insert into recipes table
      await txn.insert('recipes', {
        'id': recipe.id,
        'name': recipe.name,
        'summary': recipe.summary,
        'cookingTime': recipe.cookingTime,
        'thumbnailPath': recipe.thumbnailPath,
      });

      // 2. Insert all ingredients
      for (var ingredient in recipe.ingredients) {
        await txn.insert('ingredients', {
          'recipe_id': recipe.id,
          'name': ingredient.name,
          'amount': ingredient.amount,
          'unit': ingredient.unit.name, // Convert Enum to String
        });
      }

      // 3. Insert all steps
      for (var step in recipe.recipeSteps) {
        await txn.insert('steps', {
          'recipe_id': recipe.id,
          'instruction': step.instruction,
        });
      }
    });
  }

  Future<List<Recipe>> getAllRecipes() async {
    final db = await instance.database;

    // Get all recipes from the main table
    final List<Map<String, dynamic>> recipeMaps = await db.query('recipes');

    List<Recipe> recipes = [];

    for (var rMap in recipeMaps) {
      final String recipeId = rMap['id'];

      // Get ingredients for THIS recipe
      final List<Map<String, dynamic>> ingMaps = await db.query(
        'ingredients',
        where: 'recipe_id = ?',
        whereArgs: [recipeId],
      );

      // Get steps for THIS recipe
      final List<Map<String, dynamic>> stepMaps = await db.query(
        'steps',
        where: 'recipe_id = ?',
        whereArgs: [recipeId],
        orderBy: 'id ASC', // Keep steps in order
      );

      // Combine them into a Recipe object
      // We will create the 'fromDb' constructor in your Recipe class next!
      recipes.add(Recipe.fromDb(rMap, ingMaps, stepMaps));
    }

    return recipes;
  }

  Future<int> deleteRecipe(String id) async {
    final db = await instance.database;
    return await db.delete('recipes', where: 'id = ?', whereArgs: [id]);
  }
}
