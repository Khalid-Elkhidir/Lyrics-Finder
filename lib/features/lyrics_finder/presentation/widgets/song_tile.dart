import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:new_project/features/lyrics_finder/presentation/pages/lyrics_page.dart';

import '../../data/models/song_model.dart';
import '../bloc/lyrics_bloc/lyrics_bloc.dart';
import 'download_button.dart';

class SongTile extends StatefulWidget {
  final SongModel song;
  final int index;

  SongTile({Key? key,required this.song, required this.index}) : super(key: key);

  @override
  State<SongTile> createState() => _SongTileState();
}

class _SongTileState extends State<SongTile> {
  @override
  Widget build(BuildContext context) {
    final lyricsBloc = BlocProvider.of<LyricsBloc>(context);

    return Column(
      children: [
        ListTile(
          leading: Container(
            clipBehavior: Clip.hardEdge,
            decoration: BoxDecoration(
              border: Border.all(width: 2,color: Colors.black45),
                color: Colors.black45,
                shape: BoxShape.circle,
            ),
            child: CircleAvatar(
              backgroundColor: Colors.grey,
              child: ClipOval(
                child: widget.song.artwork != null
                    ? Image.memory(
                        widget.song.artwork!,
                        fit: BoxFit.cover,
                        height: 60,
                      )
                    : Container(
                        child: Icon(
                          Icons.music_note,
                          color: Colors.grey[700],
                          size: 30,
                        ),
                      ),
              ),
              radius: 30,
            ),
          ),
          title: Text(widget.song.songName ?? "No title"),
          subtitle: Text(widget.song.artistName ?? "Unknown"),
          trailing: DownloadButton(
            onPressed: () {
              lyricsBloc.add(DownloadLyrics(song: widget.song, index: widget.index));
            },
            index: widget.index,
          ),
          onTap: () {
            Navigator.of(context).push(MaterialPageRoute(
                builder: (_) => LyricsPage(
                      song: widget.song,
                    )));
          },
          onLongPress: () {
            lyricsBloc.add(
              SearchingManually(song: widget.song, index: widget.index),
            );
          },
        ),
        const Divider(
          thickness: 1,
          indent: 95,
          endIndent: 20,
        )
      ],
    );
  }
}
