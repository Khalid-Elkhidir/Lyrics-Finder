import 'package:flutter/material.dart';
import 'package:new_project/features/lyrics_finder/data/models/album_model.dart';
import 'package:new_project/features/lyrics_finder/presentation/widgets/songs_list.dart';

class AlbumsList extends StatelessWidget {
  const AlbumsList({Key? key, required this.albums}) : super(key: key);

  final List<AlbumModel> albums;

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemCount: albums.length,
      itemBuilder: (_, index) => ListTile(
        title: Text(albums[index].albumTitle),
        subtitle: Text(albums[index].artistName),
        leading: Container(
          padding: const EdgeInsets.all(2),
          decoration: BoxDecoration(
              color: Colors.black45, borderRadius: BorderRadius.circular(40)),
          child: CircleAvatar(
            backgroundColor: Colors.grey,
            child: ClipOval(
              child: albums[index].albumSongs[0].artwork != null
                  ? Image.memory(
                      albums[index].albumSongs[0].artwork!,
                      fit: BoxFit.cover,
                      height: 40,
                      width: 40,
                    )
                  : Icon(
                    Icons.disc_full,
                    color: Colors.grey[700],
                    size: 20,
                  ),
            ),
            radius: 20,
          ),
        ),
        onTap: () => Navigator.of(context).push(MaterialPageRoute(
            builder: (context) => Scaffold(
                appBar: AppBar(
                  title: Text(albums[index].albumTitle),
                ),
                body: SongsList(songs: albums[index].albumSongs)))),
      ),
    );
  }
}
