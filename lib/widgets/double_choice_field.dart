import 'package:flutter/material.dart';

class DoubleChoiceField extends StatelessWidget {
  const DoubleChoiceField({
    Key key,
    @required this.label,
    @required this.choiceLabel1,
    @required this.choiceLabel2,
    @required this.group1,
    @required this.group2,
    @required this.controller,
  }) : super(key: key);

  final String label;
  final String choiceLabel1;
  final String choiceLabel2;
  final List<String> group1;
  final List<String> group2;
  final TextEditingController controller;

  Future<void> showChoiceDialog(BuildContext context, int time) async {
    return showDialog<void>(
      context: context,
      barrierDismissible: (time==1),
      builder: (BuildContext context) {
        return AlertDialog(
          backgroundColor: Theme.of(context).scaffoldBackgroundColor,
          title: Center(
            child: Text(
              (time == 1) ? choiceLabel1 : choiceLabel2,
              style: Theme.of(context).textTheme.headline2,
            ),
          ),
          contentPadding:
              const EdgeInsets.symmetric(horizontal: 10, vertical: 14),
          content: SingleChildScrollView(
            child: ListBody(
              children: ((time == 1) ? group1 : group2).map<Widget>((e) {
                return Card(
                  child: ListTile(
                    onTap: () {
                      if (time == 1) {
                        controller.text = e;
                        Navigator.pop(context);
                        showChoiceDialog(context, 2);
                      } else {
                        controller.text += ' ' + e;
                        Navigator.pop(context);
                      }
                    },
                    contentPadding: const EdgeInsets.all(0),
                    leading: Radio(
                      value: e,
                      groupValue: controller.text,
                      onChanged: (value) {
                        if (time == 1) {
                          controller.text = e;
                          Navigator.pop(context);
                          showChoiceDialog(context, 2);
                        } else {
                          controller.text += ' ' + e;
                          Navigator.pop(context);
                        }
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
          showChoiceDialog(context, 1);
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
