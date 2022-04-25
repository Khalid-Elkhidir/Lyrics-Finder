import 'dart:async';

import 'package:dartz/dartz.dart';
import 'package:new_project/core/errors/exceptions.dart';
import 'package:new_project/core/errors/failures.dart';
import 'package:new_project/core/network/network_info.dart';
import 'package:new_project/features/lyrics_finder/data/data_sources/remote_data_source.dart';
import 'package:new_project/features/lyrics_finder/domain/repositories/auth_repository.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AuthRepositoryImpl implements AuthRepository {
  final NetworkInfo networkInfo;
  final RemoteDataSource remoteDataSource;
  final SharedPreferences sharedPreferences;

  AuthRepositoryImpl(
      {required this.networkInfo,
      required this.remoteDataSource,
      required this.sharedPreferences});

  @override
  Either<Failure, bool> accessTokenCheck() {
    final accessToken = remoteDataSource.retrieveAccessToken();
    try {
      if (accessToken != null) {
        return Right(true);
      } else {
        return Right(false);
      }
    } on SignUpException {
      return Left(SignUpFailure());
    }
  }

  @override
  Either<Failure, void> initAppLink() {
    try {
      return Right(remoteDataSource.initUniLinks(sharedPreferences));
    } on Exception {
      return Left(UnknownFailure());
    }
  }

  @override
  Future<Either<Failure, void>> launchUrl() async {
    try {
      if (await networkInfo.isConnected()) {
        return Right(await remoteDataSource.launchUrl());
      } else {
        return Left(ServerFailure());
      }
    } on ServerException {
      return Left(ServerFailure());
    }
  }

  @override
  StreamSubscription? subscription() {
    return remoteDataSource.getStreamSubscription();
  }
}
