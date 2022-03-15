import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../data/repositories/canteen_repository.dart';
import '../../logic/canteen_bloc/canteen_bloc.dart';

import '../screens/home_screen.dart';

/// This class provides the router for the app. There are currently no unique
/// routes available, but if necessary they can be added here.
class AppRouter {
  /// Method that takes [routeSettings] as input and pushes routes to the stack
  /// which will be displayed automatically.
  Route onGenerateRoute(RouteSettings routeSettings) {
    switch (routeSettings.name) {
      // Default route 'first layer' of the navigation stack
      case '/':
        return MaterialPageRoute(builder: (_) {
          return BlocProvider<CanteenBloc>(
            create: (context) => CanteenBloc(repository: CanteenRepository()),
            child: const HomeScreen(),
          );
        });
      // Route that will be displayed if the provided route couldn't be resolved.
      default:
        return MaterialPageRoute(builder: (_) => _errorPage());
    }
  }

  /// Widget that represents an error page which will be shown if the provided
  /// route couldn't be resolved.
  Widget _errorPage() {
    return const Scaffold(
      body: Center(
        child: Text('Error, something went wrong! Please restart the app.'),
      ),
    );
  }
}
