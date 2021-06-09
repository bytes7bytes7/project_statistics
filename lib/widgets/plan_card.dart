import 'package:flutter/material.dart';

class PlanCard extends StatelessWidget {
  const PlanCard({
    Key key,
    @required this.title,
    @required this.children,
  }) : super(key: key);

  final String title;
  final List<Widget> children;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 15),
      padding: const EdgeInsets.only(bottom: 30),
      width: double.infinity,
      decoration: BoxDecoration(
        color: Theme.of(context).focusColor,
        borderRadius: BorderRadius.circular(15),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.5),
            spreadRadius: 1,
            blurRadius: 5,
            offset: Offset(4, 4),
          ),
        ],
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 25, vertical: 15),
        child: Column(
          children: [
            Text(
              title,
              style: Theme.of(context).textTheme.headline2,
            ),
            SizedBox(height: 15),
            for (var child in children) child,
          ],
        ),
      ),
    );
  }
}
