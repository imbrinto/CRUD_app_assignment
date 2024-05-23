import 'package:flutter/material.dart';
import 'package:crud_app_assignment/app_theme.dart';
import 'package:crud_app_assignment/home_page.dart';

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'CRUD App',
        theme: AppTheme.defaultAppTheme,
        themeMode: ThemeMode.system,
        home: const HomePage());
  }
}
