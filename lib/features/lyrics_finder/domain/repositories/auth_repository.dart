import 'dart:async';

import 'package:dartz/dartz.dart';

import '../../../../core/errors/failures.dart';

abstract class AuthRepository {
  Either<Failure, bool> accessTokenCheck();
  Future<Either<Failure, void>> launchUrl();
  Either<Failure, void> initAppLink();
  StreamSubscription? subscription();
}