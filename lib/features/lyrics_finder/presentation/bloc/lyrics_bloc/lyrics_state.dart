part of 'lyrics_bloc.dart';

abstract class LyricsState extends Equatable {
  const LyricsState();
}

class LyricsEmpty extends LyricsState {
  @override
  List<Object> get props => [];
}

class LyricsLoading extends LyricsState {
  final int index;

  LyricsLoading(this.index);
  @override
  List<Object> get props => [index];
}

class LyricsLoaded extends LyricsState {
  final Lyrics lyrics;

  LyricsLoaded(this.lyrics);

  @override
  List<Object> get props => [lyrics];
}

class LyricsError extends LyricsState {
  final String message;

  LyricsError(this.message);

  @override
  List<Object> get props => [message];
}

class ManualSearch extends LyricsState {
  final SongModel song;
  final int index;

  ManualSearch({required this.song, required this.index});

  @override
  List<Object> get props => [song, index];
}

class NoInternetConnection extends LyricsState {
  final String message = "No Connection";

  @override
  List<Object> get props => [message];
}
