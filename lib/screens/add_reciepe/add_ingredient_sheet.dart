import 'package:flutter/material.dart';
import 'package:random_recipe_app/models/ingredient.dart';
import 'package:random_recipe_app/models/units.dart';
import 'package:random_recipe_app/shrared/styled_text.dart';
import 'package:random_recipe_app/shrared/styled_title.dart';

class AddIngredientSheet extends StatefulWidget {
  const AddIngredientSheet({super.key, required this.onAdd});

  final Function(Ingredient) onAdd;

  @override
  State<AddIngredientSheet> createState() => _AddIngredientSheetState();
}

class _AddIngredientSheetState extends State<AddIngredientSheet> {
  final _formGlobalKey = GlobalKey<FormState>();

  String _name = '';
  double _amount = 0.0;
  Units _selectedUnit = Units.none;

  void handleSubmit() {
    if (_formGlobalKey.currentState!.validate()) {
      _formGlobalKey.currentState!.save();
      widget.onAdd(
        Ingredient(name: _name, amount: _amount, unit: _selectedUnit),
      );

      _formGlobalKey.currentState!.reset();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 16),
      height: 420 + MediaQuery.of(context).viewInsets.bottom,
      child: Form(
        key: _formGlobalKey,
        child: Column(
          children: [
            const SizedBox(height: 20),
            StyledTitle('Add an Ingredient'),
            const SizedBox(height: 20),

            TextFormField(
              maxLength: 20,
              decoration: const InputDecoration(label: StyledText('Name')),
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'You must enter a value for the name';
                }
                return null;
              },
              onSaved: (newValue) {
                _name = newValue!;
              },
            ),

            TextFormField(
              keyboardType: TextInputType.number,
              decoration: const InputDecoration(label: StyledText('Amount')),
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'You must enter a value for the amount';
                }

                if (double.tryParse(value) == null) {
                  return 'Please enter a valid number.';
                }
                if (double.tryParse(value)! <= 0.0) {
                  return 'The value has to be bigger than 0.';
                }
                return null;
              },
              onSaved: (newValue) {
                _amount = double.parse(newValue!);
              },
            ),

            const SizedBox(height: 20),

            Wrap(
              spacing: 8.0,
              children: Units.values.map((unit) {
                final isNone = unit == Units.none;
                final unitText = isNone ? 'No unit' : unit.label;
                return ChoiceChip(
                  label: StyledText(unitText),
                  selected: _selectedUnit == unit,
                  onSelected: (selected) {
                    if (selected) {
                      setState(() {
                        _selectedUnit = unit;
                      });
                    }
                  },
                );
              }).toList(),
            ),
            const SizedBox(height: 20),
            FilledButton(onPressed: handleSubmit, child: StyledText('Add')),
          ],
        ),
      ),
    );
  }
}
