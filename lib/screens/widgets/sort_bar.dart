import 'package:flutter/material.dart';

class SortBar extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      child: Row(
        children: [
          Text(
            'Сортировка:',
            style: Theme.of(context).textTheme.subtitle2,
          ),
          Spacer(),
          TextButton(
            onPressed: () {},
            child: Text(
              'Сумма ↓',
              style: Theme.of(context).textTheme.subtitle2.copyWith(
                    color: Theme.of(context).primaryColor,
                  ),
            ),
          ),
        ],
      ),
    );
  }
}
