import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:ka_mensa/data/repositories/canteen_repository.dart';
import 'package:ka_mensa/presentation/widgets/menu/menu_appbar_header.dart';

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
        title: MenuAppbarHeader(
          date: DateFormat('yyyy-MM-dd').format(DateTime.now()),
          canteenName: 'Test',
        ),
        centerTitle: true,
        actions: [
          IconButton(
              onPressed: () async {
                CanteenRepository repo = CanteenRepository();
                await repo.getMenu();
              },
              icon: const Icon(Icons.refresh)),
        ],
      ),
      body: const Center(
        child: Text('Meals'),
      ),
    );
  }
}
