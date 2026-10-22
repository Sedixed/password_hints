import 'package:flutter/widgets.dart';

/// Extension on BuildContext for dark mode handling.
extension ThemeMode on BuildContext {
  /// Returns true if the dark mode is enabled, false otherwise.
  bool get isDarkMode {
    final brightness = MediaQuery.platformBrightnessOf(this);
    return brightness == Brightness.dark;
  }
}
