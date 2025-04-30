import 'dart:async';

void main() {
  Map<String, int> countryPopulations = {
    "Bulgaria": 7,
    "USA": 331,
    "India": 1400,
    "Brazil": 213,
    "China": 1440,
  };

  print("Country populations in milions:"); // full map
  print(countryPopulations);

  print("\nCountry names:");
  print(countryPopulations.keys);

  print("\nConutry populations");
  print(countryPopulations.values);
}
