import 'package:dartz/dartz.dart';
import 'package:new_project/features/lyrics_finder/data/models/album_model.dart';

import '../../../../core/errors/failures.dart';
import '../../data/models/artist_model.dart';
import '../../data/models/song_model.dart';

abstract class SongsRepository {
  Future<Either<Failure, List<SongModel>>> getSongs();
  Either<Failure, List<AlbumModel>> getAlbums();
  Either<Failure, List<ArtistModel>> getArtists();
}
