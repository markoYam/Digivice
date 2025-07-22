import 'package:dartz/dartz.dart';
import 'package:digivice_app/core/error/failures.dart';
import 'package:digivice_app/features/digimon/domain/entities/digimon.dart';

abstract class DigimonRepository {
  Future<Either<Failure, String>> generateEncryptedKey();

  // Método para el servicio de consumo de Digimon
  Future<Either<Failure, Digimon>> consumeDigimonService({
    required String nickname,
  });
}
