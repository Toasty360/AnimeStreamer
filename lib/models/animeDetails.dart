import 'dart:convert';

class AnimeDetails {
  final String id;
  final String title;
  final String url;
  final List genres;
  final String totalEpisodes;
  final String animeImg;
  final String releaseDate;
  final String synopsis;
  final String subOrDub;
  final String type;
  final String status;
  final String otherNames;
  final List<EpisodeDetails> episodesList;
  AnimeDetails(
      {required this.id,
      required this.title,
      required this.url,
      required this.genres,
      required this.totalEpisodes,
      required this.animeImg,
      required this.releaseDate,
      required this.synopsis,
      required this.subOrDub,
      required this.type,
      required this.status,
      required this.otherNames,
      required this.episodesList});

  factory AnimeDetails.fromJson(json) {
    return AnimeDetails(
        id: json["id"],
        title: json['title'],
        type: json["type"],
        releaseDate: json["releaseDate"],
        status: json["status"],
        genres: json["genres"],
        otherNames: json["otherName"],
        synopsis: json["description"],
        animeImg: json["image"],
        totalEpisodes: json["totalEpisodes"].toString(),
        episodesList: EpisodeDetails.normalize(json['episodes']),
        subOrDub: json["subOrDub"],
        url: json["url"]);
  }

  // static AnimeDetails dummydata() {
  //   // return AnimeDetails.fromJson({
  //   //   "animeTitle": "",
  //   //   "type": "",
  //   //   "releaseDate": "",
  //   //   "status": "",
  //   //   "genres": "",
  //   //   "otherNames": "",
  //   //   "synopsis": "",
  //   //   "animeImg": "",
  //   //   "totalEpisodes": "",
  //   //   "episodesList": [
  //   //     {"episodeId": "", "episodeNum": "", "episodeUrl": ""}
  //   //   ],
  //   // });
  //   return AnimeDetails.fromJson({
  //     "animeTitle": "Temp_anime",
  //     "type": "Summer 2022 Anime",
  //     "releasedDate": "2022",
  //     "status": "Completed",
  //     "genres": ["Action", "Fantasy", "Game", "Magic", "Supernatural"],
  //     "otherNames": "オーバーロード IV",
  //     "synopsis": "Fourth season of Overlord.",
  //     "animeImg": "https://gogocdn.net/cover/overlord-iv.png",
  //     "totalEpisodes": "13",
  //     "episodesList": [
  //       {
  //         "episodeId": "overlord-iv-episode-13",
  //         "episodeNum": "13",
  //         "episodeUrl": "https://gogoanime.film//overlord-iv-episode-13"
  //       },
  //       {
  //         "episodeId": "overlord-iv-episode-12",
  //         "episodeNum": "12",
  //         "episodeUrl": "https://gogoanime.film//overlord-iv-episode-12"
  //       },
  //       {
  //         "episodeId": "overlord-iv-episode-11",
  //         "episodeNum": "11",
  //         "episodeUrl": "https://gogoanime.film//overlord-iv-episode-11"
  //       },
  //       {
  //         "episodeId": "overlord-iv-episode-10",
  //         "episodeNum": "10",
  //         "episodeUrl": "https://gogoanime.film//overlord-iv-episode-10"
  //       },
  //       {
  //         "episodeId": "overlord-iv-episode-9",
  //         "episodeNum": "9",
  //         "episodeUrl": "https://gogoanime.film//overlord-iv-episode-9"
  //       },
  //       {
  //         "episodeId": "overlord-iv-episode-8",
  //         "episodeNum": "8",
  //         "episodeUrl": "https://gogoanime.film//overlord-iv-episode-8"
  //       },
  //       {
  //         "episodeId": "overlord-iv-episode-7",
  //         "episodeNum": "7",
  //         "episodeUrl": "https://gogoanime.film//overlord-iv-episode-7"
  //       },
  //       {
  //         "episodeId": "overlord-iv-episode-6",
  //         "episodeNum": "6",
  //         "episodeUrl": "https://gogoanime.film//overlord-iv-episode-6"
  //       },
  //       {
  //         "episodeId": "overlord-iv-episode-5",
  //         "episodeNum": "5",
  //         "episodeUrl": "https://gogoanime.film//overlord-iv-episode-5"
  //       },
  //       {
  //         "episodeId": "overlord-iv-episode-4",
  //         "episodeNum": "4",
  //         "episodeUrl": "https://gogoanime.film//overlord-iv-episode-4"
  //       },
  //       {
  //         "episodeId": "overlord-iv-episode-3",
  //         "episodeNum": "3",
  //         "episodeUrl": "https://gogoanime.film//overlord-iv-episode-3"
  //       },
  //       {
  //         "episodeId": "overlord-iv-episode-2",
  //         "episodeNum": "2",
  //         "episodeUrl": "https://gogoanime.film//overlord-iv-episode-2"
  //       },
  //       {
  //         "episodeId": "overlord-iv-episode-1",
  //         "episodeNum": "1",
  //         "episodeUrl": "https://gogoanime.film//overlord-iv-episode-1"
  //       }
  //     ]
  //   });
  // }

  static Map<String, dynamic> toJson(AnimeDetails data) {
    return {
      "animeTitle": data.title,
      "type": data.type,
      "releaseDate": data.releaseDate,
      "status": data.status,
      "genres": data.genres,
      "otherNames": data.otherNames,
      "synopsis": data.synopsis,
      "animeImg": data.animeImg,
      "totalEpisodes": data.totalEpisodes,
      "episodesList": EpisodeDetails.toJsonList(data.episodesList)
    };
  }

  @override
  String toString() {
    return "animeTitle:$title,type:$type,releaseDate:$releaseDate,status:$status,genres:$genres,otherNames:$otherNames,synopsis,animeImg$animeImg,totalEpisodes:$totalEpisodes,episodesList";
  }
}

class EpisodeDetails {
  final String episodeId;
  final String episodeNum;
  final String episodeUrl;
  EpisodeDetails(
      {required this.episodeId,
      required this.episodeNum,
      required this.episodeUrl});

  static List<EpisodeDetails> normalize(List json) {
    // ignore: unnecessary_cast
    return json.map((e) {
      return EpisodeDetails.fromJson(e);
    }).toList() as List<EpisodeDetails>;
  }

  factory EpisodeDetails.fromJson(json) {
    return EpisodeDetails(
        episodeId: json['id'],
        episodeNum: json['number'].toString(),
        episodeUrl: json['url']);
  }

  static List<Map<String, dynamic>> toJsonList(List<EpisodeDetails>? data) {
    return data!.map((e) {
      return {
        "episodeId": e.episodeId,
        "episodeNum": e.episodeNum,
        "episodeUrl": e.episodeUrl,
      };
    }).toList();
  }
}

class Vidcdn {
  final String? referer;
  final AnimeStream? sources;
  final AnimeStream? sourcesBK;

  Vidcdn({this.referer, this.sources, this.sourcesBK});

  factory Vidcdn.fromJson(json) {
    return Vidcdn(
      referer: json["Referer"],
      sources: AnimeStream.fromJson(json["sources"][0]),
      sourcesBK: AnimeStream.fromJson(json["sources_bk"][0]),
    );
  }
  @override
  String toString() {
    // TODO: implement toString
    return "{refere: $referer, source:${sources!.file}, sourceBk:${sourcesBK!.file}}";
  }
}

class AnimeStream {
  final String? file;
  final String? label;
  final String? type;

  AnimeStream({this.file, this.label, this.type});

  factory AnimeStream.fromJson(json) {
    return AnimeStream(
        file: json['file'], label: json['label'], type: json['type']);
  }
}

class RecentEps {
  final String id;
  final String episodeId;
  final String episodeNumber;
  final String title;
  final String image;
  final String url;

  RecentEps(
      {required this.id,
      required this.episodeId,
      required this.title,
      required this.episodeNumber,
      required this.image,
      required this.url});

  static List<RecentEps> fetchAllRecentEps(List json) {
    return json.map((e) => RecentEps.toRecentEps(e)).toList();
  }

  factory RecentEps.toRecentEps(data) {
    return RecentEps(
        id: data["id"],
        episodeId: data["episodeId"],
        title: data["title"],
        episodeNumber: data["episodeNumber"].toString(),
        image: data["image"],
        url: data["url"]);
  }
}

class EpisodeUrl {
  final url;
  final isM3U8;
  final quality;
  EpisodeUrl({this.url, this.isM3U8, this.quality});

  factory EpisodeUrl.fromJson(json) {
    return EpisodeUrl(
        url: json['url'], isM3U8: json["isM3U8"], quality: json["quality"]);
  }
}
