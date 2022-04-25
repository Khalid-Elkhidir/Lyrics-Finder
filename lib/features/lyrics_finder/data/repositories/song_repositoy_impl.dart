import 'package:dartz/dartz.dart';
import 'package:new_project/features/lyrics_finder/data/models/album_model.dart';
import 'package:new_project/features/lyrics_finder/data/models/artist_model.dart';

import '../../../../core/errors/failures.dart';
import '../../domain/repositories/songs_repository.dart';
import '../data_sources/local_data_source.dart';
import '../models/song_model.dart';

class SongRepositoryImpl implements SongsRepository {
  LocalDataSource localDataSource;

  SongRepositoryImpl(this.localDataSource);

  @override
  Future<Either<Failure, List<SongModel>>> getSongs() async {
    try {
      return Right(await localDataSource.getSongs());
    } on Exception {
      return Left(NotFoundFailure());
    }
  }

  @override
  Either<Failure, List<AlbumModel>> getAlbums() {
    return Right(localDataSource.getAlbums());
  }

  @override
  Either<Failure, List<ArtistModel>> getArtists() {
    return Right(localDataSource.getArtists());
  }
}
