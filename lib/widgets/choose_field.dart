import 'package:flutter/material.dart';

class ChooseField extends StatelessWidget {
  const ChooseField({
    Key key,
    @required this.label,
    @required this.chooseLabel,
    @required this.group,
    @required this.controller,
  }) : super(key: key);

  final String label;
  final String chooseLabel;
  final List<String> group;
  final TextEditingController controller;

  Future<void> showChooseDialog(BuildContext context) async {
    return showDialog<void>(
      context: context,
      barrierDismissible: true,
      builder: (BuildContext context) {
        return AlertDialog(
          backgroundColor: Theme.of(context).scaffoldBackgroundColor,
          title: Center(
            child: Text(
              chooseLabel,
              style: Theme.of(context).textTheme.headline2,
            ),
          ),
          contentPadding: const EdgeInsets.symmetric(horizontal: 10,vertical: 14),
          content: SingleChildScrollView(
            child: ListBody(
              children: group.map<Widget>((e) {
                return Card(
                  child: ListTile(
                    onTap: () {
                      controller.text = e;
                      Navigator.pop(context);
                    },
                    contentPadding: const EdgeInsets.all(0),
                    leading: Radio(
                      value: e,
                      groupValue: controller.text,
                      onChanged: (value) {
                        controller.text = e;
                        Navigator.pop(context);
                      },
                    ),
                    title: Text(
                      e,
                      style: Theme.of(context).textTheme.bodyText1,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                );
              }).toList(),
            ),
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: () {
          FocusScope.of(context).requestFocus(FocusNode());
          showChooseDialog(context);
        },
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 6),
          child: TextField(
            enabled: false,
            controller: controller,
            style: Theme.of(context).textTheme.bodyText1,
            decoration: InputDecoration(
              labelText: label,
              labelStyle: Theme.of(context).textTheme.subtitle1,
              contentPadding: const EdgeInsets.symmetric(horizontal: 10),
              disabledBorder: UnderlineInputBorder(
                borderSide: BorderSide(
                  color: Theme.of(context).disabledColor,
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
