import 'package:random_recipe_app/models/units.dart';

class Ingredient {
  Ingredient({required this.name, required this.amount, required this.unit});
  final String name;
  final double amount;
  final Units unit;

  @override
  String toString() {
    return '$formattedAmount${unit.label} ${unit == Units.none ? '' : 'of'} $name';
  }

  String get formattedAmount {
    if (amount % 1 == 0) {
      return amount.toInt().toString();
    }
    return amount.toString();
  }

  factory Ingredient.fromMap(Map<String, dynamic> map) {
    return Ingredient(
      name: map['name'] as String,
      amount: map['amount'] as double,
      // Converting the string "grams" back into your Unit.grams enum
      unit: Units.values.firstWhere((e) => e.name == map['unit']),
    );
  }
}
