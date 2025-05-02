import 'package:flutter/material.dart';

void main() {
  runApp(MyApp());
}

// Основен Stateless widget
class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: TapDemo(), // начален екран
    );
  }
}

// StatefulWidget – състоянието се променя при tap/swipe/long press
class TapDemo extends StatefulWidget {
  @override
  _TapDemoState createState() => _TapDemoState(); // правилно име на state класа
}

// Състояние, което обработва tap, swipe и long press
class _TapDemoState extends State<TapDemo> {
  String _text = "Tap me!"; // начален текст

  void _handleTap() {
    setState(() {
      _text = "Tapped!";
    });
  }

  void _handleSwipeLeft() {
    setState(() {
      _text = "Swiped Left";
    });
  }

  void _handleSwipeRight() {
    setState(() {
      _text = "Swiped Right";
    });
  }

  void _handleLongPress() {
    setState(() {
      _text = "Long Pressed!";
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Gesture")),
      body: Center(
        child: GestureDetector(
          onTap: _handleLongPress, //
          onHorizontalDragEnd: (DragEndDetails details) {
            if (details.primaryVelocity != null) {
              if (details.primaryVelocity! < 0) {
                _handleSwipeLeft();
              } else if (details.primaryVelocity! > 0) {
                _handleSwipeRight();
              }
            }
          },
          child: Container(
            padding: EdgeInsets.all(20),
            color: Colors.lightBlueAccent,
            child: Text(
              _text,
              style: TextStyle(fontSize: 24, color: Colors.white),
            ),
          ),
        ),
      ),
    );
  }
}
