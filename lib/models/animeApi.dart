import 'dart:convert';
import 'package:http/http.dart';

import 'package:http/http.dart' as http;

import 'anime.dart';
import 'animeDetails.dart';

class AnimeApi {
  // static String base_url = "https://toasty-kun.vercel.app/";
  static String base_url = "https://toasty-kun.vercel.app/";

  setApi() async {
    const giturl =
        "https://raw.githubusercontent.com/Toasty360/env/main/baseURLs.json";
    var response = await http.get(Uri.parse(giturl));
    var data = jsonDecode(response.body);
    // print(data);
    base_url = data["api"];
    // print(base_url);
  }

  changeApiurl(String newUrl) {
    base_url = newUrl;
    // print("url changed");
  }

  static Future<List<Anime>> getanimeList(String value, var page) async {
    var url = "${base_url}/anime/gogoanime/$value?page=$page";
    print(url);
    final response = await http.get(Uri.parse(url));
    var data = jsonDecode(response.body);
    return Anime.animeListFromSnapShot(data["results"]);
  }

  static Future<AnimeDetails> getAnime(String value) async {
    final response =
        await http.get(Uri.parse('${base_url}/anime/gogoanime/info/$value'));
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
    var url = "${base_url}/anime/gogoanime/recent-episodes?page=${page}";
    final response = await get(Uri.parse(url));
    var data = jsonDecode(response.body);
    print(data.length);
    return RecentEps.fetchAllRecentEps(data["results"]);
  }

  static Future<List<EpisodeUrl>> getEpisodeUrls(episodeId) async {
    print(episodeId);
    final response =
        await get(Uri.parse("${base_url}/anime/gogoanime/watch/$episodeId"));
    var data = jsonDecode(response.body);
    List<EpisodeUrl> links = [];
    for (var urldata in data["sources"]) {
      links.add(EpisodeUrl.fromJson(urldata));
    }
    return links;
  }

  static Future<List<TopAnimeModel>> getTopAiring() async {
    if (base_url == "") {
      AnimeApi().setApi();
    }
    print(AnimeApi.base_url);
    final response =
        await get(Uri.parse("${base_url}/anime/gogoanime/top-airing"));
    var data = jsonDecode(response.body);
    List<TopAnimeModel> TopAnime = [];
    for (var anime in data["results"]) {
      TopAnime.add(TopAnimeModel(
          anime["id"], anime["title"], anime["image"], anime["genres"].toString()));
    }
    return TopAnime;
  }

//   static Future<List<ScheduleData>> getSchedule() async{

//   var query ="query (\n\tweekStart: Int,\n\tweekEnd: Int,\n\tpage: Int,\n){\n\tPage(page: page) {\n\t\tpageInfo {\n\t\t\thasNextPage\n\t\t\ttotal\n\t\t}\n\t\tairingSchedules(\n\t\t\tairingAt_greater: weekStart\n\t\t\tairingAt_lesser: weekEnd\n\t\t) {\n\t\t\tid\n\t\t\tepisode\n\t\t\tairingAt\n\t\t\tmedia {\n\t\t\t\t\nid\nidMal\ntitle {\n\tromaji\n\tnative\n\tenglish\n}\nstartDate {\n\tyear\n\tmonth\n\tday\n}\nendDate {\n\tyear\n\tmonth\n\tday\n}\nstatus\nseason\nformat\ngenres\nsynonyms\nduration\npopularity\nepisodes\nsource(version: 2)\ncountryOfOrigin\nhashtag\naverageScore\nsiteUrl\ndescription\nbannerImage\nisAdult\ncoverImage {\n\textraLarge\n\tcolor\n}\ntrailer {\n\tid\n\tsite\n\tthumbnail\n}\nexternalLinks {\n\tsite\n\turl\n}\nrankings {\n\trank\n\ttype\n\tseason\n\tallTime\n}\nstudios(isMain: true) {\n\tnodes {\n\t\tid\n\t\tname\n\t\tsiteUrl\n\t}\n}\nrelations {\n\tedges {\n\t\trelationType(version: 2)\n\t\tnode {\n\t\t\tid\n\t\t\ttitle {\n\t\t\t\tromaji\n\t\t\t\tnative\n\t\t\t\tenglish\n\t\t\t}\n\t\t\tsiteUrl\n\t\t}\n\t}\n}\n\n\n\t\t\t}\n\t\t}\n\t}\n}";
//   var variables = {
//     "weekStart": 1686162600,
//     "weekEnd": 1686767400,
//     "page": 1,
//   };

//   get(url,)

//   var url = "https://graphql.anilist.co",
//   var options = {
//       "method": "POST",
//       "headers": {
//         "Content-Type": "application/json",
//         "Accept": "application/json",
//       },
//       "body": JSON.stringify({
//         query: query,
//         variables: variables,
//       }),
//     };

//   fetch(url, options)
//     .then(async (response) => {
//       const json = await response.json();
//       return response.ok ? json : Promise.reject(json);
//     })
//     .then((data) => {
//       console.log(data["data"]["Page"]["airingSchedules"][6]["media"]);
//     });
// };
}
