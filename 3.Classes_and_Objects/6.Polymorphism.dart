import 'dart:math';

class Shape {
  // Method to calculate area
  double area() {
    return 0;
  }
}

class Circle extends Shape {
  double radius;

  Circle(this.radius);

  @override
  double area() {
    return pi * radius * radius;
  }
}

class Rectangle extends Shape {
  double width;
  double height;

  Rectangle(this.width, this.height);

  @override
  double area() {
    return width * height;
  }
}

void main() {
  List<Shape> shapes = [
    Circle(5),
    Rectangle(4, 6),
    Circle(3.5),
    Rectangle(2.5, 4.0),
  ];

  for (var shape in shapes) {
    print('Area: ${shape.area().toStringAsFixed(2)}');
  }
}
