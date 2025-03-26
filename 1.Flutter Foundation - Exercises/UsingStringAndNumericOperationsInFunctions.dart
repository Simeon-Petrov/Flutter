import 'dart:io';

void calculateTotalCost(double itemPrice, int quantity) {
  double totalCost = itemPrice * quantity;
  print("Total cost: ${totalCost.toStringAsFixed(2)}");
}

void main() {
  calculateTotalCost(10.5, 3);
}
