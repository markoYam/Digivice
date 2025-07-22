import 'dart:convert';
import 'dart:developer';

import 'package:digivice_app/core/firebase/firebase_remote_config_service.dart';
import 'package:dio/dio.dart';
import 'package:injectable/injectable.dart';

@singleton
class ConfigurableHttpService {
  ConfigurableHttpService(
    this._dio,
    this._remoteConfigService,
  );

  final Dio _dio;
  final FirebaseRemoteConfigService _remoteConfigService;

  Future<void> updateConfiguration() async {
    // Update Dio base URL from Remote Config
    final baseUrl = _remoteConfigService.baseUrl;
    if (baseUrl.isNotEmpty) {
      // Ensure the URL has the correct protocol
      final formattedUrl = baseUrl.startsWith('http')
          ? baseUrl
          : 'http://$baseUrl';

      _dio.options.baseUrl = formattedUrl;
      log('Updated base URL to: $formattedUrl');
    }

    // Update Dio headers from Remote Config
    final user = _remoteConfigService.userName;
    final password = _remoteConfigService.password;
    if (user.isNotEmpty && password.isNotEmpty) {
      final credentials = base64Encode(utf8.encode('$user:$password'));

      _dio.options.headers['Authorization'] = 'Basic $credentials';
      log('Updated Authorization header with Basic Auth for user: $user');
    } else {
      _dio.options.headers.remove('Authorization');
      log('Removed Authorization header as user or password is empty');
    }
  }

  //prints all configuration values
  void printCurrentConfiguration() {
    final config = {
      'baseUrl': _remoteConfigService.baseUrl,
      'userName': _remoteConfigService.userName,
      'password': _remoteConfigService.password,
      'keyRequest': _remoteConfigService.keyRequest,
      'keyResponse': _remoteConfigService.keyResponse,
      'connectTimeout': _dio.options.connectTimeout?.inMilliseconds,
      'receiveTimeout': _dio.options.receiveTimeout?.inMilliseconds,
      'headers': _dio.options.headers,
    };
    log('Current HTTP configuration: $config');
  }

  // Method to force refresh configuration (useful for manual updates)
  Future<void> refreshConfiguration() async {
    await _remoteConfigService.fetchAndActivate();
    await updateConfiguration();
  }

  Dio get dio => _dio;

  // Getter methods for easy access to current Remote Config values
  String get baseUrl => _remoteConfigService.baseUrl;
  String get userName => _remoteConfigService.userName;
  String get password => _remoteConfigService.password;
  String get keyRequest => _remoteConfigService.keyRequest;
  String get keyResponse => _remoteConfigService.keyResponse;

  // Method to get current Dio configuration info
  Map<String, dynamic> get currentConfiguration => {
    'baseUrl': _dio.options.baseUrl,
    'connectTimeout': _dio.options.connectTimeout?.inMilliseconds,
    'receiveTimeout': _dio.options.receiveTimeout?.inMilliseconds,
    'headers': _dio.options.headers,
  };
}
