import 'dart:io';

void main() {
  double distance = double.parse(stdin.readLineSync()!);

  double onePartPaint = distance / 13;

  double redPaint = onePartPaint;
  double yewPaint = onePartPaint * 4;
  double whitePaint = onePartPaint * 8;

  print("Red: ${onePartPaint.toStringAsFixed(4)}");
  print("Yelow: ${yewPaint.toStringAsFixed(4)}");
  print("White: ${whitePaint.toStringAsFixed(4)}");
}
