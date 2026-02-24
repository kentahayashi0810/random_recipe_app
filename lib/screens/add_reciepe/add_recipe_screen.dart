import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:path_provider/path_provider.dart';
import 'package:provider/provider.dart';
import 'package:random_recipe_app/models/ingredient.dart';
import 'package:random_recipe_app/models/recipe.dart';
import 'package:random_recipe_app/screens/add_reciepe/add_ingredient_sheet.dart';
import 'package:random_recipe_app/screens/add_reciepe/add_steps_sheet.dart';
import 'package:random_recipe_app/screens/add_reciepe/recipe_step.dart';
import 'package:random_recipe_app/services/recipe_store.dart';
import 'package:random_recipe_app/shrared/styled_text.dart';
import 'package:random_recipe_app/shrared/styled_title.dart';
import 'package:uuid/uuid.dart';
import 'package:path/path.dart' as p;

var uuid = const Uuid();

class AddRecipeScreen extends StatefulWidget {
  const AddRecipeScreen({super.key});

  @override
  State<AddRecipeScreen> createState() => _AddRecipeScreenState();
}

class _AddRecipeScreenState extends State<AddRecipeScreen> {
  final _formGlobalKey = GlobalKey<FormState>();

  final Set<Ingredient> addedIngredientList = {};
  Duration _duration = Duration(minutes: 30);

  String _recipeName = '';
  String _recipeSummary = '';
  XFile? thumbnail;
  String imagePath = '';

  final List<RecipeStep> _steps = [];
  int _currentStep = 0;
  List<GlobalKey> _stepKeys = [];

  final imagePicker = ImagePicker();

  bool ingredientError = false;
  bool stepesEmptyError = false;

  Future<String> saveImagePermanently(String temporaryPath) async {
    final directory = await getApplicationDocumentsDirectory();

    final name = p.basename(temporaryPath);

    final permanentPath = '${directory.path}/$name';

    final savedFile = await File(temporaryPath).copy(permanentPath);

    return savedFile.path;
  }

  void onSubmit() async {
    if (_formGlobalKey.currentState!.validate()) {
      _formGlobalKey.currentState!.save();

      if (addedIngredientList.isEmpty) {
        setState(() {
          ingredientError = true;
        });
        return;
      }

      if (_steps.isEmpty) {
        setState(() {
          stepesEmptyError = true;
        });
        return;
      }

      if (thumbnail != null) {
        imagePath = await saveImagePermanently(thumbnail!.path);
      }

      if (!mounted) {
        return;
      }

      // add a recipe to the recipelist
      Provider.of<RecipeStore>(context, listen: false).addRecipe(
        Recipe(
          name: _recipeName,
          id: uuid.v4(),
          summary: _recipeSummary,
          cookingTime: _duration.inMinutes,
          ingredients: addedIngredientList,
          thumbnailPath: imagePath,
          recipeSteps: _steps,
        ),
      );

      Navigator.pop(context);
    }
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => FocusScope.of(context).unfocus(),
      child: Scaffold(
        appBar: AppBar(
          title: StyledTitle('Add your own recipe!'),
          centerTitle: true,
        ),
        body: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
            child: Form(
              key: _formGlobalKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SizedBox(height: 30),

                  // Recipe name
                  TextFormField(
                    decoration: const InputDecoration(
                      label: StyledText('Recipe Name'),
                    ),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please enter the recipe name.';
                      }
                      return null;
                    },
                    onSaved: (newValue) {
                      _recipeName = newValue!;
                    },
                  ),

                  SizedBox(height: 20),

                  // Recipe Summary
                  TextFormField(
                    maxLength: 100,
                    decoration: const InputDecoration(
                      label: StyledText('Recipe Summary'),
                    ),
                    onSaved: (newValue) {
                      _recipeSummary = newValue!;
                    },
                  ),

                  SizedBox(height: 20),

                  // Cooking time
                  Row(
                    children: [
                      StyledTitle('Cooking time'),
                      SizedBox(width: 10),
                      ElevatedButton(
                        child: Text(
                          "${_duration.inHours}h ${_duration.inMinutes % 60}m",
                        ),
                        onPressed: () {
                          showModalBottomSheet(
                            context: context,
                            builder: (BuildContext context) {
                              return SizedBox(
                                height: 250,
                                child: CupertinoTimerPicker(
                                  mode: CupertinoTimerPickerMode
                                      .hm, // Hours and Minutes
                                  initialTimerDuration: _duration,
                                  onTimerDurationChanged:
                                      (Duration newDuration) {
                                        setState(() => _duration = newDuration);
                                      },
                                ),
                              );
                            },
                          );
                        },
                      ),
                    ],
                  ),

                  SizedBox(height: 30),

                  // Ingredients
                  StyledTitle('Ingredients'),
                  SizedBox(height: 10),
                  if (addedIngredientList.isEmpty) ...[
                    StyledText('No ingredient added.'),
                  ] else ...[
                    Wrap(
                      spacing: 8.0,
                      runSpacing: 8.0,
                      children: addedIngredientList.map((ingredient) {
                        return Container(
                          padding: EdgeInsets.only(left: 8),
                          decoration: BoxDecoration(
                            border: BoxBorder.all(
                              color: Colors.grey,
                              width: 1.5,
                            ),
                            borderRadius: BorderRadius.all(Radius.circular(10)),
                          ),
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              StyledText(ingredient.toString()),
                              IconButton(
                                iconSize: 20,
                                onPressed: () {},
                                icon: Icon(Icons.edit),
                              ),
                            ],
                          ),
                        );
                      }).toList(),
                    ),
                  ],
                  SizedBox(height: 20),
                  Center(
                    child: ElevatedButton(
                      onPressed: () {
                        showModalBottomSheet(
                          context: context,
                          isScrollControlled: true,
                          builder: (BuildContext context) {
                            return AddIngredientSheet(
                              onAdd: (Ingredient newIngredient) {
                                setState(() {
                                  addedIngredientList.add(newIngredient);
                                });
                              },
                            );
                          },
                        );
                      },
                      child: StyledText('Add Ingredients'),
                    ),
                  ),
                  if (ingredientError) ...[
                    Center(
                      child: Text(
                        'Please add at least 1 ingredient.',
                        style: TextStyle(
                          color: const Color.fromARGB(255, 182, 25, 13),
                        ),
                      ),
                    ),
                  ],

                  const SizedBox(height: 20),

                  Container(
                    color: Colors.grey[400],
                    height: 200,
                    alignment: Alignment.center,
                    child: thumbnail == null
                        ? StyledText(
                            'Please upload a thumbnail for the recipe.',
                          )
                        : Image.file(File(thumbnail!.path)),
                  ),
                  const SizedBox(height: 10),
                  Center(
                    child: ElevatedButton(
                      onPressed: () async {
                        final imageFilePath = await imagePicker.pickImage(
                          source: ImageSource.camera,
                        );

                        setState(() {
                          thumbnail = imageFilePath;
                        });
                      },
                      child: StyledText(
                        thumbnail == null ? 'Upload a photo' : 'Change photo',
                      ),
                    ),
                  ),

                  const SizedBox(height: 30),

                  // Ingredients
                  StyledTitle('Steps'),
                  SizedBox(height: 10),
                  // Add Steps
                  _steps.isNotEmpty
                      ? Stepper(
                          key: ValueKey(_steps.length),
                          physics: const NeverScrollableScrollPhysics(),
                          currentStep: _currentStep,
                          onStepTapped: (step) {
                            setState(() {
                              _currentStep = step;
                            });

                            WidgetsBinding.instance.addPostFrameCallback((_) {
                              final context = _stepKeys[step].currentContext;
                              if (context != null) {
                                Scrollable.ensureVisible(
                                  context,
                                  alignment: 0.2,
                                  duration: const Duration(milliseconds: 300),
                                );
                              }
                            });
                          },
                          steps: _steps.asMap().entries.map((entry) {
                            return Step(
                              isActive: _currentStep == entry.key,
                              title: StyledTitle('Step${entry.key + 1}'),
                              content: SizedBox(
                                key: _stepKeys[entry.key],
                                width: double.infinity,
                                child: StyledText(entry.value.instruction),
                              ),
                            );
                          }).toList(),
                          controlsBuilder: (context, details) {
                            return SizedBox.shrink();
                          },
                        )
                      : StyledText(
                          'Please add steps.',
                          color: stepesEmptyError
                              ? const Color.fromARGB(255, 182, 25, 13)
                              : null,
                        ),

                  const SizedBox(height: 20),
                  // Add a step button
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      ElevatedButton(
                        onPressed: () {
                          showModalBottomSheet(
                            context: context,
                            isScrollControlled: true,
                            builder: (BuildContext context) {
                              return AddStepsSheet(
                                onAdd: (RecipeStep step) {
                                  setState(() {
                                    _steps.add(step);
                                    _stepKeys = List.generate(
                                      _steps.length,
                                      (index) => GlobalKey(),
                                    );
                                  });
                                },
                                initialStepNumber: _steps.length + 1,
                              );
                            },
                          );
                        },
                        child: StyledText('Add a step'),
                      ),

                      const SizedBox(width: 20),

                      // Remove all button
                      ElevatedButton(
                        onPressed: () {
                          setState(() {
                            _steps.clear();
                            _stepKeys = [];
                          });
                        },
                        child: StyledText('Remove all steps'),
                      ),
                    ],
                  ),

                  const SizedBox(height: 100),

                  // Submit button
                  Center(
                    child: FilledButton(
                      onPressed: onSubmit,
                      child: StyledText('Submit'),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
