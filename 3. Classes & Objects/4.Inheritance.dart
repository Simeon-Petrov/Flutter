class Animal {
  void makeSound() {
    print("Some animal sound.");
  }
}

class Dog extends Animal {
  @override
  void makeSound() {
    print("Bark!");
  }
}

class Cat extends Animal {
  @override
  void makeSound() {
    print("Meow!");
  }
}

void main() {
  var dog = Dog();
  dog.makeSound();

  var cat = Cat();
  cat.makeSound();
}
