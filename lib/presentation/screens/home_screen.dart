import 'package:flutter/material.dart';
import 'meals_screen.dart';
import 'settings_screen.dart';
import 'package:easy_localization/easy_localization.dart';

/// Class that represents the first layer of the navigation stack. It contains
/// the [BottomNavigationBar] to switch between the menu and the settings pages
/// and shows the respective page according to the user selection.
class HomeScreen extends StatefulWidget {
  /// Constructor for the widget.
  const HomeScreen({Key? key}) : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _currentBottomNavbarIndex = 0;

  @override
  Widget build(BuildContext context) {
    // Screens to display when the appropriate [BottomNavigationBarItem] is
    // pressed.
    final screens = [
      const MealsScreen(),
      const SettingsScreen(),
    ];

    // Actual screen that is visible to the user.
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
              label: tr('bottomNavigationBar.menu')),
          BottomNavigationBarItem(
              icon: const Icon(Icons.settings),
              label: tr('bottomNavigationBar.settings')),
        ],
      ),
    );
  }
}
