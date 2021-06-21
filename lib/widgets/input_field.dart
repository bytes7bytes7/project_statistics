import 'package:flutter/material.dart';
import '../services/amount_text_input_formatter.dart';

class InputField extends StatelessWidget {
  InputField({
    Key key,
    @required this.label,
    @required this.controller,
    this.textInputType = TextInputType.text,
    this.amountFormatter = true,
  }) : super(key: key);

  final String label;
  final TextEditingController controller;
  final TextInputType textInputType;
  final bool amountFormatter;

  @override
  Widget build(BuildContext context) {
    if(amountFormatter){
      controller.text = AmountTextInputFormatter().formatEditUpdate(null, TextEditingValue(text: controller.text)).text;
    }
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6),
      child: TextField(
        controller: controller,
        style: Theme
            .of(context)
            .textTheme
            .bodyText1,
        keyboardType: textInputType,
        inputFormatters: (amountFormatter) ? [
          AmountTextInputFormatter(),
        ] : [],
        decoration: InputDecoration(
          labelText: label,
          labelStyle: Theme
              .of(context)
              .textTheme
              .subtitle1,
          contentPadding: const EdgeInsets.symmetric(horizontal: 10),
          disabledBorder: UnderlineInputBorder(
            borderSide: BorderSide(
              color: Theme
                  .of(context)
                  .disabledColor,
            ),
          ),
        ),
      ),
    );
  }
}
