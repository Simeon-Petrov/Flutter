import 'dart:math';

import 'package:flutter/material.dart';

void main() {
  runApp(MyGridViewApp());
}

class MyGridViewApp extends StatelessWidget {
  const MyGridViewApp({super.key});

  // генерира произволен цвят
  Color getRandomColor() {
    final random = Random();
    return Color.fromARGB(
      255, // alpha - непрозрачност (255 - напълно видим)
      random.nextInt(256), // черно R
      random.nextInt(256), // зелено G
      random.nextInt(256), // синьо B
    );
  }

  @override
  Widget build(BuildContext contex) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(title: const Text("GridView Example")),
        body: GridView.count(
          crossAxisCount: 3, // 3 koloni
          children: List.generate(6, (index) {
            return Container(
              margin: const EdgeInsets.all(8),
              color: getRandomColor(), // взима рандом цветове
              child: Center(
                child: Text(
                  "${index + 1}",
                  style: const TextStyle(
                    fontSize: 24,
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            );
          }),
        ),
      ),
    );
  }
}
