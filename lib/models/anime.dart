class Anime {
  final String? animeId;
  final String? animeTitle;
  final String? animeUrl;
  final String? animeImg;
  final String? status;

  Anime(
      {this.animeId,
      this.animeTitle,
      this.animeUrl,
      this.animeImg,
      this.status});

  factory Anime.fromJson(dynamic json) {
    return Anime(
        animeId: json['animeId'] as String,
        animeTitle: json['animeTitle'] as String,
        animeUrl: json['animeUrl'] as String,
        animeImg: json['animeImg'] as String,
        status: json['status'] as String);
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

  static List<Anime> animeListFromSnapShot(List Snapshot) {
    return Snapshot.map((data) {
      return Anime.fromJson(data);
    }).toList();
  }
  
  static List<Anime> popularAnime(List Snapshot) {
    return Snapshot.map((data) {
      return Anime.fromJson(data);
    }).toList();
  }

  static Anime toAnime(dynamic data){
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
