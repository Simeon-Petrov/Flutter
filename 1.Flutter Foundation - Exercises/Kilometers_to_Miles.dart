import 'dart:io';

void main() {
  double kmInMile = 0.621371192;

  String? input = stdin.readLineSync();
  double kilometers = double.parse(input!);

  double miles = kilometers * kmInMile;

  print((miles));
}
