import 'package:flutter/material.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: "Aligning Widgets Demo", // заглавие на приложението
      home: Scaffold(
        appBar: AppBar(
          title: Text("Alidgnind Widgets"),
        ), // заглавие на  AppBar-a
        body: Center(
          child: Container(
            // центрираме съдържанието на ектрана
            width: 300, // височина
            height: 300, // ширинаr
            color: Colors.red, //
            child: Align(
              alignment: Alignment.center,
              child: Text(
                "I'm centered!",
                style: TextStyle(color: Colors.white, fontSize: 18),
              ), // текс
            ),
          ),
        ),
      ),
    );
  }
}
