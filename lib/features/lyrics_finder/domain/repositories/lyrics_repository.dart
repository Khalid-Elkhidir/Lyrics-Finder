import 'package:dartz/dartz.dart';

import '../../../../core/errors/failures.dart';
import '../../data/models/song_model.dart';
import '../entities/Lyrics.dart';
import '../entities/song.dart';

abstract class LyricsRepository {
  Future<Either<Failure, Lyrics>> getLyricsFromStorage(Song song);
  Future<Either<Failure, Lyrics>> getLyricsFromAPI(SongModel song);
  Future<Either<Failure, Lyrics>> getLyricsFromApiManually(String title, String artist);
  Future<Either<Failure, bool>> writeLyricsToSong(Song song);
}
