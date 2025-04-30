void main() {
  List<String> words = [
    "racecar",
    "radar",
    "flutter",
    "widget",
    "level",
    "mobile",
    "dart",
    "screen",
    "app",
    "gesture",
  ];

  print("Palindromes in the list:");
  for (var word in words) {
    if (isPalindrome(word)) {
      print(word);
    }
  }
}

bool isPalindrome(String word) {
  String reversed = word.split("").reversed.join((""));
  return word == reversed;
}
/* s for loop, check word
bool isPalindrome(String word) {
  for (int i = 0; i < word.length ~/ 2; i++) {
    if (word[i] != word[word.length - 1 - i]) {
      return false;
    }
  }
  return true;
}*/
