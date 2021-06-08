import 'package:flutter/material.dart';

class ResultInfoLine extends StatelessWidget {
  const ResultInfoLine({
    Key key,
    @required this.title,
    @required this.data,
    @required this.measure,
  }) : super(key: key);

  final String title;
  final dynamic data;
  final String measure;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 10),
      child: Row(
        children: [
          Text(
            title,
            style: Theme.of(context).textTheme.bodyText1.copyWith(
                  color: Theme.of(context).shadowColor,
                ),
          ),
          Spacer(),
          Text(
            data.toString(),
            style: Theme.of(context).textTheme.headline1.copyWith(
                  fontSize: 40,
                  color: Theme.of(context).shadowColor,
                ),
          ),
          SizedBox(width: 4),
          Container(
            width: 55,
            child: Text(
              measure,
              style: Theme.of(context).textTheme.bodyText1,
              textAlign: TextAlign.end,
            ),
          ),
        ],
      ),
    );
  }
}
