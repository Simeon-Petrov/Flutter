import 'dart:io';

class Vehicle {
  String brand;
  String model;

  Vehicle(this.brand, this.model);

  void start() {
    print("The vehicle is starting");
  }
}

class Car extends Vehicle {
  int numberOfDors;

  Car(String brand, String model, this.numberOfDors) : super(brand, model);

  @override
  void start() {
    // TODO: implement start
    //('The car is starting.');
    super.start();
  }
}

void main() {
  stdout.write("Enter the brand of \"das auto\": ");
  String? brand = stdin.readLineSync();

  stdout.write("Enter the model of the car: ");
  String? model = stdin.readLineSync();

  stdout.write("Enter the numer of doors:");
  String? doorsInput = stdin.readLineSync();
  int numberOfDoors = int.tryParse(doorsInput ?? "0") ?? 0;

  var myCar = Car(brand ?? "Unknown", model ?? "Unknown", numberOfDoors);

  print("\n--- Car Info ---");
  print("Brand: ${myCar.brand}");
  print("Model: ${myCar.model}");
  print("Number of doors: ${myCar.numberOfDors}");

  myCar.start();
}
