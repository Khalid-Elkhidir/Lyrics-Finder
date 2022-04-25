import 'package:flutter/material.dart';
import 'package:new_project/features/lyrics_finder/data/models/song_model.dart';

class LyricsPage extends StatelessWidget {
  final SongModel song;
  LyricsPage({required this.song}) ;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(song.songName!),
      ),
      body: SingleChildScrollView(
        child: Center(
          child: Text(
            song.lyrics!,
            textAlign: TextAlign.center,
          ),
        ),
      ),
    );
  }
}
