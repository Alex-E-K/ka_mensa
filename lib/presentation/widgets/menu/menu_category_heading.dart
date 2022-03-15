import 'package:flutter/material.dart';

/// This class manages the display of a category heading
class MenuCategoryHeading extends StatelessWidget {
  final String _headingText;

  /// Constructor that takes the [headingText] that should be displayed
  const MenuCategoryHeading({Key? key, required String headingText})
      : _headingText = headingText,
        super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(left: 8.0, top: 8.0, right: 8.0),
      child: Card(
        margin: EdgeInsets.zero,
        elevation: 5,
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(8),
            topRight: Radius.circular(8),
          ),
        ),
        child: Padding(
          padding: const EdgeInsets.all(10.0),
          child: Center(
            child: Text(_headingText,
                style: Theme.of(context).textTheme.titleMedium
                // ?.merge(const TextStyle(decoration: TextDecoration.underline)),
                ),
          ),
        ),
      ),
    );
  }
}
