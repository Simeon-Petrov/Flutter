void main() {
  List<int> numbers = [10, 15, 20, 25, 30, 35, 40];

  List<int> filteredNumbers = numbers.where((num) => num >= 20).toList();

  print("Filtered numbers: $filteredNumbers");
}
