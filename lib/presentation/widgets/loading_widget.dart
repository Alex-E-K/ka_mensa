import 'package:flutter/material.dart';

/// Widget that is used when something needs to load
Widget loading() {
  return const Scaffold(
    body: Center(
      child: CircularProgressIndicator(),
    ),
  );
}
