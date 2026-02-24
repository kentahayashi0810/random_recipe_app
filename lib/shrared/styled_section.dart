import 'package:flutter/material.dart';
import 'package:random_recipe_app/shrared/styled_title.dart';

class StyledSection extends StatelessWidget {
  const StyledSection({
    super.key,
    required this.title,
    required this.contentWidget,
    this.rightEndWidget,
  });

  final String title;
  final Widget contentWidget;
  final Widget? rightEndWidget;

  @override
  Widget build(BuildContext context) {
    final rightWidget = rightEndWidget;
    return Stack(
      clipBehavior: Clip.none,
      children: [
        Container(
          width: double.infinity,
          padding: EdgeInsets.all(16) + EdgeInsets.only(top: 20),
          decoration: BoxDecoration(
            border: Border(
              left: BorderSide(
                color: Colors.black12,
                style: BorderStyle.solid,
                width: 2.0,
              ),
              right: BorderSide(
                color: Colors.black12,
                style: BorderStyle.solid,
                width: 2.0,
              ),
              bottom: BorderSide(
                color: Colors.black12,
                style: BorderStyle.solid,
                width: 2.0,
              ),
            ),
          ),
          child: contentWidget,
        ),
        Positioned(
          top: -10,
          left: 0,
          right: 0,
          child: Container(
            padding: EdgeInsets.symmetric(horizontal: 16),
            child: Row(
              children: [
                StyledTitle(title),
                Expanded(child: SizedBox()),
                if (rightWidget != null) rightWidget,
              ],
            ),
          ),
        ),
      ],
    );
  }
}
