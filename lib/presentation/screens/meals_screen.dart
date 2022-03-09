import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class MealsScreen extends StatefulWidget {
  const MealsScreen({Key? key}) : super(key: key);

  @override
  State<MealsScreen> createState() => _MealsScreenState();
}

class _MealsScreenState extends State<MealsScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
      title: Text(DateFormat('yyyy-MM-dd').format(DateTime.now())),
        centerTitle: true,
      ),
      body: const Center(
        child: Text('Meals'),
      ),
    );
  }
}
