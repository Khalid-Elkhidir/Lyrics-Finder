import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:new_project/features/lyrics_finder/data/models/album_model.dart';
import 'package:new_project/features/lyrics_finder/domain/usecases/get_albums.dart';
import 'package:new_project/features/lyrics_finder/domain/usecases/get_songs.dart';

part 'album_state.dart';

class AlbumCubit extends Cubit<AlbumState> {
  AlbumCubit({required this.getAlbums}) : super(AlbumInitial());

  final GetAlbums getAlbums;
  late final List<AlbumModel> albums;

  void loadingAlbums() async {
    final result = await getAlbums(NoParams());

    result.fold(
      (failure) => emit(AlbumError(message: "Error Occurred")),
      (albums) {
        this.albums = albums;
        emit(AlbumLoaded(albums: albums));
      },
    );
  }

  void filteringAlbums(String query) {
    List<AlbumModel> filteredAlbums = [];
    for (int i = 0; i < albums.length; i++) {
      if (albums[i].albumTitle.toLowerCase().contains(query.toLowerCase()) ||
          albums[i].artistName.toLowerCase().contains(query.toLowerCase()) ||
          albums[i].albumSongs.any((song) => song.songName!.toLowerCase().contains(query.toLowerCase()))) {
        filteredAlbums.add(albums[i]);
      }
      emit(AlbumLoaded(albums: filteredAlbums));
    }
  }
}
