import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:ka_mensa/data/repositories/canteen_repository.dart';
import 'package:ka_mensa/logic/canteen_bloc/canteen_bloc.dart';

import '../screens/home_screen.dart';

class AppRouter {
  Route onGenerateRoute(RouteSettings routeSettings) {
    switch (routeSettings.name) {
      case '/':
        return MaterialPageRoute(builder: (_) {
          return BlocProvider<CanteenBloc>(
            create: (context) => CanteenBloc(repository: CanteenRepository()),
            child: const HomeScreen(),
          );
        });
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
