import 'dart:io';

void main() {
  List<int> numbers = [1, 1, 2, 3, 4, 5, 5, 14, 25, 50, 30, 30, 100];

  for (var num in numbers) {
    if (num % 5 == 0) {
      //print(num);
      stdout.write('$num '); // оutput on one line
    }
  }
}
