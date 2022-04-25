import 'dart:io';

import 'package:new_project/core/errors/exceptions.dart';
import 'package:new_project/features/lyrics_finder/data/models/album_model.dart';
import 'package:new_project/features/lyrics_finder/data/models/artist_model.dart';
import 'package:path_provider/path_provider.dart';

import '../../domain/entities/Lyrics.dart';
import '../../domain/entities/song.dart';
import '../models/song_model.dart';

abstract class LocalDataSource {
  Future<List<SongModel>> getSongs();
  Future<Lyrics> getLyrics(Song song);
  List<AlbumModel> getAlbums();
  List<ArtistModel> getArtists();
}

class LocalDataSourceImpl implements LocalDataSource {
  late List<SongModel> songs;
  late List<AlbumModel> albums;

  @override
  Future<Lyrics> getLyrics(covariant SongModel songModel) async {
    return Lyrics(text: songModel.lyrics!);
  }

  @override
  Future<List<SongModel>> getSongs() async {
    try {
      final storage = await getExternalStorageDirectories();
      final String INTERNAL_STORAGE_PATH =
          storage![0].parent.parent.parent.parent.path;

      List<SongModel> songs = [];
      List<FileSystemEntity> files = [];

      files.addAll(await addSongsToList(INTERNAL_STORAGE_PATH));

      if (storage.length == 2) {
        final String EXTERNAL_STORAGE_PATH =
            storage[1].parent.parent.parent.parent.path;
        files.addAll(await addSongsToList(EXTERNAL_STORAGE_PATH));
      }

      for (int i = 0; i < files.length; i++) {
        if (files[i].path.endsWith(".mp3")) {
          // print(files[i].path);
          if (files[i].path.isNotEmpty) {
            final SongModel songModel = SongModel(path: files[i].path);
            bool tags = await songModel.getTags();
            if (tags == true) {
              songs.add(songModel);
            }
          }
        }
      }
      this.songs = songs;
      print(songs.length);
      final albums = getAlbums();
      final artists = getArtists();
      print("${albums.length} - ${artists.length}");
      for(var x in artists){
        print(x.artistName);
        print(x.artistAlbums.length);
      }
      songs.sort((a, b) => a.songName!.compareTo(b.songName!));
      return songs;
    } on Exception {
      throw NotFoundException();
    }
  }

  Future<List<FileSystemEntity>> addSongsToList(String path) async {
    List<FileSystemEntity> directories =
        Directory(path).listSync(recursive: false);
    List<FileSystemEntity> files = [];

    directories.removeWhere((directory) => directory.path.contains("Android"));
    directories.forEach((element) {
      if (element is Directory) {
        files.addAll(element.listSync(recursive: true));
      } else {
        files.add(element);
      }
    });
    return files;
  }

  List<AlbumModel> getAlbums() {
    List<AlbumModel> albumsList = [];
    for (var song in songs) {
      if (albumsList.isEmpty) {
        albumsList.add(
          AlbumModel(
            albumTitle: song.albumName!,
            artistName: song.artistName!,
            albumSongs: [song],
          ),
        );
      } else {
        bool found = false;
        for (var album in albumsList) {
          if (album.albumTitle == song.albumName) {
            album.albumSongs.add(song);
            found = true;
            break;
          }
        }
        if (!found) {
          albumsList.add(AlbumModel(
            albumTitle: song.albumName ?? "Unknown",
            artistName: song.artistName ?? "Unknown",
            albumSongs: [song],
          ));
        }
      }
    }
    albums = albumsList;
    albumsList.sort((a, b) => a.albumTitle.compareTo(b.albumTitle));
    return albumsList;
  }

  List<ArtistModel> getArtists() {
    List<ArtistModel> artistList = [];
    for (var album in albums) {
      if (artistList.isEmpty) {
        artistList.add(ArtistModel(
          artistName: album.artistName,
          artistAlbums: [album],
        ));
      } else {
        bool found = false;
        for (var artist in artistList) {
          if (artist.artistName == album.artistName) {
            artist.artistAlbums.add(album);
            found = true;
            break;
          }
        }
        if (!found) {
          artistList.add(ArtistModel(
            artistName: album.artistName,
            artistAlbums: [album],
          ));
        }
      }
    }
    artistList.sort((a, b) => a.artistName.compareTo(b.artistName));
    return artistList;
  }
}
