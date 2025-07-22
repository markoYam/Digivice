import 'dart:convert';

import 'package:dartz/dartz.dart';
import 'package:dio/dio.dart';
import 'package:digivice_app/core/constants/api_constants.dart';
import 'package:digivice_app/core/error/failures.dart';
import 'package:digivice_app/core/firebase/firebase_remote_config_service.dart';
import 'package:injectable/injectable.dart';

@singleton
class SofttokenService {
  SofttokenService(this.dio, this.firebaseRemoteConfigService);

  final Dio dio;
  final FirebaseRemoteConfigService firebaseRemoteConfigService;

  /// Consume el servicio /softtoken para obtener el encryptedKey
  /// 
  /// Usa Basic Authentication con Username/Password de Firebase Remote Config
  /// 
  /// Returns: encryptedKey cifrado con Key Response (formato iv_hex:encrypted_hex)
  Future<Either<Failure, String>> getSofttokenEncryptedKey() async {
    try {
      final baseUrl = firebaseRemoteConfigService.baseUrl;
      final userName = firebaseRemoteConfigService.userName;
      final password = firebaseRemoteConfigService.password;

      if (baseUrl.isEmpty || userName.isEmpty || password.isEmpty) {
        return Left(ServerFailure());
      }

      // Crear Basic Auth header
      final credentials = base64Encode(utf8.encode('$userName:$password'));
      final basicAuth = 'Basic $credentials';

      // Realizar llamada al servicio /softtoken
      final response = await dio.get<Map<String, dynamic>>(
        '$baseUrl${ApiConstants.softtokenEndpoint}',
        options: Options(
          headers: {
            ApiConstants.authorization: basicAuth,
            ApiConstants.contentType: ApiConstants.applicationJson,
          },
          sendTimeout: const Duration(seconds: 10),
          receiveTimeout: const Duration(seconds: 10),
        ),
      );

      // Validar respuesta
      if (response.statusCode != 200) {
        return Left(ServerFailure());
      }

      final responseData = response.data;
      if (responseData == null) {
        return Left(ServerFailure());
      }

      // Extraer encryptedKey de la respuesta
      final encryptedKey = responseData['encryptedKey'] as String?;
      if (encryptedKey == null || encryptedKey.isEmpty) {
        return Left(ServerFailure());
      }

      return Right(encryptedKey);
    } catch (e) {
      if (e is DioException) {
        return Left(NetworkFailure());
      }
      return Left(ServerFailure());
    }
  }
}
