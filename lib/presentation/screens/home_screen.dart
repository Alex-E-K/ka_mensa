import 'package:flutter/material.dart';
import 'package:ka_mensa/presentation/screens/meals_screen.dart';
import 'package:ka_mensa/presentation/screens/settings_screen.dart';
import 'package:klocalizations_flutter/klocalizations_flutter.dart';

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
    // Needed for localizing the UI.
    final KLocalizations localizations = KLocalizations.of(context);

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
              label: localizations.translate('bottomNavigationBar.menu')),
          BottomNavigationBarItem(
              icon: const Icon(Icons.settings),
              label: localizations.translate('bottomNavigationBar.settings')),
        ],
      ),
    );
  }
}
