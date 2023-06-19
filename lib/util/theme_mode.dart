import 'dart:ui';
import 'package:flutter/widgets.dart';

extension ThemeMode on BuildContext {
  /// is dark mode currently enabled?
  bool get isDarkMode {
    final brightness = WidgetsBinding.instance.window.platformBrightness;
    return brightness == Brightness.dark;
  }
}
