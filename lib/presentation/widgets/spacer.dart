import 'package:flutter/material.dart';

/// Takes a [height] and a [width] and returns a [SizedBox] with given
/// dimensions to use as a spacer between widgets.
Widget spacer(double height, double width) {
  return SizedBox(
    height: height,
    width: width,
  );
}
