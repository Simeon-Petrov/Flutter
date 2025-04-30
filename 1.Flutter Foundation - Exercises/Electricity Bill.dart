import 'dart:io';

void main() {
  double unitsConsumed = double.parse(stdin.readLineSync()!);
  double ratePerUnit = double.parse(stdin.readLineSync()!);

  double totalBill = (unitsConsumed * ratePerUnit) + 10;

  print(totalBill.toStringAsFixed(2));
}
