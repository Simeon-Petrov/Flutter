import 'package:flutter/material.dart';

void main() {
  runApp(MyApp());
}

// oсновен widget, който стартира приложението
class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: "Flutter Layout Demo",
      home: Scaffold(
        appBar: AppBar(title: Text("Container Example")),
        body: Center(
          //// центрира контейнера в екрана
          child: Container(
            width: 200,
            height: 100,
            color: Colors.blue,
            child: Padding(
              padding: EdgeInsets.all(
                20,
              ), // добавяне на padding от 20 пиксела от всички страни
              child: Text(
                "Hello Futter!",
                style: TextStyle(
                  color: Colors.white, // бял текс
                  fontSize: 20,
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
