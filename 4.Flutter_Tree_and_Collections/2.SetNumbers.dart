void main() {
  // Step 1: Create a Set with duplicate numbers
  Set<int> numbers = {1, 2, 3, 3, 4, 5, 5, 6, 88};

  // Step 2: Print the set (duplicates are automatically removed)
  print('Unique numbers in the set: $numbers');

  // Step 3: Print using for-in (for-each) loop
  print('Using for-in loop:');
  for (var num in numbers) {
    print(num);
  }

  // Step 4: Convert Set to List to use traditional for loop
  List<int> numberList = numbers.toList();

  print('Using for loop with index:');
  for (int i = 0; i < numberList.length; i++) {
    print(numberList[i]);
  }
}
