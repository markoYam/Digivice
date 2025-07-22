import 'package:equatable/equatable.dart';

abstract class Failure extends Equatable {
  const Failure();

  @override
  List<Object> get props => [];
}

// General failures
class ServerFailure extends Failure {}

class CacheFailure extends Failure {}

class NetworkFailure extends Failure {}

class ValidationFailure extends Failure {
  const ValidationFailure(this.message);
  
  final String message;

  @override
  List<Object> get props => [message];
}
