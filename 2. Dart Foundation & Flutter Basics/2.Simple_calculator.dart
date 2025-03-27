import 'dart:io';

void main() {
  print("Enter two numbers and an operator (e.g., 4, 2, +):");
  String input = stdin.readLineSync()!;

  List<String> parts = input.split(',');

  if (parts.length != 3) {
    print(
      "Invalid input. Please enter in the format: number, number, operator.",
    );
    return;
  }

  double num1 = double.parse(parts[0].trim());
  double num2 = double.parse(parts[1].trim());
  String operator = parts[2].trim();

  double result;

  switch (operator) {
    case '+':
      result = num1 + num2;
      break;
    case '-':
      result = num1 - num2;
      break;
    case '*':
      result = num1 * num2;
      break;
    case '/':
      if (num2 != 0) {
        result = num1 / num2;
      } else {
        print("Error! Division by zero.");
        return;
      }
      break;
    default:
      print("Invalid operator.");
      return;
  }

  // проверка дали числото е с десетичен знак
  if (result == result.toInt()) {
    print("Result: ${result.toInt()}");
  } else {
    print("Result: $result");
  }
}
