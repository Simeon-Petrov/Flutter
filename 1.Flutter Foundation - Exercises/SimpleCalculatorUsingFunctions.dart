double add(double a, double b) {
  return a + b;
}

double subtract(double a, double b) {
  return a - b;
}

double multiply(double a, double b) {
  return a * b;
}

void main() {
  double num1 = 10;
  double num2 = 5;

  print("Sum: ${add(num1, num2)}");
  print("Difference: ${subtract(num1, num2)}");
  print("Product: ${multiply(num1, num2)}");
}
