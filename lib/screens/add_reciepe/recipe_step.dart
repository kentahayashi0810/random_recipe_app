class RecipeStep {
  RecipeStep({required this.instruction});

  final String instruction;

  factory RecipeStep.fromMap(Map<String, dynamic> map) {
    return RecipeStep(instruction: map['instruction'] as String);
  }
}
