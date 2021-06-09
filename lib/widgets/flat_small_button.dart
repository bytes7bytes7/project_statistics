import 'package:flutter/material.dart';

class FlatSmallButton extends StatelessWidget {
  const FlatSmallButton({
    Key key,
    @required this.title,
    @required this.onTap,
  }) : super(key: key);

  final String title;
  final Function onTap;

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(15),
      child: Material(
        child: InkWell(
          onTap: onTap,
          child: FittedBox(
            child: Container(
              padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 30),
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
