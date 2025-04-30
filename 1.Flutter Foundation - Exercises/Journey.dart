import 'dart:io';

void main() {
  int firstCart = int.parse(stdin.readLineSync()!);
  int secondCart = int.parse(stdin.readLineSync()!);

  int difference = (5 * firstCart) - (3 * secondCart);

  print(difference);
}
