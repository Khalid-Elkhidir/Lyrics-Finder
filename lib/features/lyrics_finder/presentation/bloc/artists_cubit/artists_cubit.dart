import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:new_project/features/lyrics_finder/data/models/artist_model.dart';
import 'package:new_project/features/lyrics_finder/domain/usecases/get_songs.dart';

import '../../../domain/usecases/get_artists.dart';

part 'artists_state.dart';

class ArtistsCubit extends Cubit<ArtistsState> {
  ArtistsCubit({required this.getArtists}) : super(ArtistsInitial());

  final GetArtists getArtists;
  late final List<ArtistModel> artists;

  void loadingArtists() async {
    final result = await getArtists(NoParams());

    result.fold(
      (failure) => emit(ArtistsError()),
      (artists) {
        this.artists = artists;
        emit(ArtistsLoaded(artists: artists));
      },
    );
  }

  void filteringArtists(String query) {
    List<ArtistModel> filteredArtists = [];
    for (int i = 0; i < artists.length; i++) {
      if (artists[i].artistName.toLowerCase().contains(query.toLowerCase()) ||
          artists[i].artistAlbums.any((album) =>
              album.albumTitle.toLowerCase().contains(query.toLowerCase())) ||
          artists[i].artistAlbums.any((album) => album.albumSongs.any((song) =>
              song.songName!.toLowerCase().contains(query.toLowerCase())))) {
        filteredArtists.add(artists[i]);
      }
    }
    emit(ArtistsLoaded(artists: filteredArtists));
  }
}
