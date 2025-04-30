import 'dart:io';
import 'dart:math';

void main() {
  double weight = double.parse(stdin.readLineSync()!);
  double height = double.parse(stdin.readLineSync()!);

  double bmi = weight / (height * height);

  //zakragrqme 2 znaka
  double factor = pow(10, 2).toDouble();
  double trancateBmi = (bmi * factor).floorToDouble() / factor;

  print(trancateBmi.toStringAsFixed(2));
}
