import 'dart:io';

void main() {
  double distance = double.parse(stdin.readLineSync()!);
  double time = double.parse(stdin.readLineSync()!);

  double averageSpeed = distance / time;

  print(averageSpeed.toStringAsFixed(2));
}
