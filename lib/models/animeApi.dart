import 'dart:convert';
import 'package:get/get.dart';
import 'package:http/http.dart';

import 'package:http/http.dart' as http;

import 'anime.dart';
import 'animeDetails.dart';
import 'animeDetails_get.dart';

class AnimeApi {
  // static String base_url = "https://consumet-api-fit7.onrender.com/";
  static String base_url = "https://toasty-kun.vercel.app/";

  changeApiurl(String newUrl) {
    base_url = newUrl;
    print("url changed");
  }

  static changeApi() {
    ApiGetter apigetter = Get.find();
    base_url = apigetter.x;
    print("after change: ${base_url}");
  }

  static Future<List<Anime>> getanimeList(String value, var page) async {
     var url="${base_url}anime/gogoanime/$value?page=$page";
     print(url);
    final response = await http
        .get(Uri.parse(url));
    var data = jsonDecode(response.body);
    return Anime.animeListFromSnapShot(data["results"]);
  }

  static Future<AnimeDetails> getAnime(String value) async {
    final response =
        await http.get(Uri.parse('${base_url}anime/gogoanime/info/$value'));
    var data = jsonDecode(response.body);
    return AnimeDetails.fromJson(data);
  }

  // static Future<List<Anime>> getRecentPopular() async {
  //   var uri = Uri.https(base_url, '/popular', {"page": "2"});
  //   final response = await http.get(uri);
  //   List data = jsonDecode(response.body);
  //   return Anime.popularAnime(data);
  // }

  static Future<List<RecentEps>> getRecentEps(String page) async {
    print("called the recent eps");
    var url = "${base_url}anime/gogoanime/recent-episodes?page=${page}";
    final response = await get(Uri.parse(url));
    var data = jsonDecode(response.body);
    print(data.length);
    return RecentEps.fetchAllRecentEps(data["results"]);
  }

  static Future<List<EpisodeUrl>> getEpisodeUrls(episodeId) async {
    print(episodeId);
    final response =
        await get(Uri.parse("${base_url}anime/gogoanime/watch/$episodeId"));
    var data = jsonDecode(response.body);
    List<EpisodeUrl> links = [];
    for (var urldata in data["sources"]) {
      links.add(EpisodeUrl.fromJson(urldata));
    }
    return links;
  }

  static Future<List<TopAnimeModel>> getTopAiring() async {
    final response =
        await get(Uri.parse("${base_url}anime/gogoanime/top-airing"));
    var data = jsonDecode(response.body);
    List<TopAnimeModel> TopAnime = [];
    for (var anime in data["results"]) {
      TopAnime.add(TopAnimeModel(anime["id"], anime["title"], anime["image"]));
    }
    return TopAnime;
  }
}
