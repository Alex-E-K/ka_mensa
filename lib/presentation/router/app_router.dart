import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../screens/home_screen.dart';

class AppRouter {
  Route onGenerateRoute(RouteSettings routeSettings) {
    switch (routeSettings.name) {
      case '/':
        return MaterialPageRoute(builder: (_) => const HomeScreen());
      default:
        return MaterialPageRoute(builder: (_) => _errorPage());
    }
  }

  Widget _errorPage() {
    return const Scaffold(
      body: Center(
        child: Text('Error, something went wrong! Please restart the app.'),
      ),
    );
  }
}
