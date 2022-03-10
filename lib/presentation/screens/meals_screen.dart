import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'package:ka_mensa/data/repositories/canteen_repository.dart';
import 'package:ka_mensa/logic/canteen_bloc/canteen_bloc.dart';
import 'package:ka_mensa/logic/canteen_bloc/canteen_event.dart';
import 'package:ka_mensa/presentation/widgets/loading_widget.dart';
import 'package:ka_mensa/presentation/widgets/menu/menu_appbar_header.dart';

import '../../logic/canteen_bloc/canteen_state.dart';

class MealsScreen extends StatefulWidget {
  const MealsScreen({Key? key}) : super(key: key);

  @override
  State<MealsScreen> createState() => _MealsScreenState();
}

class _MealsScreenState extends State<MealsScreen> {
  late CanteenBloc canteenBloc;

  @override
  void initState() {
    super.initState();
    canteenBloc = BlocProvider.of<CanteenBloc>(context);
    canteenBloc.add(FetchCanteenMenusEvent());
  }

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
              onPressed: () {
                canteenBloc.add(FetchCanteenMenusEvent());
              },
              icon: const Icon(Icons.refresh)),
        ],
      ),
      body: BlocListener<CanteenBloc, CanteenState>(
        listener: (context, state) {
          if (state is CanteenErrorState) {
            ScaffoldMessenger.of(context)
                .showSnackBar(SnackBar(content: Text(state.message)));
          }
        },
        child:
            BlocBuilder<CanteenBloc, CanteenState>(builder: (context, state) {
          if (state is CanteenInitialState) {
            return loading();
          } else if (state is CanteenLoadingState) {
            return loading();
          } else if (state is CanteenLoadingSuccessfulState) {
            return const Scaffold(
              body: Center(
                child: Text('Menus'),
              ),
            );
          } else {
            return const Scaffold(
              body: Center(
                child: Text('Error'),
              ),
            );
          }
        }),
      ),
    );
  }
}
