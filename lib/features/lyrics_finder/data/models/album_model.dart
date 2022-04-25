import 'package:new_project/features/lyrics_finder/data/models/song_model.dart';

class AlbumModel {
  final String albumTitle;
  final String artistName;
  final List<SongModel> albumSongs;

  AlbumModel({required this.albumTitle, required this.artistName, required this.albumSongs});
}
