import 'package:dartz/dartz.dart';
import 'package:digivice_app/core/error/failures.dart';
import 'package:digivice_app/core/usecases/usecase.dart';
import 'package:digivice_app/features/digimon/domain/entities/digimon.dart';
import 'package:digivice_app/features/digimon/domain/repositories/digimon_repository.dart';
import 'package:equatable/equatable.dart';
import 'package:injectable/injectable.dart';

@injectable
class ConsumeDigimonService
    implements UseCase<Digimon, ConsumeDigimonServiceParams> {
  const ConsumeDigimonService(this.repository);

  final DigimonRepository repository;

  @override
  Future<Either<Failure, Digimon>> call(
    ConsumeDigimonServiceParams params,
  ) async {
    return repository.consumeDigimonService(nickname: params.nickname);
  }
}

class ConsumeDigimonServiceParams extends Equatable {
  const ConsumeDigimonServiceParams({
    required this.nickname,
  });

  final String nickname;

  @override
  List<Object> get props => [nickname];
}
