void main() {
  List<int> numbers = [2, 4, 10, 12, 15, 33];

  List<int> doubledNumberes = numbers.map((num) => num * 2).toList();
  // if want double the values
  // List<double> doubledNumbers = numbers.map((num) => (num * 2).toDouble()).toList();

  print("Doubled numbers: $doubledNumberes");
}
