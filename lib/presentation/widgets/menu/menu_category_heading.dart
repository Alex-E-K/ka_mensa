import 'package:flutter/material.dart';

class MenuCategoryHeading extends StatelessWidget {
  final String _headingText;

  const MenuCategoryHeading({Key? key, required String headingText})
      : _headingText = headingText,
        super(key: key);

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          _headingText,
          style: Theme.of(context)
              .textTheme
              .titleMedium
              ?.merge(const TextStyle(decoration: TextDecoration.underline)),
        ),
      ],
    );
  }
}
