import 'package:dartz/dartz.dart';
import 'package:digivice_app/core/error/failures.dart';
import 'package:digivice_app/core/usecases/usecase.dart';
import 'package:digivice_app/features/digimon/domain/repositories/digimon_repository.dart';
import 'package:injectable/injectable.dart';

@injectable
class GetEncryptedKey implements UseCase<String, NoParams> {
  const GetEncryptedKey(this.repository);

  final DigimonRepository repository;

  @override
  Future<Either<Failure, String>> call(NoParams params) async {
    return repository.generateEncryptedKey(
    );
  }
}
