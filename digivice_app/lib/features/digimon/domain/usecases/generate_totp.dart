import 'package:dartz/dartz.dart';
import 'package:digivice_app/core/error/failures.dart';
import 'package:digivice_app/core/security/totp_service.dart';
import 'package:digivice_app/core/usecases/usecase.dart';
import 'package:injectable/injectable.dart';
import 'package:otp/otp.dart';

class GenerateTotpParams {
  const GenerateTotpParams({
    required this.secret,
    this.timeStep = 30,
    this.digits = 6,
    this.algorithm = Algorithm.SHA1,
    this.useNtpTime = true,
  });

  final String secret;
  final int timeStep;
  final int digits;
  final Algorithm algorithm;
  final bool useNtpTime;
}

@injectable
class GenerateTotp implements UseCase<String, GenerateTotpParams> {
  const GenerateTotp(this.totpService);

  final TotpService totpService;

  @override
  Future<Either<Failure, String>> call(GenerateTotpParams params) async {
    try {
      final code = await totpService.generateTotp(
        secret: params.secret,
        timeStep: params.timeStep,
        digits: params.digits,
        algorithm: params.algorithm,
        useNtpTime: params.useNtpTime,
      );
      return Right(code);
    } catch (e) {
      return Left(ServerFailure());
    }
  }
}
