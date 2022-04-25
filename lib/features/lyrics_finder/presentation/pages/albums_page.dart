import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:new_project/features/lyrics_finder/presentation/bloc/album_cubit/album_cubit.dart';
import 'package:new_project/features/lyrics_finder/presentation/widgets/albums_list.dart';

import 'error_screen.dart';

class AlbumsPage extends StatefulWidget {
  const AlbumsPage({Key? key}) : super(key: key);

  @override
  State<AlbumsPage> createState() => _AlbumsPageState();
}

class _AlbumsPageState extends State<AlbumsPage> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<AlbumCubit, AlbumState>(builder: (context, state) {
      if (state is AlbumLoaded) {
        final albums = state.albums;
        return AlbumsList(albums: albums);
      } else {
        return const ErrorScreen();
      }
    });
  }
}
