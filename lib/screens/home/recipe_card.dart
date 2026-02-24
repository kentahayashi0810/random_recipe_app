import 'dart:io';

import 'package:flutter/material.dart';
import 'package:random_recipe_app/models/recipe.dart';
import 'package:random_recipe_app/screens/detail/detail_screen.dart';

class RecipeCard extends StatelessWidget {
  const RecipeCard({super.key, required this.recipe});

  final Recipe recipe;

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: EdgeInsetsGeometry.symmetric(horizontal: 16, vertical: 8),
        child: Row(
          children: [
            SizedBox(
              width: 100,
              height: 100,
              child: recipe.thumbnailPath.isEmpty
                  ? Image.asset(
                      'assets/thumbnails/dummy_thumbnail.png',
                      width: double.infinity,
                      fit: BoxFit.fitHeight,
                      alignment: Alignment.center,
                    )
                  : Image.file(File(recipe.thumbnailPath)),
            ),
            SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    recipe.name,
                    style: TextStyle(
                      color: Colors.indigo,
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  SizedBox(height: 4),
                  Row(
                    children: [
                      Icon(Icons.timer, size: 16),
                      Text('${recipe.cookingTime.toString()} min'),
                    ],
                  ),
                  SizedBox(height: 6),
                  Text(
                    recipe.summary,
                    maxLines: 4,
                    overflow: TextOverflow.ellipsis,
                  ),
                ],
              ),
            ),
            SizedBox(width: 12),
            IconButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (ctx) => DetailScreen(recipe: recipe),
                  ),
                );
              },
              iconSize: 20,
              icon: Icon(Icons.arrow_forward),
            ),
          ],
        ),
      ),
    );
  }
}
