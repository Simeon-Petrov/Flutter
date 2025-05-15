import 'package:flutter/material.dart';

void main() {
  runApp(MyFlexApp());
}

class MyFlexApp extends StatelessWidget {
  const MyFlexApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(title: const Text("Flex Colum Example")),
        body: Flex(
          direction: Axis.vertical, // също като Column
          children: [
            Expanded(
              flex: 3, // 30% от общите 10 4асти
              child: Container(
                color: Colors.red,
                child: const Center(
                  child: Text("30%", style: TextStyle(color: Colors.white)),
                ),
              ),
            ),
            Expanded(
              flex: 5, // 50% oт общите 10 части
              child: Container(
                color: Colors.green,
                child: Center(
                  child: Text("50%", style: TextStyle(color: Colors.white)),
                ),
              ),
            ),
            Expanded(
              flex: 2, // 20% от общите части
              child: Container(
                color: Colors.blue,
                child: const Center(
                  child: Text("20%", style: TextStyle(color: Colors.white)),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
