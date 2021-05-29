import 'package:flutter/material.dart';

void showInfoSnackBar({
  @required BuildContext context,
  @required String info,
  @required IconData icon,
}) {
  ScaffoldMessenger.of(context).showSnackBar(
    SnackBar(
      backgroundColor: Theme.of(context).primaryColor.withOpacity(0.8),
      duration: const Duration(seconds: 1),
      content: Row(
        children: [
          Text(
            info,
            style: Theme.of(context).textTheme.bodyText1.copyWith(
                  color: Theme.of(context).focusColor,
                ),
          ),
          Spacer(),
          Icon(
            icon,
            color: Theme.of(context).focusColor,
          ),
        ],
      ),
    ),
  );
}
