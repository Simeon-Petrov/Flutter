void main() {
  int sum = 0;

  for (var i = 0; i <= 50; i++) {
    if (i % 2 == 0) {
      sum += i;
    }
  }

  print("The sum of all even numbers from 1 to 50 is: $sum");
}
