import 'package:firebase_remote_config/firebase_remote_config.dart';
import 'package:injectable/injectable.dart';

@module
abstract class FirebaseModule {
  @injectable
  FirebaseRemoteConfig get remoteConfig => FirebaseRemoteConfig.instance;
}
