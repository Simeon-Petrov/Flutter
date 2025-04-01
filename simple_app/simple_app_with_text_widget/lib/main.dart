import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(title: Text("Welcome to My First App")),
        body: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              "This is a beginner-level Flutter app.",
              style: TextStyle(fontSize: 24),
            ),

            Container(
              height: 100,
              width: 200,
              color: Colors.blue,
              alignment: Alignment.center,
              child: Text(
                "Styled Container",
                style: TextStyle(color: Colors.white, fontSize: 18),
              ),
            ),
            SizedBox(height: 20),
            Text("Row 1", style: TextStyle(fontSize: 24)),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Container(height: 50, width: 50, color: Colors.red),
                SizedBox(width: 10),
                Container(height: 50, width: 50, color: Colors.green),
                SizedBox(width: 10),
                Container(height: 50, width: 50, color: Colors.blue),
              ],
            ),
            SizedBox(height: 20),
            Text("Row 2", style: TextStyle(fontSize: 24)),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Container(height: 50, width: 50, color: Colors.yellow),
                SizedBox(width: 10),
                Container(
                  height: 50,
                  width: 50,
                  color: Colors.deepOrangeAccent,
                ),
                SizedBox(width: 10),
                Container(height: 50, width: 50, color: Colors.purple),
              ],
            ),
            SizedBox(height: 20),
            Text("Row 3", style: TextStyle(fontSize: 24)),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Container(height: 50, width: 50, color: Colors.cyan),
                SizedBox(width: 10),
                Container(height: 50, width: 50, color: Colors.pink),
                SizedBox(width: 10),
                Container(height: 50, width: 50, color: Colors.indigoAccent),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
