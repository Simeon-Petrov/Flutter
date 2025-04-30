class Vehicle {
  String brand;
  String model;

  Vehicle(this.brand, this.model);

  void start() {
    print('The vehicle is starting.');
  }
}

class Car extends Vehicle {
  int numberOfDoors;

  Car(String brand, String model, this.numberOfDoors) : super(brand, model);

  @override
  void start() {
    print('The car is starting.');
  }
}

void main() {
  var myCar = Car('Fiat', 'Punto', 2);

  print('Brand: ${myCar.brand}');
  print('Model: ${myCar.model}');
  print('Number of doors: ${myCar.numberOfDoors}');

  myCar.start();
}
