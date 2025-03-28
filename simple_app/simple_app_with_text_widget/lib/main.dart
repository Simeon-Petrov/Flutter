import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(title: Text("Welcome to My First App")),
        body: Center(
          child: Text(
            "This is a beginner-level Flutter app.",
            style: TextStyle(fontSize: 24),
          ),
        ),
      ),
    );
  }
}
