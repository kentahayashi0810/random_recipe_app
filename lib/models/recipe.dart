import 'package:random_recipe_app/models/ingredient.dart';
import 'package:random_recipe_app/screens/add_reciepe/recipe_step.dart';

class Recipe {
  Recipe({
    required this.name,
    required this.id,
    required this.summary,
    required this.cookingTime,
    required this.ingredients,
    required this.thumbnailPath,
    required this.recipeSteps,
  });

  // fields
  String name;
  final String id;
  String summary;
  String thumbnailPath;
  int cookingTime;
  bool _isFav = false;
  Set<Ingredient> ingredients;
  List<RecipeStep> recipeSteps;

  // getters
  bool get isFav => _isFav;

  // methods
  void toggleIsFav() {
    _isFav = !_isFav;
  }

  factory Recipe.fromDb(
    Map<String, dynamic> recipeMap,
    List<Map<String, dynamic>> ingredientMaps,
    List<Map<String, dynamic>> stepMaps,
  ) {
    return Recipe(
      id: recipeMap['id'] as String,
      name: recipeMap['name'] as String,
      summary: recipeMap['summary'] as String,
      cookingTime: recipeMap['cookingTime'] as int,
      thumbnailPath: recipeMap['thumbnailPath'] as String,
      // Convert the list of Ingredient maps into a Set of Ingredient objects
      ingredients: ingredientMaps.map((ing) => Ingredient.fromMap(ing)).toSet(),
      // Convert the list of Step maps into a List of RecipeStep objects
      recipeSteps: stepMaps.map((step) => RecipeStep.fromMap(step)).toList(),
    );
  }
}
