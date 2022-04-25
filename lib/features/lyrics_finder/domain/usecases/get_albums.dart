import 'package:dartz/dartz.dart';
import 'package:new_project/core/errors/failures.dart';
import 'package:new_project/core/usecase.dart';
import 'package:new_project/features/lyrics_finder/data/models/album_model.dart';
import 'package:new_project/features/lyrics_finder/domain/repositories/songs_repository.dart';
import 'package:new_project/features/lyrics_finder/domain/usecases/get_songs.dart';

class GetAlbums implements UseCase<List<AlbumModel>, NoParams> {
  GetAlbums({required this.repository});

  final SongsRepository repository;

  @override
  Future<Either<Failure, List<AlbumModel>>> call(params) async {
    return repository.getAlbums();
  }
}
