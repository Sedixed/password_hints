import 'package:flutter/material.dart';

import 'util/app_theme.dart';
import 'widget/stateful/home.dart';

/// Main function of the app.
void main() {
  runApp(const App());
}

/// App widget : builds the Password Hints app with a dark theme.
class App extends StatelessWidget {
  const App({super.key});

  /// Builds the widget.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      themeMode: ThemeMode.system,
      theme: AppTheme.light,
      darkTheme: AppTheme.dark,
      home: const SafeArea(
        child: Home(),
      ),
      title: 'Passwd Hints',
    );
  }
}
