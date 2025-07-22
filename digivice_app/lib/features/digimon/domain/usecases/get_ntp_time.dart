import 'package:dartz/dartz.dart';
import 'package:digivice_app/core/error/failures.dart';
import 'package:digivice_app/core/time/ntp_time_service.dart';
import 'package:digivice_app/core/usecases/usecase.dart';
import 'package:injectable/injectable.dart';

class GetNtpTimeParams {
  const GetNtpTimeParams({
    this.ntpServer = 'pool.ntp.org',
    this.useMultipleServers = false,
    this.timeout = const Duration(seconds: 10),
  });

  final String ntpServer;
  final bool useMultipleServers;
  final Duration timeout;
}

@injectable
class GetNtpTime implements UseCase<DateTime, GetNtpTimeParams> {
  const GetNtpTime(this.ntpTimeService);

  final NtpTimeService ntpTimeService;

  @override
  Future<Either<Failure, DateTime>> call(GetNtpTimeParams params) async {
    try {
      final DateTime ntpTime;
      
      if (params.useMultipleServers) {
        ntpTime = await ntpTimeService.getNtpTimeFromMultipleServers(
          timeout: params.timeout,
        );
      } else {
        ntpTime = await ntpTimeService.getNtpTime(
          ntpServer: params.ntpServer,
          timeout: params.timeout,
        );
      }
      
      return Right(ntpTime);
    } catch (e) {
      return Left(ServerFailure());
    }
  }
}
