import 'package:flutter/material.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(home: MyHomePage());
  }
}

//StatefullWidget, за да може да се обновява динамично
class MyHomePage extends StatefulWidget {
  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  String displayText = "Hello, Flutter!";

  void _updateText() {
    setState(() {
      displayText = "You click the button!";
    });
  }

  @override
  Widget build(BuildContext) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          "Welcome",
        ), //pace for title text / if no text only -> appBar: AppBar()
      ),
      body: Column(
        children: [
          Text(displayText), // show dinamictext
          const Icon(Icons.star, size: 50, color: Colors.yellow),
          ElevatedButton(onPressed: _updateText, child: const Text("Click me")),
          Container(width: 100, height: 100, color: Colors.blue),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: const [
              Icon(Icons.star),
              SizedBox(width: 10),
              Icon(Icons.favorite),
            ],
          ),
        ],
      ),
    );
  }
}





//   
//    body: Column(
//      children: [
//        const Text("Hello, Flutter!"),
//        const Icon(Icons.star, size: 50, color: Colors.yellow),
//        ElevatedButton(
//          onPressed: () {
//            print("Clicked"); // alredy clicked
//          },
//          child: const Text("Click me"),
//        ),
//        Container(width: 100, height: 100, color: Colors.blue),
//        Row(
//          mainAxisAlignment: MainAxisAlignment.center,
//          children: [
//            Icon(Icons.star), // two icons
//            SizedBox(width: 10), // space between icons
//            Icon(Icons.favorite),
//          ],
//        ),
//      ],
//    ),
//  ),
//);
//
//
