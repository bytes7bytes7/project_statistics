import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:project_statistics/database/database_helper.dart';

import 'screens/home_screen.dart';
import 'themes/light_theme.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
  ]);
  // DatabaseHelper.db.dropBD();
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
