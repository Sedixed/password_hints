import 'package:flutter/material.dart';

enum AppColor {
  // Base colors
  white(color: Colors.white),
  black(color: Colors.black),
  // App main color
  appMainColor(color: Color.fromARGB(255, 16, 196, 142)),
  // Separator color
  sepColor(color: Color.fromARGB(255, 175, 171, 171)),
  darkSepColor(color: Color.fromARGB(255, 122, 118, 118)),
  // Entry removing icon color
  entryRemovingColor(color: Color.fromARGB(255, 194, 55, 30)),
  darkEntryRemovingColor(color: Color.fromARGB(255, 216, 60, 33)),
  // Default button color
  buttonColor(color: Color.fromARGB(255, 247, 247, 247)),
  darkButtonColor(color: Color.fromARGB(255, 78, 76, 76)),
  // Heavy button color
  heavyButtonColor(color: Color.fromARGB(255, 187, 182, 182)),
  darkHeavyButtonColor(color: Color.fromARGB(255, 42, 43, 42)),
  // Removal button color
  removalButtonColor(color: Color.fromARGB(255, 131, 4, 4)),
  // Creation button color
  createButtonColor(color: Color.fromARGB(255, 75, 202, 79)),
  // Edition button color
  editButtonColor(color: Color.fromARGB(255, 107, 174, 228)),
  darkEditButtonColor(color: Color.fromARGB(255, 70, 129, 177));

  /// The color.
  final Color color;

  /// Default constructor.
  const AppColor({required this.color});

  /// Converts a color to its MaterialColor equivalent.
  MaterialColor get materialColor {
    Map<int, Color> colorMap = {
      50: color,
      100: color,
      200: color,
      300: color,
      400: color,
      500: color,
      600: color,
      700: color,
      800: color,
      900: color,
    };
    return MaterialColor(color.value, colorMap);
  }
}
