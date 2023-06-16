import 'package:flutter/material.dart';

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
      theme: ThemeData.dark(
        useMaterial3: true,
      ),
      home: SafeArea(
        child: Home(),
      ),
      title: 'Passwd Hints',
    );
  }
}
