void main() {
  Set<String> fruits = {"Apple", "Orange", "Mango"};

  if (!fruits.contains("Lemon")) {
    fruits.add("Lemon");
  }
  print("Update fruit set: $fruits");

  Set<String> food = {"Pizza", "Lemon", "Banana", "Tomato"};

  //Step 4: Find and print common elements (intersection) // or if they are more than one
  Set<String> commonItems = fruits.intersection(food);
  print("Comman elements between fruits and food: $commonItems");
}
