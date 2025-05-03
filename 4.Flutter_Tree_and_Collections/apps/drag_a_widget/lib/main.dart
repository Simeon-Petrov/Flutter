import 'package:flutter/material.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: DragBoxDemo(), // начален екран
    );
  }
}

//StatefulWidget - защото се позицията се променя динамично при drag
class DragBoxDemo extends StatefulWidget {
  @override
  _DragBoxDemoState createState() => _DragBoxDemoState();
}

// състояние на DragBoxDemo
class _DragBoxDemoState extends State<DragBoxDemo> {
  Offset position = Offset(100, 100); // начална позиция

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Daragg box")),
      body: Stack(
        children: [
          Positioned(
            left: position.dx,
            top: position.dy, // правилно използване на dy
            child: GestureDetector(
              onPanUpdate: (DragUpdateDetails details) {
                setState(() {
                  position += details.delta; // обновяване позиция
                  print("New position: $position"); // отпечатване на новата
                });
              },
              child: Container(width: 100, height: 100, color: Colors.blue),
            ),
          ),
        ],
      ),
    );
  }
}
