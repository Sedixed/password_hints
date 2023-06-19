import 'package:flutter/material.dart';
import 'package:passwd_hints/util/colors/app_colors.dart';

import 'widget/stateful/home.dart';

/// Main function of the app.
void main() {
  runApp(const App());
}

/// App widget : builds the Password Hints app with a dark theme.
class App extends StatelessWidget {
  const App({Key? key}) : super(key: key);

  /// Builds the widget.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      themeMode: ThemeMode.light,
      theme: ThemeData(
          brightness: Brightness.light,
          useMaterial3: true,
          primarySwatch: AppColor.black.toMaterialColor()),
      darkTheme: ThemeData(
        brightness: Brightness.dark,
        useMaterial3: true,
        primarySwatch: AppColor.white.toMaterialColor(),
      ),
      home: SafeArea(
        child: Home(),
      ),
      title: 'Passwd Hints',
    );
  }
}
