import 'package:new_project/features/lyrics_finder/data/models/album_model.dart';

class ArtistModel {
  final String artistName;
  final List<AlbumModel> artistAlbums;

  ArtistModel({required this.artistName, required this.artistAlbums});
}
