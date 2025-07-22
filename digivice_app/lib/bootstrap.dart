import 'dart:async';
import 'dart:developer';

import 'package:bloc/bloc.dart';
import 'package:digivice_app/core/di/injection_container.dart';
import 'package:digivice_app/core/firebase/firebase_initialization_service.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/widgets.dart';

class AppBlocObserver extends BlocObserver {
  const AppBlocObserver();

  @override
  void onChange(BlocBase<dynamic> bloc, Change<dynamic> change) {
    super.onChange(bloc, change);
    log('onChange(${bloc.runtimeType}, $change)');
  }

  @override
  void onError(BlocBase<dynamic> bloc, Object error, StackTrace stackTrace) {
    log('onError(${bloc.runtimeType}, $error, $stackTrace)');
    super.onError(bloc, error, stackTrace);
  }
}

Future<void> bootstrap(FutureOr<Widget> Function() builder) async {
  WidgetsFlutterBinding.ensureInitialized();

  FlutterError.onError = (details) {
    log(details.exceptionAsString(), stackTrace: details.stack);
  };

  Bloc.observer = const AppBlocObserver();

  // Initialize Firebase Core FIRST, before configuring dependencies
  try {
    await Firebase.initializeApp();
    log('Firebase Core initialized successfully');
  } on Exception catch (e) {
    log('Firebase Core initialization failed: $e');
  }

  // Configure dependency injection (now Firebase services can be accessed)
  configureDependencies();

  // Initialize Firebase Remote Config and update HTTP configuration
  try {
    final firebaseInitService = getIt<FirebaseInitializationService>();
    await firebaseInitService.initialize();
  } on Exception catch (e) {
    log('Firebase Remote Config initialization failed: $e');
  }

  runApp(await builder());
}
