import 'package:flutter/material.dart';
import '../spacer.dart';

/// Class that manages the display of the [AppBar] used on the meals screen
class MenuAppbarHeader extends StatelessWidget {
  final String _date;
  final String _canteenName;
  final VoidCallback _previousDay;
  final VoidCallback _nextDay;
  final bool _previousDayDisabled;
  final bool _nextDayDisabled;

  /// Constructor of the class. Takes the [date] to display above the given
  /// [canteenName]. Takes a [VoidCallback] [previousDay] and [nextDay] to
  /// assign the forward and backwards buttons with and two [bool]s
  /// [previousDayDisabled] and [nextDayDisabled] to enable or disable forward
  /// and back buttons if necessary.
  const MenuAppbarHeader(
      {Key? key,
      required String date,
      required String canteenName,
      required VoidCallback previousDay,
      required VoidCallback nextDay,
      required bool previousDayDisabled,
      required bool nextDayDisabled})
      : _date = date,
        _canteenName = canteenName,
        _previousDay = previousDay,
        _nextDay = nextDay,
        _previousDayDisabled = previousDayDisabled,
        _nextDayDisabled = nextDayDisabled,
        super(key: key);

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        // Backwards Button
        IconButton(
          onPressed: _previousDayDisabled ? null : _previousDay,
          disabledColor: Colors.grey,
          icon: const Icon(Icons.arrow_back_ios),
          // splashColor: Colors.transparent,
          // highlightColor: Colors.transparent,
        ),
        spacer(0, 8),
        // Title containing the date and the canteen name
        Column(
          children: [
            Text(
              _date,
              style: Theme.of(context)
                  .textTheme
                  .titleMedium
                  ?.merge(const TextStyle(color: Colors.white)),
            ),
            Text(_canteenName,
                style: Theme.of(context)
                    .textTheme
                    .labelMedium
                    ?.merge(const TextStyle(color: Colors.white))),
          ],
        ),
        spacer(0, 8),
        // Forward button
        IconButton(
          onPressed: _nextDayDisabled ? null : _nextDay,
          disabledColor: Colors.grey,
          icon: const Icon(Icons.arrow_forward_ios),
          // splashColor: Colors.transparent,
          // highlightColor: Colors.transparent,
        ),
      ],
    );
  }
}
