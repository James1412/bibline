import 'package:bibline/screens/home_screen.dart';
import 'package:flutter/material.dart';

void main() {
  runApp(const BiblineApp());
}

class BiblineApp extends StatelessWidget {
  const BiblineApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        scaffoldBackgroundColor: Colors.white,
        appBarTheme: const AppBarTheme(
          color: Colors.white,
          elevation: 0,
          surfaceTintColor: Colors.white,
          shadowColor: Colors.white,
        ),
      ),
      home: const HomeScreen(),
    );
  }
}
