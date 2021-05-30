import 'package:flutter/material.dart';
import '../constants.dart';

var lightTheme = ThemeData(
  primaryColor: ConstantColors.primaryColor,
  focusColor: ConstantColors.focusColor,
  disabledColor: ConstantColors.disabledColor,
  shadowColor: ConstantColors.shadowColor,
  errorColor: ConstantColors.errorColor,
  textTheme: TextTheme(
    headline1: TextStyle(
      fontSize: 27,
      fontWeight: FontWeight.w400,
      color: ConstantColors.focusColor,
    ),
    headline2: TextStyle(
      fontSize: 23,
      fontWeight: FontWeight.w400,
      color: ConstantColors.shadowColor,
    ),
    headline3: TextStyle(
      fontSize: 27,
      fontWeight: FontWeight.w400,
      color: ConstantColors.disabledColor,
    ),
    bodyText1: TextStyle(
      fontSize: 21,
      fontWeight: FontWeight.w400,
      color: ConstantColors.shadowColor,
    ),
    subtitle1: TextStyle(
      fontSize: 21,
      fontWeight: FontWeight.w400,
      color: ConstantColors.disabledColor,
    ),
    subtitle2: TextStyle(
      fontSize: 17,
      fontWeight: FontWeight.w400,
      color: ConstantColors.disabledColor,
    ),
  ),
);