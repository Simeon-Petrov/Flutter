import 'dart:io';

void main() {
  int minutes = int.parse(stdin.readLineSync()!);

  int hours = minutes ~/ 60; // да се внимава какво е деленето !!!
  int remainingMinutes = minutes % 60;

  String formattedTime =
      "${hours.toString().padLeft(2, '0')}:${remainingMinutes.toString().padLeft(2, '0')}";

  print(formattedTime);
}
