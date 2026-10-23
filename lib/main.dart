import 'package:flutter/material.dart';

import 'config/app_config.dart';
import 'util/app_theme.dart';
import 'widget/stateful/home.dart';

/// Main function of the app.
void main() {
  final config = AppConfig.fromEnvironment();
  if (config.diagnosticsEnabled) {
    debugPrint('Passwd Hints environment: ${config.environment.name}');
  }
  runApp(App(config: config));
}

/// App widget : builds the Password Hints app with a dark theme.
class App extends StatelessWidget {
  const App({
    super.key,
    this.config = AppConfig.production,
  });

  final AppConfig config;

  /// Builds the widget.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      themeMode: ThemeMode.system,
      theme: AppTheme.light,
      darkTheme: AppTheme.dark,
      title: config.appTitle,
      home: const Home(),
    );
  }
}
