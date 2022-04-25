import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:new_project/core/errors/failures.dart';

import '../../../data/models/song_model.dart';
import '../../../domain/entities/Lyrics.dart';
import '../../../domain/entities/song.dart';
import '../../../domain/usecases/get_lyrics.dart';

part 'lyrics_event.dart';

part 'lyrics_state.dart';

class LyricsBloc extends Bloc<LyricsEvent, LyricsState> {
  final GetLyrics getLyrics;

  LyricsBloc({required this.getLyrics}) : super(LyricsEmpty()) {
    on<DownloadLyrics>((event, emit) async {
      emit(LyricsLoading(event.index));
      final result = await getLyrics.getLyricsFromApi(event.song);

      result.fold(
        (failure) {
          if (failure is InvalidInfoFailure) {
            emit(ManualSearch(song: event.song, index: event.index));
          } else if (failure is ServerFailure) {
            emit(NoInternetConnection());
          } else {
            emit(LyricsError("Error"));
          }
        },
        (lyrics) async {
          emit(LyricsLoaded(lyrics));
          print("WWWWWWWWWWWWWWWW");
          final result = await getLyrics.writeLyricsToSong(event.song);
          result.fold(
              (fail) => null, (success) async => await event.song.getTags());
        },
      );
    });

    on<DownloadLyricsManually>((event, emit) async {
      emit(LyricsLoading(event.index));

      final result = await getLyrics.getLyricsFromApiManually(
          event.title, event.artist, event.song);
      // final result = await getLyrics.writeLyricsToSong(event.song);

      result.fold(
        (failure) {
          if (failure is InvalidInfoFailure) {
            print("4");
            emit(ManualSearch(song: event.song, index: event.index));
          } else {
            emit(LyricsError("Error"));
          }
        },
        (lyrics) async {
          emit(LyricsLoaded(lyrics));
          final result = await getLyrics.writeLyricsToSong(event.song);
          print(result.toString());
          result.fold(
              (fail) => null, (success) async => await event.song.getTags());
        },
      );
    });

    on<PreviewExistingLyrics>((event, emit) async {
      final result = await getLyrics(event.song);
      result.fold(
        (failure) => emit(LyricsError("Error")),
        (lyrics) => emit(LyricsLoaded(lyrics)),
      );
    });

    on<EscapeSearchDialog>((event, emit) => emit(LyricsEmpty()));

    on<EscapeSnackBar>((event, emit) => emit(LyricsEmpty()));

    on<SearchingManually>((event, emit) => emit(ManualSearch(song: event.song, index: event.index)));
  }
}
