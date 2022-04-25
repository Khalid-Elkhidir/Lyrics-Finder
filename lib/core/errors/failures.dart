import 'package:equatable/equatable.dart';

abstract class Failure extends Equatable {
  @override
  List<Object?> get props => [];
}

class ServerFailure extends Failure {}

class NotFoundFailure extends Failure {}

class AccessTokenFailure extends Failure {}

class UnknownFailure extends Failure {}

class InvalidInfoFailure extends Failure {}

class CacheFailure extends Failure {}

class SignUpFailure extends Failure {}
