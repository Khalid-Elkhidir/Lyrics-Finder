part of 'lyrics_bloc.dart';

abstract class LyricsEvent extends Equatable {
  const LyricsEvent();
}

class DownloadLyrics extends LyricsEvent {
  final SongModel song;
  final int index;

  DownloadLyrics({required this.song, required this.index});

  @override
  List<Object?> get props => [song];
}

class DownloadLyricsManually extends LyricsEvent {
  final String title;
  final String artist;
  final SongModel song;
  final int index;

  DownloadLyricsManually({
    required this.title,
    required this.artist,
    required this.song,
    required this.index,
  });

  @override
  List<Object?> get props => [title, artist];
}

class PreviewExistingLyrics extends LyricsEvent {
  final Song song;

  PreviewExistingLyrics(this.song);

  @override
  List<Object?> get props => [song];
}

class SearchingManually extends LyricsEvent {
  final SongModel song;
  final int index;

  SearchingManually({required this.song, required this.index});

  @override
  List<Object?> get props => [song];
}

class EscapeSearchDialog extends LyricsEvent {
  @override
  List<Object?> get props => [];
}

class EscapeSnackBar extends LyricsEvent {
  @override
  List<Object?> get props => [];
}
