import 'dart:convert';
import '/views/recentEpisode.dart';
import 'package:http/http.dart' as http;

import 'anime.dart';
import 'animeDetails.dart';
import 'recentAnimeEps.dart';

class AnimeApi {
  static Future<List<Anime>> getanimeList(String value) async {
    var uri = Uri.https('gogoanime2.p.rapidapi.com', '/search',
        {"keyw": "$value", "page": "1"});
    final response = await http.get(uri, headers: {
      "X-RapidAPI-Key": "e7fbfceb36msh4e9caad8741b57bp10aa65jsn323961135317",
      "X-RapidAPI-Host": "gogoanime2.p.rapidapi.com",
      "useQueryString": "true"
    });
    List data = jsonDecode(response.body);
    return Anime.animeListFromSnapShot(data);
  }

  static Future<AnimeDetails> getAnime(String value) async {
    var uri =
        Uri.parse('https://gogoanime2.p.rapidapi.com/anime-details/$value');
    final response = await http.get(uri, headers: {
      "X-RapidAPI-Key": "e7fbfceb36msh4e9caad8741b57bp10aa65jsn323961135317",
      "X-RapidAPI-Host": "gogoanime2.p.rapidapi.com",
      "useQueryString": "true"
    });
    if (response.statusCode == 200) {
      Map<String, dynamic> jsonresponce = jsonDecode(response.body);

      return AnimeDetails.fromJson(jsonresponce);
    }
    else {
      throw "Unable to retrieve posts.";
    }
  }
  static Future<List<Anime>> getRecentPopular() async {
    var uri = Uri.https('gogoanime2.p.rapidapi.com', '/popular',
        {"page": "2"});
    final response = await http.get(uri, headers: {
      "X-RapidAPI-Key": "e7fbfceb36msh4e9caad8741b57bp10aa65jsn323961135317",
      "X-RapidAPI-Host": "gogoanime2.p.rapidapi.com",
      "useQueryString": "true"
    });
    List data = jsonDecode(response.body);
    return Anime.popularAnime(data);
  }

  static Future<AnimeStream> getAnimeStreamURL(String animeId) async {
    var uri = Uri.https('gogoanime2.p.rapidapi.com', '/vidcdn/watch/$animeId',
        {});
    final response = await http.get(uri, headers: {
      "X-RapidAPI-Key": "e7fbfceb36msh4e9caad8741b57bp10aa65jsn323961135317",
      "X-RapidAPI-Host": "gogoanime2.p.rapidapi.com",
      "useQueryString": "true"
    });
    var data = jsonDecode(response.body);
    data=data['sources'][0];
    return AnimeStream.fromJson(data);
  }

  static Future<List<RecentEps>> getRecentEps(String page) async {
    var uri = Uri.https('gogoanime2.p.rapidapi.com', 'recent-release',
        {"type": '1', "page": page});
    final response = await http.get(uri, headers: {
      "X-RapidAPI-Key": "e7fbfceb36msh4e9caad8741b57bp10aa65jsn323961135317",
      "X-RapidAPI-Host": "gogoanime2.p.rapidapi.com",
      "useQueryString": "true"
    });
    var data = jsonDecode(response.body);
    return RecentEps.fetchAllRecentEps(data);
  }

}
