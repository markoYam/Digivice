import 'package:digivice_app/core/constants/api_constants.dart';
import 'package:firebase_remote_config/firebase_remote_config.dart';
import 'package:flutter/foundation.dart';
import 'package:injectable/injectable.dart';

abstract class FirebaseRemoteConfigService {
  Future<void> initialize();
  Future<void> fetchAndActivate();
  String getString(String key);
  bool getBool(String key);
  int getInt(String key);
  double getDouble(String key);

  // API specific getters
  String get baseUrl;
  String get userName;
  String get password;
  String get keyRequest;
  String get keyResponse;
}

@Injectable(as: FirebaseRemoteConfigService)
class FirebaseRemoteConfigServiceImpl implements FirebaseRemoteConfigService {
  FirebaseRemoteConfigServiceImpl(this._remoteConfig);

  final FirebaseRemoteConfig _remoteConfig;

  @override
  Future<void> initialize() async {
    await _remoteConfig.setConfigSettings(
      RemoteConfigSettings(
        fetchTimeout: const Duration(minutes: 1),
        minimumFetchInterval: const Duration(hours: 1),
      ),
    );

    await _remoteConfig.setDefaults({
      ApiConstants.baseUrlKey: ApiConstants.defaultBaseUrl,
      ApiConstants.userNameKey: ApiConstants.defaultUserName,
      ApiConstants.passwordKey: ApiConstants.defaultPassword,
      ApiConstants.keyRequestKey: ApiConstants.defaultKeyRequest,
      ApiConstants.keyResponseKey: ApiConstants.defaultKeyResponse,
    });

    await fetchAndActivate();
  }

  @override
  Future<void> fetchAndActivate() async {
    try {
      await _remoteConfig.fetchAndActivate();
    } on Exception catch (e) {
      // Handle fetch error - continue with defaults
      if (kDebugMode) {
        print('Failed to fetch remote config: $e');
      }
    }
  }

  @override
  String getString(String key) {
    return _remoteConfig.getString(key);
  }

  @override
  bool getBool(String key) {
    return _remoteConfig.getBool(key);
  }

  @override
  int getInt(String key) {
    return _remoteConfig.getInt(key);
  }

  @override
  double getDouble(String key) {
    return _remoteConfig.getDouble(key);
  }

  // API specific getters
  @override
  String get baseUrl => getString(ApiConstants.baseUrlKey);

  @override
  String get userName => getString(ApiConstants.userNameKey);

  @override
  String get password => getString(ApiConstants.passwordKey);

  @override
  String get keyRequest => getString(ApiConstants.keyRequestKey);

  @override
  String get keyResponse => getString(ApiConstants.keyResponseKey);
}
