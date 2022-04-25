import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:new_project/features/lyrics_finder/presentation/bloc/album_cubit/album_cubit.dart';
import 'package:new_project/features/lyrics_finder/presentation/bloc/artists_cubit/artists_cubit.dart';
import 'package:new_project/features/lyrics_finder/presentation/bloc/song_bloc/song_bloc.dart';

class SearchBar extends StatefulWidget {
  String? query;

  SearchBar({Key? key}) : super(key: key);

  @override
  _SearchBarState createState() => _SearchBarState();
}

class _SearchBarState extends State<SearchBar> {
  late final SongBloc songBloc;
  late final AlbumCubit albumCubit;
  late final ArtistsCubit artistsCubit;
  bool expanded = false;
  TextEditingController controller = TextEditingController();

  @override
  initState() {
    super.initState();
    songBloc = BlocProvider.of<SongBloc>(context);
    albumCubit = BlocProvider.of<AlbumCubit>(context);
    artistsCubit = BlocProvider.of<ArtistsCubit>(context);
  }

  @override
  Widget build(BuildContext context) {
    filteringFiles();

    return AnimatedContainer(
      padding: const EdgeInsets.all(10),
      duration: const Duration(milliseconds: 200),
      width: expanded ? MediaQuery.of(context).size.width : 80,
      child: Container(
        decoration: BoxDecoration(
            border: expanded ? Border.all(width: 1, color: Colors.white) : null,
            borderRadius: BorderRadius.circular(30)),
        child: Row(
          children: [
            IconButton(
              onPressed: () {
                setState(() {
                  if (expanded) {
                    widget.query = "";
                    controller.text = "";
                  }
                  expanded = !expanded;
                });
              },
              icon:
                  expanded ? const Icon(Icons.close) : const Icon(Icons.search),
            ),
            Expanded(
              child: Container(
                child: expanded
                    ? TextField(
                        controller: controller,
                        autofocus: true,
                        decoration: const InputDecoration(
                          focusColor: Colors.white,
                          border: InputBorder.none,
                          hintText: "Search...",
                          contentPadding: EdgeInsets.all(10),
                        ),
                        style: const TextStyle(
                          color: Colors.white,
                        ),
                        cursorColor: Colors.white,
                        onChanged: (value) {
                          setState(() {
                            widget.query = value;
                          });
                        },
                        onSubmitted: (_) {
                          setState(() => expanded = false);
                        },
                      )
                    : null,
              ),
            ),
          ],
        ),
      ),
    );
  }

  void filteringFiles() {
    songBloc.add(FilterSongs(query: widget.query ?? ""));
    if (widget.query != null) {
      albumCubit.filteringAlbums(widget.query!);
      artistsCubit.filteringArtists(widget.query!);
    }
  }
}
