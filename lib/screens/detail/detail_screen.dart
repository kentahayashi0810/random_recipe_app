import 'package:flutter/material.dart';
import 'package:random_recipe_app/models/recipe.dart';
import 'package:random_recipe_app/screens/detail/sub_screens/ingredients_screen.dart';
import 'package:random_recipe_app/screens/detail/sub_screens/steps_screen.dart';
import 'package:random_recipe_app/screens/detail/sub_screens/summary_screen.dart';
import 'package:random_recipe_app/shrared/styled_section.dart';
import 'package:random_recipe_app/shrared/styled_text.dart';

class DetailScreen extends StatefulWidget {
  const DetailScreen({super.key, required this.recipe});

  final Recipe recipe;

  @override
  State<DetailScreen> createState() => _DetailScreenState();
}

class _DetailScreenState extends State<DetailScreen> {
  late final List<Widget> _screens;
  int _selectedIndex = 0;

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  void initState() {
    super.initState();
    _screens = [
      SummaryScreen(recipe: widget.recipe),
      IngredientsScreen(recipe: widget.recipe),
      StepsScreen(recipe: widget.recipe),
    ];
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(widget.recipe.name), centerTitle: true),
      body: _screens[_selectedIndex],
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _selectedIndex,
        onTap: _onItemTapped,
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(icon: Icon(Icons.info), label: 'Summary'),
          BottomNavigationBarItem(icon: Icon(Icons.egg), label: 'Ingredients'),
          BottomNavigationBarItem(icon: Icon(Icons.restaurant), label: 'Steps'),
        ],
        type: BottomNavigationBarType.fixed,
      ),
    );
  }
}
