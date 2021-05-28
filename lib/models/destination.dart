import 'package:flutter/material.dart';

class Destination {
  Destination({
    @required this.name,
    @required this.screen,
    @required this.icon,
  });

  final String name;
  final Widget screen;
  final IconData icon;
}
