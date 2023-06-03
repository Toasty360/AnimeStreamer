class Anime {
  final String? animeId;
  final String? animeTitle;
  final String? animeUrl;
  final String? animeImg;
  final String? status;
  final String? subOrDub;
  Anime(
      {this.animeId,
      this.animeTitle,
      this.animeUrl,
      this.animeImg,
      this.status,
      this.subOrDub});

  static List<Anime> animeListFromSnapShot(List json) {
    return json.map((data) {
      return Anime.fromJson(data);
    }).toList();
  }

  factory Anime.fromJson(json) {
    return Anime(
        animeId: json['id'],
        animeTitle: json['title'],
        animeUrl: json['url'],
        animeImg: json['image'],
        status: json['releaseDate'],
        subOrDub: json['subOrDub']);
  }

  static Map<String, dynamic> toJson(Anime data) {
    return {
      "animeId": data.animeId,
      "animeTitle": data.animeTitle,
      "animeUrl": data.animeUrl,
      "animeImg": data.animeImg,
      "status": data.status,
    };
  }

  static List<Anime> popularAnime(List Snapshot) {
    return Snapshot.map((data) {
      return Anime.fromJson(data);
    }).toList();
  }

  static Anime toAnime(dynamic data) {
    return Anime(
        animeId: data["animeId"],
        animeTitle: data["animeTitle"],
        animeUrl: data["animeUrl"],
        animeImg: data["animeImg"],
        status: data["status"]);
  }

  static Anime dummyData() {
    return Anime(
        animeId: "naruto",
        animeTitle: "Naruto",
        animeUrl: "https://gogoanime.film///category/naruto",
        animeImg: "https://gogocdn.net/images/anime/N/naruto.jpg",
        status: "Released: 2002");
  }

  @override
  String toString() {
    return 'Anime{ name : $animeTitle, url:$animeUrl, img : $animeImg, status : $status}';
  }
}

class TopAnimeModel {
  final String id;
  final String title;
  final String url;

  TopAnimeModel(this.id, this.title, this.url);

  TopAnimeModel toTopAir(json) {
    return TopAnimeModel(json["id"], json["title"], json["url"]);
  }
}
