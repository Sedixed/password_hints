import 'dart:ui';
import 'package:flutter/widgets.dart';

/// Extension on BuildContext for dark mode handling.
extension ThemeMode on BuildContext {
  /// Returns true if the dark mode is enabled, false otherwise.
  bool get isDarkMode {
    final brightness = WidgetsBinding.instance.window.platformBrightness;
    return brightness == Brightness.dark;
  }
}
