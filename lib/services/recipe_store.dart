import 'package:flutter/cupertino.dart';
import 'package:random_recipe_app/models/recipe.dart';
import 'package:random_recipe_app/services/database_service.dart';

class RecipeStore extends ChangeNotifier {
  List<Recipe> _recipes = [];
  List<Recipe> get recipes => _recipes;

  // 1. Initial Load: Call this when the app starts
  Future<void> loadRecipes() async {
    // Talk to the database instance
    _recipes = await DatabaseService.instance.getAllRecipes();
    notifyListeners(); // Tell the UI to rebuild with the new data
  }

  // 2. Add Recipe: Save to DB first, then update the UI list
  Future<void> addRecipe(Recipe recipe) async {
    await DatabaseService.instance.createRecipe(recipe);
    _recipes.add(recipe);
    notifyListeners();
  }

  // 3. Delete Recipe: Remove from DB, then update UI list
  Future<void> removeRecipe(String id) async {
    await DatabaseService.instance.deleteRecipe(id);
    _recipes.removeWhere((recipe) => recipe.id == id);
    notifyListeners();
  }
}
