import 'dart:developer';

import 'package:digivice_app/core/firebase/firebase_remote_config_service.dart';
import 'package:digivice_app/core/network/configurable_http_service.dart';
import 'package:injectable/injectable.dart';

@injectable
class FirebaseInitializationService {
  FirebaseInitializationService(
    this._remoteConfigService,
    this._httpService,
  );

  final FirebaseRemoteConfigService _remoteConfigService;
  final ConfigurableHttpService _httpService;

  Future<void> initialize() async {
    try {
      // Firebase Core is already initialized in bootstrap.dart
      // Initialize Remote Config
      await _remoteConfigService.initialize();

      // Update HTTP service configuration with Remote Config values
      await _httpService.updateConfiguration();

      // Optionally print current configuration for debugging
      _httpService.printCurrentConfiguration();

      log('Firebase Remote Config and HTTP service initialized successfully');
    } on Exception catch (e) {
      log('Firebase Remote Config initialization failed: $e');
      // Continue with default configuration
    }
  }
}
