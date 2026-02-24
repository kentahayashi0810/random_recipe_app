import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:random_recipe_app/screens/home/home_screen.dart';
import 'package:random_recipe_app/services/recipe_store.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  final recipeStore = RecipeStore();

  await recipeStore.loadRecipes();

  runApp(
    ChangeNotifierProvider(
      create: (context) => recipeStore,
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(colorScheme: .fromSeed(seedColor: Colors.blueGrey)),
      home: const HomeScreen(),
    );
  }
}
