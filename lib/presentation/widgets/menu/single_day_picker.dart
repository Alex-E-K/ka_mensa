import 'package:flutter/material.dart';
import 'package:flutter_date_pickers/flutter_date_pickers.dart';
import 'package:intl/intl.dart';

class SingleDayPicker extends StatefulWidget {
  DateTime _selectedDate;
  List<DateTime> _parsedDates;
  final void Function(DateTime) _callback;

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

  void _onSelectedDateChanged(DateTime newDate) {
    widget._selectedDate = newDate;
    widget._callback(newDate);
    setState(() {});
  }

  bool _isSelectableDay(DateTime day, List<DateTime> selectableDates) {
    if (selectableDates.contains(day)) {
      return true;
    } else {
      return false;
    }
  }
}
