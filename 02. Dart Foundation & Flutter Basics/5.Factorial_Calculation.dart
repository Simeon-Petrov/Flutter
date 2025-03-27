import 'dart:io';

void main() {
  stdout.write("A number: ");
  int number = int.parse(stdin.readLineSync()!);

  int factorial = 1;
  int i = number;

  // изчисляваме факториал с while loop
  while (i > 1) {
    factorial *= i;
    i--;
  }

  print("Factorial of $number is $factorial");
}
