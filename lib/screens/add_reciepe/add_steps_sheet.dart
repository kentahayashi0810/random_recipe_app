import 'package:flutter/material.dart';
import 'package:random_recipe_app/screens/add_reciepe/recipe_step.dart';
import 'package:random_recipe_app/shrared/styled_text.dart';
import 'package:random_recipe_app/shrared/styled_title.dart';

class AddStepsSheet extends StatefulWidget {
  const AddStepsSheet({
    super.key,
    required this.onAdd,
    required this.initialStepNumber,
  });

  final Function(RecipeStep) onAdd;
  final int initialStepNumber;

  @override
  State<AddStepsSheet> createState() => _AddStepsSheetState();
}

class _AddStepsSheetState extends State<AddStepsSheet> {
  final _formGlobalKey = GlobalKey<FormState>();

  String _instructionText = '';
  late int _stepNumber;

  void handleSubmit() {
    if (_formGlobalKey.currentState!.validate()) {
      _formGlobalKey.currentState!.save();
      widget.onAdd(RecipeStep(instruction: _instructionText));

      _formGlobalKey.currentState!.reset();

      setState(() {
        _stepNumber++;
      });
    }
  }

  @override
  void initState() {
    super.initState();
    _stepNumber = widget.initialStepNumber;
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 16),
      height: 220 + MediaQuery.of(context).viewInsets.bottom,
      child: Form(
        key: _formGlobalKey,
        child: Column(
          children: [
            const SizedBox(height: 20),
            StyledTitle('Add a step'),
            const SizedBox(height: 20),

            TextFormField(
              decoration: InputDecoration(
                label: StyledText('Step$_stepNumber'),
              ),
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return "Instruction can't be empty.";
                }
                return null;
              },
              onSaved: (newValue) {
                _instructionText = newValue!;
              },
            ),

            const SizedBox(height: 20),
            FilledButton(onPressed: handleSubmit, child: StyledText('Add')),
          ],
        ),
      ),
    );
  }
}
