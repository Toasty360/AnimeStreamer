class AnimeDetails {
  late String? animeTitle;
  late String? type;
  late String? releaseDate;
  late String? status;
  late List<dynamic>? genres;
  late String? otherNames;
  late String? synopsis;
  late String? animeImg;
  late String? totalEpisodes;
  late List<EpisodeDetails> episodesList;

  AnimeDetails(
      {this.animeTitle,
      this.type,
      this.releaseDate,
      this.status,
      this.genres,
      this.otherNames,
      this.synopsis,
      this.animeImg,
      this.totalEpisodes,
      required this.episodesList});
  factory AnimeDetails.fromJson(dynamic json) {
    return AnimeDetails(
        animeTitle: json['animeTitle'],
        type: json["type"],
        releaseDate: json["releaseDate"],
        status: json["status"],
        genres: json["genres"],
        otherNames: json["otherNames"],
        synopsis: json["synopsis"],
        animeImg: json["animeImg"],
        totalEpisodes: json["totalEpisodes"],
        episodesList: EpisodeDetails.normalize(json['episodesList']));
  }

  static AnimeDetails dummydata() {
    return AnimeDetails.fromJson({
      "animeTitle": "Overlord IV",
      "type": "Summer 2022 Anime",
      "releasedDate": "2022",
      "status": "Completed",
      "genres": ["Action", "Fantasy", "Game", "Magic", "Supernatural"],
      "otherNames": "オーバーロード IV",
      "synopsis": "Fourth season of Overlord.",
      "animeImg": "https://gogocdn.net/cover/overlord-iv.png",
      "totalEpisodes": "13",
      "episodesList": [
        {
          "episodeId": "overlord-iv-episode-13",
          "episodeNum": "13",
          "episodeUrl": "https://gogoanime.film//overlord-iv-episode-13"
        },
        {
          "episodeId": "overlord-iv-episode-12",
          "episodeNum": "12",
          "episodeUrl": "https://gogoanime.film//overlord-iv-episode-12"
        },
        {
          "episodeId": "overlord-iv-episode-11",
          "episodeNum": "11",
          "episodeUrl": "https://gogoanime.film//overlord-iv-episode-11"
        },
        {
          "episodeId": "overlord-iv-episode-10",
          "episodeNum": "10",
          "episodeUrl": "https://gogoanime.film//overlord-iv-episode-10"
        },
        {
          "episodeId": "overlord-iv-episode-9",
          "episodeNum": "9",
          "episodeUrl": "https://gogoanime.film//overlord-iv-episode-9"
        },
        {
          "episodeId": "overlord-iv-episode-8",
          "episodeNum": "8",
          "episodeUrl": "https://gogoanime.film//overlord-iv-episode-8"
        },
        {
          "episodeId": "overlord-iv-episode-7",
          "episodeNum": "7",
          "episodeUrl": "https://gogoanime.film//overlord-iv-episode-7"
        },
        {
          "episodeId": "overlord-iv-episode-6",
          "episodeNum": "6",
          "episodeUrl": "https://gogoanime.film//overlord-iv-episode-6"
        },
        {
          "episodeId": "overlord-iv-episode-5",
          "episodeNum": "5",
          "episodeUrl": "https://gogoanime.film//overlord-iv-episode-5"
        },
        {
          "episodeId": "overlord-iv-episode-4",
          "episodeNum": "4",
          "episodeUrl": "https://gogoanime.film//overlord-iv-episode-4"
        },
        {
          "episodeId": "overlord-iv-episode-3",
          "episodeNum": "3",
          "episodeUrl": "https://gogoanime.film//overlord-iv-episode-3"
        },
        {
          "episodeId": "overlord-iv-episode-2",
          "episodeNum": "2",
          "episodeUrl": "https://gogoanime.film//overlord-iv-episode-2"
        },
        {
          "episodeId": "overlord-iv-episode-1",
          "episodeNum": "1",
          "episodeUrl": "https://gogoanime.film//overlord-iv-episode-1"
        }
      ]
    });
  }

  static Map<String, dynamic> toJson(AnimeDetails data) {
    return {
      "animeTitle": data.animeTitle,
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
    return "animeTitle:$animeTitle,type:$type,releaseDate:$releaseDate,status:$status,genres:$genres,otherNames:$otherNames,synopsis,animeImg$animeImg,totalEpisodes:$totalEpisodes,episodesList";
  }
}

class EpisodeDetails {
  final String? episodeId;
  final String? episodeNum;
  final String? episodeUrl;
  EpisodeDetails({this.episodeId, this.episodeNum, this.episodeUrl});

  static List<EpisodeDetails> normalize(List<dynamic> json) {
    // ignore: unnecessary_cast
    return json.map((e) {
      return EpisodeDetails.fromJson(e);
    }).toList() as List<EpisodeDetails>;
  }

  factory EpisodeDetails.fromJson(dynamic json) {
    return EpisodeDetails(
        episodeId: json['episodeId'],
        episodeNum: json['episodeNum'],
        episodeUrl: json['episodeUrl']);
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

class AnimeStream {
  final String? file;
  final String? label;
  final String? type;

  AnimeStream({this.file, this.label, this.type});
  factory AnimeStream.fromJson(dynamic json) {
    return AnimeStream(
        file: json['file'], label: json['label'], type: json['type']);
  }
}
