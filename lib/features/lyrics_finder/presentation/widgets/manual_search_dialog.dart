import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:new_project/features/lyrics_finder/presentation/bloc/lyrics_bloc/lyrics_bloc.dart';

import '../../data/models/song_model.dart';

class ManualSearchDialog extends StatelessWidget {
  final SongModel song;
  String? title;
  String? artist;
  final int index;

  ManualSearchDialog({required this.song, required this.index});

  @override
  Widget build(BuildContext context) {
    return SimpleDialog(
      contentPadding: EdgeInsets.symmetric(horizontal: 8),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(25),
      ),
      title: Text("Search manually", textAlign: TextAlign.center,),
      children: [
        TextField(
          decoration: InputDecoration(
            hintStyle: TextStyle(
              color: Colors.grey,
            ),
            hintText: "Title",
          ),
          onChanged: (value) => title = value,
        ),
        TextField(
          decoration: InputDecoration(
            hintStyle: TextStyle(
              color: Colors.grey,
            ),
            hintText: "Artist",
          ),
          onChanged: (value) => artist = value,
        ),
        SizedBox(height: 10,),
        ElevatedButton(
          onPressed: () {
            if (title!.isNotEmpty && artist!.isNotEmpty) {
              BlocProvider.of<LyricsBloc>(context)
                  .add(DownloadLyricsManually(
                title: title!,
                artist: artist!,
                song: song,
                index: index
              ));
              Navigator.of(context).pop();
            }
          },
          child: Text("Search"),
        ),
        SizedBox(height: 10,)
      ],
    );
  }
}
