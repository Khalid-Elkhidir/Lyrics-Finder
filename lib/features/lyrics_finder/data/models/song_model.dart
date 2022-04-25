import 'dart:typed_data';
import 'package:audiotagger/audiotagger.dart';
import 'package:audiotagger/models/tag.dart';

import '../../domain/entities/song.dart';

class SongModel extends Song {
  final String path;
  String? songName;
  String? artistName;
  String? albumName;
  String? lyrics;
  Uint8List? artwork;
  Tag? tag;

  final Audiotagger _audiotagger = Audiotagger();

  SongModel({required this.path})
      : super(
          path: path,
        );

  Future<bool> getTags() async {
    try {
      tag = await _audiotagger.readTags(path: path);
    } on Error  {
      print("ERROR");
    } on Exception {
      print("Exception");
    }


    if (tag != null) {
      if (tag!.title == null || tag!.title!.isEmpty) {
        songName = path;
      } else{
        songName = tag!.title!.trimLeft();
      }
      if (tag!.artist == null || tag!.artist!.isEmpty) {
        artistName = "Unknown artist";
      } else{
        artistName = tag!.artist!.trimLeft();
      }
      if (tag!.album == null || tag!.album!.isEmpty) {
        albumName = "Unknown album";
      } else{
        albumName = tag!.album!.trimLeft();
      }
      lyrics = tag!.lyrics;
      artwork = (await _audiotagger.readArtwork(path: path));
      return true;
    } else {
      return false;
    }
  }

  Future<bool> writeLyrics(String text) async {
    bool state = await _audiotagger.writeTag(
      path: path,
      tagField: "lyrics",
      value: text,
    ) as bool;
    return state;
  }
}
