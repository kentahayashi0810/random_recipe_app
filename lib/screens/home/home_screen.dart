import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:random_recipe_app/screens/add_reciepe/add_recipe_screen.dart';
import 'package:random_recipe_app/screens/home/recipe_card.dart';
import 'package:random_recipe_app/services/recipe_store.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Recipe List'), centerTitle: true),
      body: Column(
        children: [
          Expanded(
            child: Consumer<RecipeStore>(
              builder: (context, store, child) {
                return ListView.builder(
                  padding: EdgeInsets.only(bottom: 100),
                  itemCount: store.recipes.length,
                  itemBuilder: (BuildContext context, int index) {
                    return Container(
                      margin: EdgeInsets.symmetric(vertical: 6, horizontal: 6),
                      child: RecipeCard(recipe: store.recipes[index]),
                    );
                  },
                );
              },
            ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (ctx) => AddRecipeScreen()),
          );
        },
        label: const Text('Add a recipe'),
        icon: const Icon(Icons.add),
      ),
    );
  }
}
