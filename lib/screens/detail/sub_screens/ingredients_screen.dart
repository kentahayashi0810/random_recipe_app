import 'package:flutter/material.dart';
import 'package:random_recipe_app/models/recipe.dart';
import 'package:random_recipe_app/screens/detail/sub_screens/thumbnail_card.dart';
import 'package:random_recipe_app/shrared/styled_section.dart';
import 'package:random_recipe_app/shrared/styled_text.dart';

class IngredientsScreen extends StatelessWidget {
  const IngredientsScreen({super.key, required this.recipe});

  final Recipe recipe;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding:
          const EdgeInsets.symmetric(horizontal: 16) +
          EdgeInsets.only(bottom: 20),
      child: SingleChildScrollView(
        child: Column(
          children: [
            // Thumbnail
            ThumbnailCard(recipe: recipe),

            SizedBox(height: 20),

            StyledSection(
              title: 'Ingredients',
              contentWidget: Padding(
                padding: const EdgeInsets.only(left: 20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: recipe.ingredients.toList().asMap().entries.map((
                    entry,
                  ) {
                    final itemNum = entry.key + 1;
                    final text = '$itemNum) ${entry.value.toString()}';
                    return Padding(
                      padding: const EdgeInsets.symmetric(vertical: 4),
                      child: StyledText(text),
                    );
                  }).toList(),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
