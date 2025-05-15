import 'package:flutter/material.dart';

void main() {
  runApp(MyListViewApp());
}

class MyListViewApp extends StatelessWidget {
  const MyListViewApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(title: const Text("ListView Example")),
        body: ListView.builder(
          itemCount: 5, // 5 елемента
          itemBuilder: (context, index) {
            // редува цветовете: син на четни, зелене на нечетни
            final color = index % 2 == 0 ? Colors.blue : Colors.green;
            return Container(
              height: 80,
              color: color,
              child: Center(
                child: Text(
                  "Item ${index + 1}",
                  style: const TextStyle(color: Colors.white, fontSize: 18),
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}
