part of 'song_bloc.dart';

abstract class SongEvent extends Equatable {
  const SongEvent();
}

class LoadSongs extends SongEvent {
  LoadSongs();

  @override
  List<Object?> get props => [];
}

class FilterSongs extends SongEvent {
  final String query;
  FilterSongs({required this.query});

  @override
  List<Object?> get props => [query];
}
