import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  final TextEditingController _controller1 = TextEditingController();
  final TextEditingController _controller2 = TextEditingController();
  String result = "Result:";

  void _calculate(String operator) {
    double num1 = double.tryParse(_controller1.text) ?? 0;
    double num2 = double.tryParse(_controller2.text) ?? 0;

    setState(() {
      if (operator == '+') {
        result = "Result: ${num1 + num2}";
      } else if (operator == '-') {
        result = "Result: ${num1 - num2}";
      } else if (operator == '*') {
        result = "Result: ${num1 * num2}";
      } else if (operator == '/') {
        if (num2 != 0) {
          result = "Result: ${num1 / num2}";
        } else {
          result = "Result: Cannot divide by zero";
        }
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(title: Text("Simple Calculator")),
        body: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(result, style: TextStyle(fontSize: 30)),
              SizedBox(height: 20),

              TextField(
                controller: _controller1,
                keyboardType: TextInputType.number,
                decoration: InputDecoration(
                  labelText: "Enter first number",
                  border: OutlineInputBorder(),
                ),
              ),
              SizedBox(height: 10),

              TextField(
                controller: _controller2,
                keyboardType: TextInputType.number,
                decoration: InputDecoration(
                  labelText: "Enter second number",
                  border: OutlineInputBorder(),
                ),
              ),
              SizedBox(height: 20),

              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  ElevatedButton(
                    onPressed: () => _calculate('+'),
                    child: Text("+"),
                  ),
                  ElevatedButton(
                    onPressed: () => _calculate('-'),
                    child: Text("-"),
                  ),
                  ElevatedButton(
                    onPressed: () => _calculate('*'),
                    child: Text("*"),
                  ),
                  ElevatedButton(
                    onPressed: () => _calculate('/'),
                    child: Text("/"),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
