import 'dart:io';

void main() {
  double n = double.parse(stdin.readLineSync()!);

  double secondCabinet = 0.8 * n;
  double thirdCabinet = 1.15 * (n + secondCabinet);
  double totalCost = n + secondCabinet + thirdCabinet;

  print(totalCost.toStringAsFixed(3));
}
