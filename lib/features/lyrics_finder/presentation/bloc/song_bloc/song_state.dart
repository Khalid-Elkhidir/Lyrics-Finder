part of 'song_bloc.dart';

abstract class SongState extends Equatable {
  const SongState();
}

class Empty extends SongState {
  final String message;
  Empty(this.message);
  @override
  List<Object> get props => [message];
}

class Loading extends SongState {
  @override
  List<Object?> get props => [];
}

class Loaded extends SongState {
  List<SongModel> songs;

  Loaded(this.songs);

  @override
  List<Object?> get props => [songs];
}

class Error extends SongState {
  final String message;

  Error(this.message);

  @override
  List<Object?> get props => [message];
}
