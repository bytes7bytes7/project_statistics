import 'package:flutter/material.dart';
import 'screens/home_screen.dart';
import 'themes/light_theme.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Project Statistics',
      debugShowCheckedModeBanner: false,
      theme: lightTheme,
      home: HomeScreen(),
    );
  }
}
