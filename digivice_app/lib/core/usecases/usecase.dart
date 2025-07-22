import 'package:dartz/dartz.dart';
import 'package:digivice_app/core/error/failures.dart';

abstract class UseCase<Type, Params> {
  Future<Either<Failure, Type>> call(Params params);
}

class NoParams {
  const NoParams();
}

class LoginParams {
  const LoginParams({
    required this.user,
    required this.password,
  });
  final String user;
  final String password;
}
