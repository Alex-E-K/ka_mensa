import 'package:flutter/material.dart';
import 'package:ka_mensa/presentation/screens/meals_screen.dart';
import 'package:ka_mensa/presentation/screens/settings_screen.dart';
import 'package:klocalizations_flutter/klocalizations_flutter.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _currentBottomNavbarIndex = 0;

  @override
  Widget build(BuildContext context) {
    final KLocalizations localizations = KLocalizations.of(context);

    final screens = [
      MealsScreen(),
      const SettingsScreen(),
    ];

    return Scaffold(
      body: screens[_currentBottomNavbarIndex],
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _currentBottomNavbarIndex,
        onTap: (index) => setState(() {
          _currentBottomNavbarIndex = index;
        }),
        items: [
          BottomNavigationBarItem(
              icon: const Icon(Icons.restaurant_menu),
              label: localizations.translate('bottomNavigationBar.menu')),
          BottomNavigationBarItem(
              icon: const Icon(Icons.settings),
              label: localizations.translate('bottomNavigationBar.settings')),
        ],
      ),
    );
  }
}
