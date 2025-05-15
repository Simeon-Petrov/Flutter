import 'package:flutter/material.dart';

void main() {
  runApp(const MyStackApp());
}

class MyStackApp extends StatelessWidget {
  const MyStackApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(title: const Text("Stack Example")),
        body: Center(
          child: Stack(
            children: [
              Container(width: 200, height: 200, color: Colors.red),
              Positioned(
                bottom: 0,
                right: 0,
                child: Container(width: 100, height: 100, color: Colors.blue),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
