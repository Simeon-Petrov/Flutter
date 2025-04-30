void main() {
  Set<int> numbers = {1, 2, 3, 3, 4, 5, 5, 6, 88};

  print('Unique numbers in the set: $numbers');

  // Convert to list to access elements by index
  List<int> numberList = numbers.toList();

  for (var i = 0; i < numberList.length; i++) {
    print('Element at index $i: ${numberList[i]}');
  }
}
