import 'dart:io';

void main() {
  double totalConsumption = double.parse(stdin.readLineSync()!);
  int numberOfPeople = int.parse(stdin.readLineSync()!);

  double dailyConsumption = totalConsumption / 7 / numberOfPeople;

  print(dailyConsumption.toStringAsFixed(2));
}
