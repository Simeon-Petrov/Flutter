import 'dart:vmservice_io';

class Person {
  String name;
  int age;

  Person(this.name, this.age);
  void introduce() {
    print("Hi my name is $name and I am $age old.");
  }
}

void main() {
  Person person = Person("Simeon", 27);
  person.introduce();
}
