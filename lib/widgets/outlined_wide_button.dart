import 'package:flutter/material.dart';

class OutlinedWideButton extends StatelessWidget {
  const OutlinedWideButton({
    Key key,
    @required this.title,
    @required this.onTap,
  }) : super(key: key);

  final String title;
  final Function onTap;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 0,  vertical: 10),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(15),
        child: Material(
          child: InkWell(
            highlightColor: Theme.of(context).primaryColor.withOpacity(0.5),
            onTap: onTap,
            child: Container(
              padding: const EdgeInsets.symmetric(vertical: 8),
              decoration: BoxDecoration(
                color: Colors.transparent,
                borderRadius: BorderRadius.circular(15),
                border: Border.all(
                  color: Theme.of(context).shadowColor,
                  width: 2,
                ),
              ),
              child: Center(
                child: Text(
                  title,
                  style: Theme.of(context).textTheme.headline2,
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
