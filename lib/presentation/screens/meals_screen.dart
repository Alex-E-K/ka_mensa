import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_date_pickers/flutter_date_pickers.dart';
import 'package:flutter_material_pickers/flutter_material_pickers.dart';
import 'package:html/parser.dart';
import 'package:intl/intl.dart';
import 'package:ka_mensa/presentation/widgets/menu/single_day_picker.dart';
import 'package:ka_mensa/presentation/widgets/spacer.dart';
import 'package:simple_gesture_detector/simple_gesture_detector.dart';
import '../../data/constants/canteens.dart';
import '../../data/constants/roles.dart';
import '../../data/repositories/canteen_repository.dart';
import '../../logic/canteen_bloc/canteen_bloc.dart';
import '../../logic/canteen_bloc/canteen_event.dart';
import '../widgets/loading_widget.dart';
import '../widgets/menu/day_menu.dart';
import '../widgets/menu/menu_appbar_header.dart';
import '../widgets/menu/menu_category_heading.dart';
import 'package:klocalizations_flutter/klocalizations_flutter.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../logic/canteen_bloc/canteen_state.dart';

/// Class that manages the display of menus. It uses the [CanteenBloc] in order
/// to display the menus, a loading screen or an error page depending on the
/// state managed by the bloc.
class MealsScreen extends StatefulWidget {
  const MealsScreen({Key? key}) : super(key: key);

  @override
  State<MealsScreen> createState() => _MealsScreenState();
}

class _MealsScreenState extends State<MealsScreen> {
  late CanteenBloc canteenBloc;
  List<Map<String, dynamic>> _dayMenus = [];
  List<String> _dates = [];
  String _canteenName = 'loading';
  String _roleName = 'students';
  int dayIndex = 0;
  String date = DateFormat('yyyy-MM-dd').format(DateTime.now());
  DateTime selectedDate =
      DateTime.parse(DateFormat('yyyy-MM-dd').format(DateTime.now()));
  bool previousDayDisabled = true;
  bool nextDayDisabled = true;
  ScrollController scrollController = ScrollController(initialScrollOffset: 0);

  /// Inits the UI by starting the fetch of data when the widget is drawn to the
  /// screen the first time.
  @override
  void initState() {
    super.initState();
    canteenBloc = BlocProvider.of<CanteenBloc>(context);
    canteenBloc.add(FetchCanteenMenusEvent());
  }

  @override
  Widget build(BuildContext context) {
    // Needed for localizing the UI.
    final KLocalizations localizations = KLocalizations.of(context);

    // Actual screen that is visible to the user.
    return Scaffold(
      appBar: AppBar(
        title: InkWell(
          onTap: () {
            List<DateTime> parsedDates = [];
            for (String singleDate in _dates) {
              parsedDates.add(DateTime.parse(singleDate));
            }

            selectedDate = DateTime.parse(date);

            showMaterialResponsiveDialog(
                title: localizations.translate('menu.dateSelectorPane.title'),
                confirmText: localizations
                    .translate('menu.dateSelectorPane.okButtonTitle'),
                cancelText: localizations
                    .translate('menu.dateSelectorPane.cancelButtonTitle'),
                context: context,
                onConfirmed: () {
                  int newDayIndex = getDayIndex(selectedDate, parsedDates);
                  if (newDayIndex == -1) {
                    dayIndex = 0;
                  } else {
                    dayIndex = newDayIndex;
                  }

                  if (selectedDate != DateTime.parse(date)) {
                    scrollController.animateTo(0,
                        duration: const Duration(milliseconds: 100),
                        curve: Curves.linear);
                  }

                  setDate();
                },
                child: SingleDayPicker(
                    selectedDate: selectedDate,
                    parsedDates: parsedDates,
                    callback: updateSelectedDate));
          },
          child: MenuAppbarHeader(
            date: DateFormat('dd.MM.yyyy').format(DateTime.parse(date)),
            canteenName:
                localizations.translate('menu.canteenName.$_canteenName'),
            previousDay: _previousDay,
            nextDay: _nextDay,
            previousDayDisabled: previousDayDisabled,
            nextDayDisabled: nextDayDisabled,
          ),
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
            _getRoleName();
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
            if (_dayMenus.isEmpty) {
              canteenBloc.add(FetchCanteenMenusEvent());
              return loading();
            } else {
              return SimpleGestureDetector(
                onHorizontalSwipe: _onHorizontalSwipe,
                swipeConfig: const SimpleSwipeConfig(
                    horizontalThreshold: 40,
                    swipeDetectionBehavior:
                        SwipeDetectionBehavior.continuousDistinct),
                child: DayMenu(
                  dayMenu: _dayMenus.elementAt(dayIndex),
                  role: _roleName,
                  scrollController: scrollController,
                ),
              );
            }
          } else {
            return Scaffold(
              body: Padding(
                padding: const EdgeInsets.all(20.0),
                child: Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        localizations.translate('menu.error'),
                        textAlign: TextAlign.center,
                      ),
                      spacer(25, 0),
                      Text(localizations.translate('menu.error2'),
                          textAlign: TextAlign.center),
                    ],
                  ),
                ),
              ),
            );
          }
        }),
      ),
    );
  }

  /// Updates the date to the selection from the date picker screen
  void updateSelectedDate(DateTime newDate) {
    selectedDate = newDate;
  }

  /// Returns the index of the given [day] within the list of available
  /// [parsedDates]
  int getDayIndex(DateTime day, List<DateTime> parsedDates) {
    for (int i = 0; i < parsedDates.length; i++) {
      if (day == parsedDates[i]) {
        return i;
      }
    }

    return -1;
  }

  /// Switches between days based on the horizontal swipe direction
  void _onHorizontalSwipe(SwipeDirection direction) {
    if (direction == SwipeDirection.left) {
      _nextDay();
    } else {
      _previousDay();
    }
  }

  /// Jumps a day before the current selected day if data is available for a
  /// previous day, else jumps to the first available day.
  void _previousDay() {
    if (dayIndex <= 0) {
      dayIndex = 0;
    } else {
      dayIndex--;
      scrollController.animateTo(0,
          duration: const Duration(milliseconds: 100), curve: Curves.linear);
    }
    setDate();
  }

  /// Jumps a day after the current selected day if data is available for a
  /// later day, else jumps to the last available day.
  void _nextDay() {
    if (dayIndex >= _dates.length - 1) {
      dayIndex = _dates.length - 1;
    } else {
      dayIndex++;
      scrollController.animateTo(0,
          duration: const Duration(milliseconds: 100), curve: Curves.linear);
    }
    setDate();
  }

  /// Disables and enables the buttons to jump between days and sets the display
  /// date to the selected date.
  void setDate() {
    previousDayDisabled = dayIndex == 0;
    nextDayDisabled = dayIndex == _dates.length - 1;
    date = _dates[dayIndex];
    setState(() {});
  }

  /// Loads the selected canteen from persistent storage.
  void _getCanteenName() async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    _canteenName = canteens[preferences.getInt('selectedCanteen') ?? 0].name;
  }

  /// Loads the selected role from persistent storage.
  void _getRoleName() async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    _roleName =
        roles[preferences.getInt('selectedRole') ?? 0].name.toLowerCase() + 's';
  }

  /// Splits the [daysMap] into unique [Map] which contain only meal data for a
  /// specific date and returns a List of these maps in order to display only
  /// the relevant information for the selected date.
  List<Map<String, dynamic>> splitDayMenus(Map<String, dynamic> daysMap) {
    List<Map<String, dynamic>> daysList = [];
    for (var day in daysMap.keys) {
      daysList.add(daysMap[day]);
    }
    return daysList;
  }

  /// Splits the [daysMap] into a list which only contains available dates as
  /// elements.
  List<String> splitDates(Map<String, dynamic> daysMap) {
    List<String> dates = [];
    for (var date in daysMap.keys) {
      dates.add(date);
    }
    return dates;
  }
}
