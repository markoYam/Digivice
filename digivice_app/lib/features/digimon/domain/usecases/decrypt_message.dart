import 'dart:developer';

import 'package:dartz/dartz.dart';
import 'package:digivice_app/core/encryption/native_decryption_service.dart';
import 'package:digivice_app/core/error/failures.dart';
import 'package:digivice_app/core/usecases/usecase.dart';
import 'package:injectable/injectable.dart';

class DecryptMessageParams {
  const DecryptMessageParams({
    required this.encryptedData,
    required this.keyResponse,
  });

  final String encryptedData;
  final String keyResponse;
}

@injectable
class DecryptMessage implements UseCase<String, DecryptMessageParams> {
  const DecryptMessage(this.decryptionService);

  final NativeDecryptionService decryptionService;

  @override
  Future<Either<Failure, String>> call(DecryptMessageParams params) async {
    try {
      final result = await decryptionService.decryptMessage(
        encryptedData: params.encryptedData,
        keyResponse: params.keyResponse,
      );
      return Right(result);
    } on Exception catch (e) {
      log('Error decrypting message: $e');
      return Left(ServerFailure());
    }
  }
}
