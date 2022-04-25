import 'package:dartz/dartz.dart';
import 'package:new_project/features/lyrics_finder/data/models/song_model.dart';

import '../../../../core/errors/exceptions.dart';
import '../../../../core/errors/failures.dart';
import '../../../../core/network/network_info.dart';
import '../../domain/entities/Lyrics.dart';
import '../../domain/entities/song.dart';
import '../../domain/repositories/lyrics_repository.dart';
import '../data_sources/local_data_source.dart';
import '../data_sources/remote_data_source.dart';

class LyricsRepositoryImpl implements LyricsRepository {
  final LocalDataSource localDataSource;
  final RemoteDataSource remoteDataSource;
  final NetworkInfo networkInfo;

  LyricsRepositoryImpl(
      {required this.localDataSource,
      required this.remoteDataSource,
      required this.networkInfo});

  @override
  Future<Either<Failure, Lyrics>> getLyricsFromStorage(Song song) async {
    try {
      return Right(await localDataSource.getLyrics(song));
    } on NotFoundException {
      Left(NotFoundFailure());
    }
    return Left(UnknownFailure());
  }

  @override
  Future<Either<Failure, Lyrics>> getLyricsFromAPI(SongModel song) async {
    if (await networkInfo.isConnected()) {
      try {
        return Right(
            await remoteDataSource.getLyrics(song.songName!, song.artistName!));
      } on InvalidInfoException {
        return Left(InvalidInfoFailure());
      } on Exception {
        return Left(ServerFailure());
      }
    } else {
      return Left(ServerFailure());
    }
  }

  @override
  Future<Either<Failure, bool>> writeLyricsToSong(Song song) async {
    try {
      return Right(await remoteDataSource.writeLyrics(song));
    } on Exception catch (e) {
      if (e is InvalidInfoException) {
        return Left(InvalidInfoFailure());
      } else {
        return Left(UnknownFailure());
      }
    }
  }

  @override
  Future<Either<Failure, Lyrics>> getLyricsFromApiManually(
      String title, String artist) async {
    print("Manually");
    if (await networkInfo.isConnected()) {
      try {
        return Right(await remoteDataSource.getLyrics(title, artist));
      } on Exception {
        return Left(UnknownFailure());
      }
    } else {
      return Left(ServerFailure());
    }
  }
}
