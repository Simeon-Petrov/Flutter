import 'dart:io';
import 'dart:math';

void main() {
  Random random = Random();
  int secretNumber = random.nextInt(10) + 1; // числа от 1 до 1с0
  int guess;

  print("Guess the secret number (between 1 and 10):");

  do {
    stdout.write("Enter your guess: ");
    guess =
        int.tryParse(stdin.readLineSync()!) ??
        0; // четем вход от потребителя и проверяваме дали е валидно

    if (guess < secretNumber) {
      print("Too low! Try again.");
    } else if (guess > secretNumber) {
      print("Too high! Try again.");
    } else {
      print("Congratulations! You guessed the secret number.");
    }
  } while (guess != secretNumber);
}
