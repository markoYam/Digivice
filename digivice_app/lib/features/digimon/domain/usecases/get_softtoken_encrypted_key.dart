import 'package:dartz/dartz.dart';
import 'package:digivice_app/core/error/failures.dart';
import 'package:digivice_app/core/services/softtoken_service.dart';
import 'package:digivice_app/core/usecases/usecase.dart';
import 'package:injectable/injectable.dart';

@injectable
class GetSofttokenEncryptedKey implements UseCase<String, NoParams> {
  const GetSofttokenEncryptedKey(this.softtokenService);

  final SofttokenService softtokenService;

  @override
  Future<Either<Failure, String>> call(NoParams params) async {
    return softtokenService.getSofttokenEncryptedKey();
  }
}
