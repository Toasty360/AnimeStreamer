
class RecentEps {
  final String? animeId;
  final String? episodeId;
  final String? animeTitle;
  final String? episodeNum;
  final String? subOrDub;
  final String? animeImg;
  final String? episodeUrl;

  RecentEps(
      {this.animeId,
      this.episodeId,
      this.animeTitle,
      this.episodeNum,
      this.subOrDub,
      this.animeImg,
      this.episodeUrl});

  static List<RecentEps> fetchAllRecentEps(List json){
    return json.map((e) => RecentEps.toRecentEps(e)).toList();
  }

  factory RecentEps.toRecentEps(dynamic data) {
    return RecentEps(
        animeId: data["animeId"],
        episodeId: data["episodeId"],
        animeTitle: data["animeTitle"],
        episodeNum: data["episodeNum"],
        subOrDub: data["subOrDub"],
        animeImg: data["animeImg"],
        episodeUrl: data["episodeUrl"]);
  }
}
