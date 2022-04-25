part of 'album_cubit.dart';

abstract class AlbumState extends Equatable {
  const AlbumState();
}

class AlbumInitial extends AlbumState {
  @override
  List<Object> get props => [];
}

class AlbumLoading extends AlbumState {
  @override
  List<Object> get props => [];
}

class AlbumLoaded extends AlbumState {
  final List<AlbumModel> albums;

  AlbumLoaded({required this.albums});

  @override
  List<Object> get props => [albums];
}

class AlbumError extends AlbumState {
  final String message;

  AlbumError({required this.message});

  @override
  List<Object> get props => [message];
}
