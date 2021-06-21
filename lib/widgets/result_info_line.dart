import 'package:flutter/material.dart';

class ResultInfoLine extends StatelessWidget {
  const ResultInfoLine({
    Key key,
    @required this.title,
    @required this.data,
    @required this.measure,
    @required this.viewFullNumber,
  }) : super(key: key);

  final String title;
  final dynamic data;
  final String measure;
  final ValueNotifier<bool> viewFullNumber;

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 10),
      child: Row(
        children: [
          Container(
            width: size.width * 0.4,
            child: Text(
              title,
              style: Theme.of(context).textTheme.bodyText1.copyWith(
                    color: Theme.of(context).shadowColor,
                  ),
              overflow: TextOverflow.ellipsis,
            ),
          ),
          Spacer(),
          Container(
            width: size.width * 0.3,
            child: Text(
              data.toString(),
              textAlign: TextAlign.end,
              style: Theme.of(context).textTheme.headline1.copyWith(
                    fontSize: 40,
                    color: Theme.of(context).shadowColor,
                  ),
              overflow: viewFullNumber.value
                  ? TextOverflow.visible
                  : TextOverflow.ellipsis,
            ),
          ),
          SizedBox(width: 4),
          Container(
            width: 55,
            child: Text(
              measure,
              style: Theme.of(context).textTheme.bodyText1,
              overflow: TextOverflow.ellipsis,
              textAlign: TextAlign.end,
            ),
          ),
        ],
      ),
    );
  }
}
