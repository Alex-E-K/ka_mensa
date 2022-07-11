import 'package:flutter/material.dart';
import 'package:flutter_date_pickers/flutter_date_pickers.dart';
import 'package:intl/intl.dart';

/// Class that manages the date picker for the mnu screen
class SingleDayPicker extends StatefulWidget {
  DateTime _selectedDate;
  List<DateTime> _parsedDates;
  final void Function(DateTime) _callback;

  /// Constructor that takes the currently selected/presented date
  /// [selectedDate], a list of all available dates [parsedDates] and a
  /// callback function [callback], which allows to update the selection on
  /// another screen.
  SingleDayPicker(
      {required DateTime selectedDate,
      required List<DateTime> parsedDates,
      required Function(DateTime) callback,
      Key? key})
      : _selectedDate = selectedDate,
        _parsedDates = parsedDates,
        _callback = callback,
        super(key: key);

  @override
  State<SingleDayPicker> createState() => _SingleDayPickerState();
}

class _SingleDayPickerState extends State<SingleDayPicker> {
  @override
  Widget build(BuildContext context) {
    return DayPicker.single(
        selectedDate: widget._selectedDate,
        onChanged: _onSelectedDateChanged,
        firstDate: widget._parsedDates.first,
        lastDate: widget._parsedDates.last,
        selectableDayPredicate: (DateTime day) {
          DateTime newDay =
              DateTime.parse(DateFormat('yyyy-MM-dd').format(day));

          return _isSelectableDay(newDay, widget._parsedDates);
        });
  }

  /// Updates the UI with the selection [newDate] and calls the callback
  /// function to update the value on another screen as well.
  void _onSelectedDateChanged(DateTime newDate) {
    widget._selectedDate = newDate;
    widget._callback(newDate);
    setState(() {});
  }

  /// Returns true if a date should be selectable, false otherwise. Only dates
  /// which are in the list of [selectableDates] will be selectable within the
  /// picker.
  bool _isSelectableDay(DateTime day, List<DateTime> selectableDates) {
    if (selectableDates.contains(day)) {
      return true;
    } else {
      return false;
    }
  }
}
