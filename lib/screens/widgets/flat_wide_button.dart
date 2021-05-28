import 'package:flutter/material.dart';

class FlatWideButton extends StatelessWidget {
  const FlatWideButton({
    Key key,
    @required this.title,
    @required this.onTap,
  }) : super(key: key);

  final String title;
  final Function onTap;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 0, vertical: 10),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(15),
        child: Material(
          child: InkWell(
            onTap: onTap,
            child: Container(
              padding: const EdgeInsets.symmetric(vertical: 8),
              decoration: BoxDecoration(
                color: Theme.of(context).primaryColor,
                borderRadius: BorderRadius.circular(15),
                border: Border.all(
                  color: Theme.of(context).primaryColor,
                  width: 2,
                ),
              ),
              child: Center(
                child: Text(
                  title,
                  style: Theme.of(context).textTheme.headline2.copyWith(
                        color: Theme.of(context).focusColor,
                      ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
