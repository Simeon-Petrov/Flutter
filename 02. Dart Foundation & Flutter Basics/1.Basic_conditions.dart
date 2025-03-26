import 'dart:io';

void main() {
  int number = int.parse(stdin.readLineSync()!);

  if (number > 0) {
    print("The number si positive");
  } else if (number == 0) {
    print("The number is zero");
  } else {
    print("The number si negative");
  }
}
