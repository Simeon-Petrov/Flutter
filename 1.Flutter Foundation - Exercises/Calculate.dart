import 'dart:io';

void main() {
  int num1 = int.parse(stdin.readLineSync()!);
  int num2 = int.parse(stdin.readLineSync()!);

  double average = (num1 + num2) / 2;

  print("The sum is: ${num1 + num2}");
  print("The difference is: ${(num1 - num2).abs()}");
  print("The product is: ${num1 * num2}");
  print("The average is: ${(average.toStringAsFixed(6))}");
}
