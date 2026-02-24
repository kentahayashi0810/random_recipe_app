import 'package:flutter/material.dart';
import 'package:random_recipe_app/models/recipe.dart';
import 'package:random_recipe_app/shrared/styled_text.dart';
import 'package:random_recipe_app/shrared/styled_title.dart';

class StepsScreen extends StatefulWidget {
  const StepsScreen({super.key, required this.recipe});

  final Recipe recipe;

  @override
  State<StepsScreen> createState() => _StepsScreenState();
}

class _StepsScreenState extends State<StepsScreen> {
  final ScrollController _scrollController = ScrollController();

  int _currentStep = 0;

  late final List<GlobalKey> _stepKeys;

  @override
  void initState() {
    super.initState();
    _stepKeys = List.generate(
      widget.recipe.recipeSteps.length,
      (index) => GlobalKey(),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: SingleChildScrollView(
        controller: _scrollController,
        child: widget.recipe.recipeSteps.isNotEmpty
            ? Stepper(
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
                steps: widget.recipe.recipeSteps.asMap().entries.map((entry) {
                  return Step(
                    isActive: _currentStep == entry.key,
                    title: StyledTitle('Step${entry.key + 1}'),
                    content: SizedBox(
                      width: double.infinity,
                      key: _stepKeys[entry.key],
                      child: StyledText(entry.value.instruction),
                    ),
                  );
                }).toList(),
                controlsBuilder: (context, details) {
                  return SizedBox.shrink();
                },
              )
            : const SizedBox(),
      ),
    );
  }
}
