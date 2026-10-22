import 'package:flutter/material.dart';
import 'package:passwd_hints/util/colors/app_colors.dart';

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
      theme: ThemeData(
        brightness: Brightness.light,
        useMaterial3: true,
        primarySwatch: AppColor.black.materialColor,
        colorScheme: ColorScheme.fromSeed(
          seedColor: AppColor.black.color,
          brightness: Brightness.light,
        ).copyWith(primary: AppColor.black.color),
        textSelectionTheme: const TextSelectionThemeData(
          cursorColor: Colors.black,
          selectionHandleColor: Colors.black,
        ),
      ),
      darkTheme: ThemeData(
        brightness: Brightness.dark,
        useMaterial3: true,
        primarySwatch: AppColor.white.materialColor,
        colorScheme: ColorScheme.fromSeed(
          seedColor: AppColor.black.color,
          brightness: Brightness.dark,
        ).copyWith(primary: AppColor.black.color),
        textSelectionTheme: const TextSelectionThemeData(
          cursorColor: Colors.black,
          selectionHandleColor: Colors.black,
        ),
      ),
      home: const SafeArea(
        child: Home(),
      ),
      title: 'Passwd Hints',
    );
  }
}
