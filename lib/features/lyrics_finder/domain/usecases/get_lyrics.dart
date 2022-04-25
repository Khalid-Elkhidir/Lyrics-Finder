import 'package:dartz/dartz.dart';

import '../../../../core/errors/failures.dart';
import '../../../../core/usecase.dart';
import '../../data/models/song_model.dart';
import '../entities/Lyrics.dart';
import '../entities/song.dart';
import '../repositories/lyrics_repository.dart';

class GetLyrics implements UseCase<Lyrics, Song> {
  final LyricsRepository repository;

  GetLyrics({required this.repository});

  @override
  Future<Either<Failure, Lyrics>> call(Song song) async {
    return await repository.getLyricsFromStorage(song);
  }

  Future<Either<Failure, Lyrics>> getLyricsFromApi(SongModel song) async {
    return await repository.getLyricsFromAPI(song);
  }

  Future<Either<Failure, Lyrics>> getLyricsFromApiManually(
      String title, String artist, SongModel song) async {
    return await repository.getLyricsFromApiManually(title, artist);
  }

  Future<Either<Failure, bool>> writeLyricsToSong(Song song) async {
    return await repository.writeLyricsToSong(song);
  }
}
