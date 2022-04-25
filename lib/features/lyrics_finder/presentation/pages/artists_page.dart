import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:new_project/features/lyrics_finder/presentation/bloc/artists_cubit/artists_cubit.dart';
import 'package:new_project/features/lyrics_finder/presentation/pages/error_screen.dart';
import 'package:new_project/features/lyrics_finder/presentation/widgets/artists_list.dart';

class ArtistsPage extends StatefulWidget {
  const ArtistsPage({Key? key}) : super(key: key);

  @override
  State<ArtistsPage> createState() => _ArtistsPageState();
}

class _ArtistsPageState extends State<ArtistsPage> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ArtistsCubit, ArtistsState>(builder: (context, state) {
      if (state is ArtistsLoaded) {
        final artists = state.artists;
        return ArtistsList(artists: artists);
      } else {
        return const ErrorScreen();
      }
    });
  }
}
