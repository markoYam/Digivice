import 'dart:developer' as developer;

class AppLogger {
  static void log(String message, {String? name}) {
    developer.log(message, name: name ?? 'DigiviceApp');
  }
  
  static void error(String message, {String? name, Object? error}) {
    developer.log(
      message,
      name: name ?? 'DigiviceApp',
      error: error,
    );
  }
  
  static void info(String message, {String? name}) {
    developer.log(
      '[INFO] $message',
      name: name ?? 'DigiviceApp',
    );
  }
  
  static void warning(String message, {String? name}) {
    developer.log(
      '[WARNING] $message',
      name: name ?? 'DigiviceApp',
    );
  }
}
