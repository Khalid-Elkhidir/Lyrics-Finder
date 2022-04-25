import 'package:dartz/dartz.dart';

import '../../../../core/errors/failures.dart';
import '../../../../core/usecase.dart';
import '../../data/models/song_model.dart';
import '../repositories/songs_repository.dart';

class GetSongs implements UseCase<List<SongModel>, NoParams> {
  final SongsRepository repository;

  GetSongs({required this.repository});

  @override
  Future<Either<Failure, List<SongModel>>> call(NoParams noParams) async {
    return await repository.getSongs();
  }
}

class NoParams {
}
