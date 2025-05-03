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
            alignment: Alignment.center, // центрира текста вътре
            child: Text(
              "Hello Flutter!",
              style: TextStyle(color: Colors.white, fontSize: 20),
            ),
          ),
        ),
      ),
    );
  }
}
