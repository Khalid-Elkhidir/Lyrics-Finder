part of 'artists_cubit.dart';

abstract class ArtistsState extends Equatable {
  const ArtistsState();
}

class ArtistsInitial extends ArtistsState {
  @override
  List<Object> get props => [];
}

class ArtistsLoaded extends ArtistsState {
  ArtistsLoaded({required this.artists});

  final List<ArtistModel> artists;
  @override
  List<Object> get props => [artists];
}

class ArtistsError extends ArtistsState {
  @override
  List<Object> get props => [];
}