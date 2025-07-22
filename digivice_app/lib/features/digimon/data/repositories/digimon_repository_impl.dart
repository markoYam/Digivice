import 'dart:developer';

import 'package:dartz/dartz.dart';
import 'package:digivice_app/core/encryption/native_decryption_service.dart';
import 'package:digivice_app/core/error/exceptions.dart';
import 'package:digivice_app/core/error/failures.dart';
import 'package:digivice_app/core/firebase/firebase_remote_config_service.dart';
import 'package:digivice_app/core/network/network_info.dart';
import 'package:digivice_app/core/security/totp_service.dart';
import 'package:digivice_app/features/digimon/data/datasources/digimon_data_source.dart';
import 'package:digivice_app/features/digimon/domain/entities/digimon.dart';
import 'package:digivice_app/features/digimon/domain/repositories/digimon_repository.dart';
import 'package:injectable/injectable.dart';

@Injectable(as: DigimonRepository)
class DigimonRepositoryImpl implements DigimonRepository {
  DigimonRepositoryImpl({
    required this.remoteDataSource,
    required this.localDataSource,
    required this.networkInfo,
    required this.firebaseRemoteConfigService,
    required this.nativeDecryptionService,
    required this.totpService,
  });

  final DigimonRemoteDataSource remoteDataSource;
  final DigimonLocalDataSource localDataSource;
  final NetworkInfo networkInfo;
  final FirebaseRemoteConfigService firebaseRemoteConfigService;
  final NativeDecryptionService nativeDecryptionService;
  final TotpService totpService;

  @override
  Future<Either<Failure, String>> generateEncryptedKey() async {
    if (await networkInfo.isConnected) {
      try {
        // Implement the logic to generate an encrypted key
        // This is a placeholder implementation
        final encryptedKey = await remoteDataSource.generateEncryptedKey();
        return Right(encryptedKey);
      } on Exception {
        return Left(ServerFailure());
      }
    } else {
      return Left(NetworkFailure());
    }
  }

  @override
  Future<Either<Failure, Digimon>> consumeDigimonService({
    required String nickname,
  }) async {
    try {
      // 1. Obtener configuración de Firebase Remote Config
      final baseUrl = firebaseRemoteConfigService.baseUrl;
      final encryptedKeyFromConfigResult = await generateEncryptedKey();
      var encryptedKeyFromConfig = '';
      if (encryptedKeyFromConfigResult.isLeft()) {
        return Left(ServerFailure());
      }
      if (encryptedKeyFromConfigResult.isRight()) {
        encryptedKeyFromConfig = encryptedKeyFromConfigResult.getOrElse(
          () => '',
        );
      }

      final keyRequest = firebaseRemoteConfigService.keyRequest;
      log('Key Request: $keyRequest');
      final keyResponse = firebaseRemoteConfigService.keyResponse;
      log('Key Response: $keyResponse');

      if (baseUrl.isEmpty ||
          encryptedKeyFromConfig.isEmpty ||
          keyRequest.isEmpty) {
        return Left(ServerFailure());
      }

      // 2. Desencriptar la clave usando el servicio nativo
      final decryptedKey = await nativeDecryptionService.decryptMessage(
        encryptedData: encryptedKeyFromConfig,
        keyResponse: keyResponse,
      );
      log('Decrypted Key: $decryptedKey');

      // 3. Generar OTP usando TOTP con tiempo NTP
      final otpCode = await totpService.generateTotp(
        secret: decryptedKey,
      );

      log('Generated OTP: $otpCode');

      // 4. Cifrar la clave desencriptada usando Key Request para crear encryptedKey
      final encryptedKeyForService = await nativeDecryptionService
          .encryptMessage(
            plainData: decryptedKey, 
            keyRequest: keyRequest,
          );

      log('🔐 Consumiendo servicio /digimon:');
      log('  - OTP: $otpCode');
      log('  - Nickname: $nickname');
      log('  - EncryptedKey: $encryptedKeyForService');

      // 5. Consumir servicio /digimon usando el data source
      final digimon = await remoteDataSource.consumeDigimonService(
        otp: otpCode,
        encryptedKey: encryptedKeyForService,
        username: nickname,
      );

      log('✅ Digimon obtenido exitosamente:');
      log('  - ID: ${digimon.id}');
      log('  - Nombre: ${digimon.name}');
      log('  - Nivel: ${digimon.primaryLevel}');
      log('  - Tipo: ${digimon.primaryType}');
      log('  - Imagen: ${digimon.primaryImageUrl}');
      log('  - X-Antibody: ${digimon.xAntibody}');
      log('  - Release Date: ${digimon.releaseDate}');
      return Right(digimon);
    } on NetworkException {
      return Left(NetworkFailure());
    } on ServerException {
      return Left(ServerFailure());
    }
  }
}
