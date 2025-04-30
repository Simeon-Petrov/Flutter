import 'dart:io';

void main() {
  double distance = double.parse(stdin.readLineSync()!);
  double fuel = double.parse(stdin.readLineSync()!);

  double fuelEfficiency = distance / fuel;

  print(fuelEfficiency.toStringAsFixed(2));
}
