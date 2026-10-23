import 'package:flutter/foundation.dart';

enum AppEnvironment { dev, prod }

class AppConfig {
  const AppConfig({
    required this.environment,
    this.apiBaseUrl,
  });

  static const production = AppConfig(environment: AppEnvironment.prod);
  static const _buildEnvironment = String.fromEnvironment('APP_ENV');
  static const _buildApiBaseUrl = String.fromEnvironment('API_BASE_URL');

  factory AppConfig.fromEnvironment() {
    return AppConfig.fromValues(
      _buildEnvironment,
      apiBaseUrl: _buildApiBaseUrl.isEmpty ? null : _buildApiBaseUrl,
    );
  }

  factory AppConfig.fromValues(
    String environment, {
    String? apiBaseUrl,
  }) {
    switch (environment) {
      case 'dev':
        return AppConfig(
            environment: AppEnvironment.dev, apiBaseUrl: apiBaseUrl);
      case 'prod':
        return AppConfig(
            environment: AppEnvironment.prod, apiBaseUrl: apiBaseUrl);
      default:
        throw ArgumentError.value(
          environment,
          'environment',
          'Must be "dev" or "prod". Pass --dart-define=APP_ENV=dev '
              'or --dart-define=APP_ENV=prod.',
        );
    }
  }

  final AppEnvironment environment;
  final String? apiBaseUrl;

  bool get isDevelopment => environment == AppEnvironment.dev;
  bool get diagnosticsEnabled => isDevelopment && kDebugMode;
  String get appTitle => isDevelopment ? 'Passwd Hints Dev' : 'Passwd Hints';
}
