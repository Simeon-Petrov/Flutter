import 'dart:io';
import 'dart:math';

void main() {
  double radius = double.parse(stdin.readLineSync()!);

  double circumference = 2 * pi * radius;

  print(circumference.toStringAsFixed(2));
}
