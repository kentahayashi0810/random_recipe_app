import 'package:flutter/material.dart';

class StyledText extends StatelessWidget {
  const StyledText(
    this.text, {
    super.key,
    this.textAlign = TextAlign.start,
    this.color,
  });

  final String text;
  final TextAlign textAlign;
  final Color? color;

  @override
  Widget build(BuildContext context) {
    return Text(
      textAlign: textAlign,
      style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500, color: color),
      text,
    );
  }
}
