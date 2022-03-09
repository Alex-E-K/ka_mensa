import 'package:flutter/material.dart';
import 'package:ka_mensa/presentation/widgets/spacer.dart';

class CanteenSelectorButton extends StatelessWidget {
  const CanteenSelectorButton({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {},
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 8),
        child: ListTile(
          title: Text('Select canteen'),
          trailing: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              spacer(0, 8),
              const Icon(Icons.arrow_forward_ios),
            ],
          ),
        ),
      ),
    );
  }
}
