enum Units {
  grams('g'),
  milliliters('ml'),
  cups('cup(s)'),
  teaspoon('tsp'),
  tablespoon('tbsp'),
  piece('pc'),
  liters('L'),
  none('');

  // This allows you to store a short string in Firestore
  final String label;
  const Units(this.label);
}
