import 'package:bibline/screens/home_screen.dart';
import 'package:flutter/material.dart';

void main() {
  runApp(const BiblineApp());
}

class BiblineApp extends StatelessWidget {
  const BiblineApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      home: HomeScreen(),
    );
  }
}
