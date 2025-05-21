import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';

void main() {
  runApp(const ResponsiveApp());
}

class ResponsiveApp extends StatelessWidget {
  const ResponsiveApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(title: const Text("Responsive Layout")),
        body: LayoutBuilder(
          builder: (context, constraints) {
            final screenWidth = MediaQuery.of(context).size.width;
            final screenHeight = MediaQuery.of(context).size.height;

            final containerHeight = screenHeight * 0.5;
            final containerColor = screenWidth < 400 ? Colors.red : Colors.blue;

            return Center(
              child: Container(
                width: double.infinity, // пълна ширина
                height: containerHeight,
                color: containerColor,
                alignment: Alignment.center,
                child: Text(
                  "Width: ${screenWidth.toStringAsFixed(0)} px",
                  style: const TextStyle(color: Colors.white, fontSize: 20),
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}
