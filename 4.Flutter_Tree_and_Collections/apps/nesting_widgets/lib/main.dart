import 'package:flutter/material.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(title: const Text("Example")),
        body: Column(
          children: [
            const Text("Welcome!"),
            const Icon(Icons.star, size: 50, color: Colors.yellow),
            ElevatedButton(
              onPressed: () {
                print("Clicked"); // veche natisnato
              },
              child: const Text("Click me"),
            ),
          ],
        ),
      ),
    );
  }
}
