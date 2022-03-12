import 'package:flutter/material.dart';
import 'package:ka_mensa/presentation/widgets/spacer.dart';

class SpecificMenu extends StatelessWidget {
  final Map<String, dynamic> _specificMenu;
  final bool _isLast;
  const SpecificMenu(
      {Key? key,
      required Map<String, dynamic> specificMenu,
      required bool isLast})
      : _specificMenu = specificMenu,
        _isLast = isLast,
        super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: _isLast
          ? const EdgeInsets.only(left: 8.0, bottom: 8.0, right: 8.0)
          : const EdgeInsets.symmetric(horizontal: 8.0),
      child: Card(
        margin: EdgeInsets.zero,
        elevation: 5,
        shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.only(
                bottomLeft: _isLast
                    ? const Radius.circular(8)
                    : const Radius.circular(0),
                bottomRight: _isLast
                    ? const Radius.circular(8)
                    : const Radius.circular(0))),
        child: Padding(
          padding: const EdgeInsets.all(10.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Row(
                children: [
                  Expanded(
                    child: Column(
                      children: [
                        Row(
                          children: [
                            Flexible(
                              child: Text(_specificMenu['name']),
                              flex: 15,
                            ),
                            const Spacer(),
                          ],
                        ),
                        if (!_specificMenu['notes'].isEmpty) ...[
                          Row(
                            children: [
                              Flexible(
                                child: Text(
                                  _specificMenu['notes'].toString(),
                                  style: Theme.of(context)
                                      .textTheme
                                      .bodySmall
                                      ?.merge(const TextStyle(
                                          color: Colors.black38)),
                                ),
                                flex: 15,
                              ),
                              const Spacer(),
                            ],
                          )
                        ],
                      ],
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(left: 8.0),
                    child: Text('${_specificMenu['prices']['students']}€'),
                  )
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
