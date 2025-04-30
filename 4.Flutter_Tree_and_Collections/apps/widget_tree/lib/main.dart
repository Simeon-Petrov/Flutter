import 'package:flutter/material.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          title: const Text('Hello'),
          //centerTitle: false, // ценрира се
        ),
        body: Center(child: Text('Flutter is awesome!')),
      ),
    );
  }
}
