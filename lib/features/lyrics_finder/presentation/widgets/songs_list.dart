import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:new_project/features/lyrics_finder/data/models/song_model.dart';
import 'package:new_project/features/lyrics_finder/presentation/widgets/song_tile.dart';

import '../bloc/lyrics_bloc/lyrics_bloc.dart';
import 'manual_search_dialog.dart';

class SongsList extends StatelessWidget {
  SongsList({required this.songs});

  final List<SongModel> songs;

  @override
  Widget build(BuildContext context) {
    final lyricsBloc = BlocProvider.of<LyricsBloc>(context);

    return BlocListener(
      bloc: lyricsBloc,
      listener: (context, state) {
        if (state is ManualSearch) {
          showDialog(
            context: context,
            builder: (_) => ManualSearchDialog(
              song: state.song,
              index: state.index,
            ),
          ).then((value) => lyricsBloc.add(EscapeSearchDialog()));
        } else if (state is NoInternetConnection) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Padding(
                padding: const EdgeInsets.only(left: 8, right: 8),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(state.message),
                    Icon(
                      Icons.signal_wifi_connected_no_internet_4,
                      color: Colors.white,
                    ),
                  ],
                ),
              ),
              duration: Duration(seconds: 4),
            ),
          );
          lyricsBloc.add(EscapeSnackBar());
        }
      },
      child: Container(
        height: 600,
        child: ListView.builder(
          itemCount: songs.length,
          itemBuilder: (context, index) {
            return SongTile(
              song: songs[index],
              index: index,
            );
          },
        ),
      ),
    );
  }
}
