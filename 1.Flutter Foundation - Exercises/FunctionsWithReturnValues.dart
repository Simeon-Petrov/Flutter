import 'dart:io';

int addNumbers(int a, int b) {
  return a + b;
}

void main() {
  int num1 = int.parse(stdin.readLineSync()!);
  int num2 = int.parse(stdin.readLineSync()!);

  int result = addNumbers(num2, num1);
  print("The sum is ${result}");
}
