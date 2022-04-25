import 'package:flutter/material.dart';

import '../../data/models/artist_model.dart';
import 'albums_list.dart';

class ArtistsList extends StatelessWidget {
  final List<ArtistModel> artists;

  const ArtistsList({Key? key, required this.artists}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemCount: artists.length,
      itemBuilder: (_, index) => ListTile(
        title: Text(artists[index].artistName.isNotEmpty
            ? artists[index].artistName
            : "Unknown"),
        leading: Container(
          clipBehavior: Clip.hardEdge,
          decoration: BoxDecoration(
            border: Border.all(width: 2, color: Colors.black45),
            color: Colors.black45,
            shape: BoxShape.circle,
          ),
          child: CircleAvatar(
            radius: 20,
            backgroundColor: Colors.grey,
            child: ClipOval(
              child: artists[index].artistAlbums[0].albumSongs[0].artwork !=
                      null
                  ? Image.memory(
                      artists[index].artistAlbums[0].albumSongs[0].artwork!,
                      fit: BoxFit.cover,
                      height: 40,
                    )
                  : Icon(
                      Icons.person,
                      color: Colors.grey[700],
                      size: 20,
                    ),
            ),
          ),
        ),
        onTap: () => Navigator.of(context).push(
          MaterialPageRoute(
            builder: (_) => Scaffold(
              appBar: AppBar(
                title: Text(artists[index].artistName.isNotEmpty
                    ? artists[index].artistName
                    : "Unknown"),
              ),
              body: AlbumsList(albums: artists[index].artistAlbums),
            ),
          ),
        ),
      ),
    );
  }
}
