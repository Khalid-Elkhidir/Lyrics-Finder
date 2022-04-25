import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:new_project/features/lyrics_finder/presentation/pages/songs_page.dart';

import '../bloc/album_cubit/album_cubit.dart';
import '../bloc/artists_cubit/artists_cubit.dart';
import '../widgets/search_bar.dart';
import 'albums_page.dart';
import 'artists_page.dart';

class MainPage extends StatefulWidget {
  const MainPage({Key? key}) : super(key: key);

  @override
  State<MainPage> createState() => _MainPageState();
}

class _MainPageState extends State<MainPage> {
  @override
  initState() {
    super.initState();
    BlocProvider.of<AlbumCubit>(context).loadingAlbums();
    BlocProvider.of<ArtistsCubit>(context).loadingArtists();
  }

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 3,
      child: Scaffold(
        appBar: AppBar(
          title: const Text("Lyrics Finder"),
          actions: [
            SearchBar(),
          ],
          bottom: const TabBar(
            tabs: [
              Tab(
                text: "Songs",
                icon: Icon(Icons.music_note),
              ),
              Tab(
                text: "Albums",
                icon: Icon(Icons.disc_full),
              ),
              Tab(
                text: "Artists",
                icon: Icon(Icons.person),
              ),
            ],
          ),
        ),
        body: const TabBarView(
          children: [
            SongsPage(),
            AlbumsPage(),
            ArtistsPage(),
          ],
        ),
      ),
    );
  }
}
