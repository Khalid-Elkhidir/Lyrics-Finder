import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:new_project/features/lyrics_finder/presentation/bloc/song_bloc/song_bloc.dart';
import 'package:new_project/features/lyrics_finder/presentation/widgets/songs_list.dart';

class SongsPage extends StatefulWidget {
  const SongsPage({Key? key}) : super(key: key);

  @override
  State<SongsPage> createState() => _SongsPageState();
}

class _SongsPageState extends State<SongsPage> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: BlocConsumer(
          bloc: BlocProvider.of<SongBloc>(context),
          listener: (context, state) {},
          builder: (context, state) {
            if (state is Empty) {
              print("Empty");
              return Container(
                child: Center(
                  child: Text(state.message),
                ),
              );
            } else if (state is Loading) {
              return Container(
                child: Center(
                  child: CircularProgressIndicator(),
                ),
              );
            } else if (state is Loaded) {
             return SongsList(songs: state.songs);
            } else if (state is Error) {
              print("Error");
              return Container(
                child: Center(
                  child: Text(state.message),
                ),
              );
            } else {
              print("Unknown Error");
              return Container(
                child: Center(
                  child: Text("Unkown Error"),
                ),
              );
            }
          },
      ),
    );
  }
}
