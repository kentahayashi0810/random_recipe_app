import 'package:flutter/material.dart';
import 'package:random_recipe_app/models/recipe.dart';
import 'package:random_recipe_app/screens/detail/sub_screens/thumbnail_card.dart';
import 'package:random_recipe_app/shrared/styled_section.dart';
import 'package:random_recipe_app/shrared/styled_text.dart';

class SummaryScreen extends StatelessWidget {
  const SummaryScreen({super.key, required this.recipe});

  final Recipe recipe;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: SingleChildScrollView(
        child: Column(
          children: [
            // Thumbnail
            ThumbnailCard(recipe: recipe),

            SizedBox(height: 20),

            // recipe detail
            StyledSection(
              title: 'About the recipe',
              contentWidget: StyledText(recipe.summary),
              rightEndWidget: Row(
                children: [
                  Icon(Icons.timer, size: 16),
                  Text('${recipe.cookingTime.toString()} min'),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
