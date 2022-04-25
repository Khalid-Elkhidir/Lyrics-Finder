import 'dart:async';

import 'package:flutter/services.dart';
import 'package:http/http.dart' as http;
import 'package:html/parser.dart' as parser;
import 'package:new_project/core/errors/exceptions.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:uni_links/uni_links.dart';
import 'package:url_launcher/url_launcher.dart';
import 'dart:convert';

import '../../domain/entities/Lyrics.dart';
import '../../domain/entities/song.dart';
import '../models/song_model.dart';

abstract class RemoteDataSource {
  Future<Lyrics> getLyrics(String songName, String artistName);

  Future<bool> writeLyrics(Song song);

  Future<void> launchUrl();

  void initUniLinks(SharedPreferences sharedPreferences);

  StreamSubscription? getStreamSubscription();

  String? retrieveAccessToken();
}

class RemoteDataSourceImpl implements RemoteDataSource {
  final SharedPreferences sharedPreferences;
  static const String URL = "https://api.genius.com/oauth/authorize";
  static const String CLIENT_ID =
      "0YrTohsM1mCoETzJkPzbX_O9hRzlKzpCvmU83VhHCXotE6Yau9vrqxEufdr514ap";
  static const String REDIRECT_URI =
      "https://lyrics-finder-485f1.web.app/main/";
  static const String SCOPE = "me";
  static const String STATE = "true";
  static const String RESPONSE_TYPE = "token";
  StreamSubscription? sub;
  Lyrics? _lyrics;

  RemoteDataSourceImpl({required this.sharedPreferences});

  @override
  Future<Lyrics> getLyrics(String songName, String artistName) async {
    print(songName + " " + artistName);
    final accessToken = retrieveAccessToken();
    final http.Response serverResponse = await http.get(
        Uri.parse(
            "https://api.genius.com/search?q=${songName}%20${artistName}"),
        headers: {"Authorization": "Bearer ${accessToken!}"});
    if (serverResponse.statusCode == 200) {
      try {
        final page = json.decode(serverResponse.body);
        final response = page["response"];
        final hits = response["hits"];
        final song = hits[0];
        final result = song["result"];
        final link = result["url"];
        final lyrics = await fetchLyrics(link);
        _lyrics = Lyrics(text: lyrics);
        return _lyrics!;
      } on InvalidInfoException {
        throw InvalidInfoException();
      } on Exception {
        throw ServerException();
      }
    } else {
      throw ServerException();
    }
  }

  @override
  Future<bool> writeLyrics(covariant SongModel songModel) async {
    try {
      if (_lyrics != null) {
        songModel.writeLyrics(_lyrics!.text);
        _lyrics = null;
        return true;
      } else {
        throw NotFoundException();
      }
    } on Exception {
      throw ServerException();
    }
  }

  Future<String> fetchLyrics(String songLink) async {
    final http.Response serverResponse = await http.get(Uri.parse(songLink));

    if (serverResponse.statusCode == 200) {
      try {
        final document = parser.parse(serverResponse.body);
        String lyrics = "";
        for (var doc in document
            .getElementsByTagName("div.Lyrics__Container-sc-1ynbvzw-6")) {
          final element = doc.innerHtml.replaceAll("<br>", "\r\n<br>").trim();
          lyrics = "$lyrics \r\n${parser.parse(element).body!.text}";
        }
        // final element1 = document
        //     .getElementsByTagName("div.Lyrics__Container-sc-1ynbvzw-6")[0]
        //     .innerHtml
        //     .replaceAll("<br>", "\r\n<br>")
        //     .trim();
        // final e1 = parser.parse(element1).body!.text;
        // final element2 = document
        //     .getElementsByTagName("div.Lyrics__Container-sc-1ynbvzw-6")[1]
        //     .innerHtml
        //     .replaceAll("<br>", "\r\n<br>")
        //     .trim();
        // final e2 = parser.parse(element2).body!.text;
        // return "$e1\r\n$e2";
        return lyrics.trimLeft();
      } on Exception {
        throw ServerException();
      } on RangeError {
        print("1");
        throw InvalidInfoException();
      }
    } else {
      throw ServerException();
    }
  }

  @override
  String? retrieveAccessToken() {
    try {
      return sharedPreferences.getString("access_token");
    } on Exception {
      throw SignUpException();
    }
  }

  @override
  Future<void> launchUrl() async {
    try {
      await launch(
        Uri(
          scheme: "https",
          host: "api.genius.com",
          path: "/oauth/authorize",
          queryParameters: {
            "client_id": CLIENT_ID,
            "redirect_uri": REDIRECT_URI,
            "scope": SCOPE,
            "state": STATE,
            "response_type": RESPONSE_TYPE,
          },
        ).toString(),
      );
    } on Exception catch (e) {
      throw ServerException();
    }
  }

  @override
  void initUniLinks(SharedPreferences sharedPreferences) async {
    final regEx = RegExp(r'\b(?!access_token)(?!=).+(?=&state)');
    try {
      sub = uriLinkStream.listen((Uri? uri) {
        print("From Stream : ${regEx.stringMatch(uri!.fragment)}");
        sharedPreferences.setString(
            "access_token", regEx.stringMatch(uri.fragment)!);
      }, onError: (err) {
        print(err);
      });
    } on PlatformException {
      throw Exception();
    } on Exception {
      throw Exception();
    }
  }

  @override
  StreamSubscription? getStreamSubscription() {
    return sub;
  }

  late http.StreamedResponse response;

  Future<String> x(String songLink) async {
    String serverResponse = "";
    int total = 0;
    int received = 0;
    List<int> bytes = [];
    response =
        await http.Client().send(http.Request("GET", Uri.parse(songLink)));
    total = response.contentLength ?? 0;
    print(response.contentLength);

    // response.stream.listen((newBytes) {
    //   received += newBytes.length;
    // }).onDone(() {print("DONE");});
    await for (final i in response.stream) {
      bytes += i;
      received += i.length;
      print(received);
      getDownloadProgress(received, total);
    }
    print("DONE2");
    serverResponse = utf8.decode(bytes);
    return serverResponse;
  }

  Stream<double> getDownloadProgress(int bytes, int total) async* {
    var percentage = bytes / total * 100;
    print(percentage);
    yield percentage;
  }
}
