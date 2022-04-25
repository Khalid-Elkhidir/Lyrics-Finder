import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';

import '../../../data/models/song_model.dart';
import '../../../domain/usecases/get_songs.dart';

part 'song_event.dart';

part 'song_state.dart';

class SongBloc extends Bloc<SongEvent, SongState> {
  final GetSongs getSongs;
  late final List<SongModel> songs;

  SongBloc({required this.getSongs}) : super(Loading()) {
    on<LoadSongs>((event, emit) async {
      var result = await getSongs(NoParams());

      result.fold(
        (failure) => emit(Error("Error")),
        (songs) {
          this.songs = songs;
          emit(Loaded(songs));
        },
      );
    });

    on<FilterSongs>((event, emit) {
      List<SongModel> filteredSongs = [];
      for(int  i=0 ; i<songs.length ; i++) {
        if(
        songs[i].songName!
            .toLowerCase()
            .contains(event.query.toLowerCase()) ||
            songs[i].artistName!
                .toLowerCase()
                .contains(event.query.toLowerCase()) ||
            songs[i].albumName!
                .toLowerCase()
                .contains(event.query.toLowerCase())
        ) {
          filteredSongs.add(songs[i]);
        }
      }
      emit(Loaded(filteredSongs));
    });
  }
}
