import 'package:flutter/material.dart';

void main() {
  runApp(MyMediaQueryApp());
}

class MyMediaQueryApp extends StatelessWidget {
  MyMediaQueryApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(title: Text("MediaQuery Example")),
        body: Builder(
          builder: (context) {
            // взимаме ширината и сивочниата чрез MediaQuery
            final screenWidth = MediaQuery.of(context).size.width;
            final screenHeight = MediaQuery.of(context).size.height;

            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text("Screen Width: ${screenWidth.toStringAsFixed(2)}"),
                  const SizedBox(height: 10),
                  Text("Screen Heighht: ${screenHeight.toStringAsFixed(2)}"),
                ],
              ),
            );
          },
        ),
      ),
    );
  }
}
