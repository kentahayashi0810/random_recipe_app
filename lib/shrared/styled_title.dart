import 'package:flutter/material.dart';

class StyledTitle extends StatelessWidget {
  const StyledTitle(this.text, {super.key, this.textAlign = TextAlign.start});

  final String text;
  final TextAlign textAlign;

  @override
  Widget build(BuildContext context) {
    return Text(
      textAlign: textAlign,
      style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
      text,
    );
  }
}
