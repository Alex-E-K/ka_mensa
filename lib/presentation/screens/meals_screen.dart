import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'package:ka_mensa/data/constants/canteens.dart';
import 'package:ka_mensa/data/repositories/canteen_repository.dart';
import 'package:ka_mensa/logic/canteen_bloc/canteen_bloc.dart';
import 'package:ka_mensa/logic/canteen_bloc/canteen_event.dart';
import 'package:ka_mensa/presentation/widgets/loading_widget.dart';
import 'package:ka_mensa/presentation/widgets/menu/day_menu.dart';
import 'package:ka_mensa/presentation/widgets/menu/menu_appbar_header.dart';
import 'package:ka_mensa/presentation/widgets/menu/menu_category_heading.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../logic/canteen_bloc/canteen_state.dart';

class MealsScreen extends StatefulWidget {
  MealsScreen({Key? key}) : super(key: key);

  @override
  State<MealsScreen> createState() => _MealsScreenState();
}

class _MealsScreenState extends State<MealsScreen> {
  late CanteenBloc canteenBloc;
  List<Map<String, dynamic>> _dayMenus = [];
  List<String> _dates = [];
  String _canteenName = 'Loading ...';
  int dayIndex = 0;
  String date = DateFormat('yyyy-MM-dd').format(DateTime.now());
  bool previousDayDisabled = true;
  bool nextDayDisabled = true;

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
          date: DateFormat('dd.MM.yyyy').format(DateTime.parse(date)),
          canteenName: _canteenName,
          previousDay: _previousDay,
          nextDay: _nextDay,
          previousDayDisabled: previousDayDisabled,
          nextDayDisabled: nextDayDisabled,
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
          } else if (state is CanteenLoadingSuccessfulState) {
            _dates = splitDates(state.menus);
            _dayMenus = splitDayMenus(state.menus);
            _getCanteenName();
            if (_dates.isEmpty) {
              previousDayDisabled = true;
              nextDayDisabled = true;
              _canteenName = 'No data available';
            } else {
              date = _dates[dayIndex];
              previousDayDisabled = dayIndex == 0;
              nextDayDisabled = dayIndex == _dates.length - 1;
            }
            setState(() {});
          } else if (state is CanteenLoadingState) {
            date = DateFormat('yyyy-MM-dd').format(DateTime.now());
            previousDayDisabled = true;
            nextDayDisabled = true;
            dayIndex = 0;
            setState(() {});
          }
        },
        child:
            BlocBuilder<CanteenBloc, CanteenState>(builder: (context, state) {
          if (state is CanteenInitialState) {
            return loading();
          } else if (state is CanteenLoadingState) {
            return loading();
          } else if (state is CanteenLoadingSuccessfulState) {
            return DayMenu(dayMenu: _dayMenus.elementAt(dayIndex));
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

  void _previousDay() {
    if (dayIndex <= 0) {
      dayIndex = 0;
    } else {
      dayIndex--;
    }
    setDate();
  }

  void _nextDay() {
    if (dayIndex >= _dates.length - 1) {
      dayIndex = _dates.length - 1;
    } else {
      dayIndex++;
    }
    setDate();
  }

  void setDate() {
    previousDayDisabled = dayIndex == 0;
    nextDayDisabled = dayIndex == _dates.length - 1;
    date = _dates[dayIndex];
    setState(() {});
  }

  void _getCanteenName() async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    _canteenName = canteens[preferences.getInt('selectedCanteen') ?? 0].name;
  }

  List<Map<String, dynamic>> splitDayMenus(Map<String, dynamic> daysMap) {
    List<Map<String, dynamic>> daysList = [];
    for (var day in daysMap.keys) {
      daysList.add(daysMap[day]);
    }
    return daysList;
  }

  List<String> splitDates(Map<String, dynamic> daysMap) {
    List<String> dates = [];
    for (var date in daysMap.keys) {
      dates.add(date);
    }
    return dates;
  }
}
