import 'package:flutter/material.dart';

class PercentBar extends StatelessWidget {
  const PercentBar({
    Key key,
    @required this.percent,
    @required this.color,
  }) : super(key: key);

  final int percent;
  final Color color;

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Container(
      height: 30,
      width: double.infinity,
      margin: const EdgeInsets.symmetric(vertical: 8),
      padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 4),
      decoration: BoxDecoration(
        color: color.withOpacity(.5),
        borderRadius: BorderRadius.circular(5),
      ),
      child: Stack(
        children: [
          Row(
            children: [
              if (percent > 0)
                Flexible(
                  flex: percent,
                  child: Container(
                    width: double.infinity,
                    decoration: BoxDecoration(
                      color: color,
                      borderRadius: BorderRadius.circular(5),
                    ),
                  ),
                ),
              if (percent < 100)
                Flexible(
                  flex: 100 - percent,
                  child: SizedBox(
                    width: double.infinity,
                  ),
                ),
            ],
          ),
          Positioned(
            child: Container(
              width: size.width*0.9,
              child: Text(
                '$percent %',
                style: Theme.of(context)
                    .textTheme
                    .bodyText1
                    .copyWith(color: Theme.of(context).focusColor),
                textAlign: TextAlign.center,
                overflow: TextOverflow.ellipsis,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
