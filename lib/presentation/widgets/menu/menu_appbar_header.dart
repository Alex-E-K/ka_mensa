import 'package:flutter/material.dart';
import 'package:ka_mensa/presentation/widgets/spacer.dart';

class MenuAppbarHeader extends StatelessWidget {
  final String _date;
  final String _canteenName;

  const MenuAppbarHeader(
      {Key? key, required String date, required String canteenName})
      : _date = date,
        _canteenName = canteenName,
        super(key: key);

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        IconButton(
          onPressed: () {},
          icon: const Icon(Icons.arrow_back_ios),
          // splashColor: Colors.transparent,
          // highlightColor: Colors.transparent,
        ),
        spacer(0, 15),
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
        spacer(0, 15),
        IconButton(
          onPressed: () {},
          icon: const Icon(Icons.arrow_forward_ios),
          // splashColor: Colors.transparent,
          // highlightColor: Colors.transparent,
        ),
      ],
    );
  }
}
