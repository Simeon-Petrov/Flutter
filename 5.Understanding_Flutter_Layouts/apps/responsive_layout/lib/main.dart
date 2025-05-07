import 'package:flutter/material.dart';

void main() {
  runApp(MyApp());
}s

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(title: Text("Responsive Layout")),
        body: Row(
          children: [
            Expanded(child: Container(height: 100, color: Colors.red)),
            Expanded(child: Container(height: 100, color: Colors.blue)),
          ],
        ),
      ),
    );
  }
}
