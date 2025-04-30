import 'package:flutter/material.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          title: const Text("Welcome!"),
        ), //pace for title text / if no text only -> appBar: AppBar()
        body: Column(
          children: [
            const Text("Hello, Flutter!"),
            const Icon(Icons.star, size: 50, color: Colors.yellow),
            ElevatedButton(
              onPressed: () {
                print("Clicked"); // alredy clicked
              },
              child: const Text("Click me"),
            ),
            Container(width: 100, height: 100, color: Colors.blue),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(Icons.star), // two icons
                SizedBox(width: 10), // space between icons
                Icon(Icons.favorite),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
