import 'dart:convert';
import 'dart:io';

// import 'package:animeapp/views/playback.dart';
import 'package:better_player/better_player.dart';
import 'package:flutter/material.dart';
import 'package:path_provider/path_provider.dart';

import '../models/animeApi.dart';
import '../models/animeDetails.dart';

class StreamAnime extends StatefulWidget {
  List<EpisodeDetails>? epslist;
  String? animeTitle;
  int? option;

  StreamAnime(this.epslist, this.animeTitle, this.option);

  @override
  State<StreamAnime> createState() => _StreamAnimeState();
}

class _StreamAnimeState extends State<StreamAnime> {
  Color clor = Colors.lightBlue;
  late List<EpisodeDetails> localList = widget.epslist ?? [];
  late List<String> watchedIndexes = [];

  Future<String> get _localPath async {
    final directory = await getApplicationDocumentsDirectory();

    return directory.path;
  }

  Future<File> get _localFile async {
    final path = await _localPath;
    int code = widget.animeTitle.hashCode;
    return File('$path/${code}.txt');
  }

  Future<List<String>> readLocalWatchHistory() async {
    final file = await _localFile;
    final contents = await file.readAsString();
    List _temp = jsonDecode(contents);
    List<String> data = _temp.map((e) => e.toString()).toList();
    print(data);
    return data;
  }

  Future<File> writeWatchHistoryToFile() async {
    String jsonData = jsonEncode(watchedIndexes);
    final file = await _localFile;
    return file.writeAsString(jsonData);
  }

  Future<void> updateIndex() async {
    List<String> temp = await readLocalWatchHistory();
    setState(() {
      watchedIndexes = temp;
    });
  }

  var currentVideo = "";

  @override
  void initState() {
    super.initState();
    try {
      updateIndex();
    } catch (e) {}
    print(widget.epslist);
    if (widget.epslist!.isNotEmpty) currentVideo = widget.epslist![0].episodeId;
    // getlinks(currentVideo);
  }

  updateVideo(id) {
    currentVideo = id;
    setState(() {});
  }

  late BetterPlayerController betterPlayerController;
  bool isPlayerReady = false;
  var episodeId = "";

  readyplayer(url) {
    print(url);
    betterPlayerController = BetterPlayerController(
      const BetterPlayerConfiguration(aspectRatio: 16 / 9),
      betterPlayerDataSource: BetterPlayerDataSource(
          BetterPlayerDataSourceType.network, url["default"]!,
          resolutions: url),
    );
    // betterPlayerController.enterFullScreen();

    betterPlayerController.addEventsListener((BetterPlayerEvent event) {
      if (event.betterPlayerEventType == BetterPlayerEventType.initialized) {
        betterPlayerController.setOverriddenAspectRatio(
            betterPlayerController.videoPlayerController!.value.aspectRatio);
        setState(() {});
      }
    });
  }

  bool goterror = false;
  getlinks(currentVideo) async {
    episodeId = currentVideo;
    try {
      links = await AnimeApi.getEpisodeUrls(episodeId);
      print(watchedIndexes[watchedIndexes.length - 1]);
      print("recent episode");
      Map<String, String> linksdata = {};
      for (EpisodeUrl uri in links!) {
        linksdata[uri.quality] = uri.url;
      }
      readyplayer(linksdata);
      isPlayerReady = true;
      setState(() {});
    } catch (e) {
      setState(() {
        goterror = true;
      });
    }
  }

  List<EpisodeUrl>? links;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF17203A),
      appBar: AppBar(
        title: const Text("Episode list"),
        backgroundColor: const Color(0xFF17203A),
        elevation: 0.0,
      ),
      body: localList.isNotEmpty
          ? ConstrainedBox(
              constraints: const BoxConstraints(maxHeight: double.infinity),
              child: Column(
                children: [
                  isPlayerReady
                      ? AspectRatio(
                          aspectRatio: 16 / 9,
                          child:
                              BetterPlayer(controller: betterPlayerController),
                        )
                      : goterror
                          ? Center(
                              child: Text(
                                "No data retruned from gogoanime :(",
                                style: TextStyle(color: Colors.red.shade400),
                              ),
                            )
                          : const Center(),
                  Expanded(
                    child: Container(
                        // margin: EdgeInsets.only(top: 10),
                        padding: const EdgeInsets.fromLTRB(10, 20, 10, 10),
                        width: double.infinity,
                        height: double.infinity,
                        child: GridView.builder(
                            gridDelegate:
                                const SliverGridDelegateWithFixedCrossAxisCount(
                                    crossAxisCount: 5,
                                    crossAxisSpacing: 4.0,
                                    mainAxisSpacing: 4.0),
                            itemCount: localList.length,
                            itemBuilder: (context, index) {
                              var episode = localList[index];
                              return Container(
                                  // padding: const EdgeInsets.all(10),
                                  margin: const EdgeInsets.all(10),
                                  // width: 100,
                                  // height: 200,
                                  decoration: BoxDecoration(
                                    // border: Border.all(width: 1),
                                    borderRadius: BorderRadius.circular(10),
                                    color: watchedIndexes
                                            .contains(episode.episodeNum)
                                        ? Colors.lightGreen
                                        : Colors.lightBlue,
                                  ),
                                  child: TextButton(
                                    onPressed: () async {
                                      if (isPlayerReady)
                                        betterPlayerController.dispose();
                                      getlinks(episode.episodeId);
                                      print("requested to change the video");
                                      ScaffoldMessenger.of(context)
                                          .showSnackBar(const SnackBar(
                                        content: Text("Fetching"),
                                        duration: Duration(seconds: 1),
                                      ));
                                      if (!watchedIndexes
                                          .contains(episode.episodeNum)) {
                                        setState(() {
                                          watchedIndexes
                                              .add(episode.episodeNum);
                                        });
                                      }
                                      updateVideo(episode.episodeId);
                                    },
                                    child: Text(
                                      localList[index].episodeNum,
                                      style: const TextStyle(
                                          color: Colors.white,
                                          fontWeight: FontWeight.bold),
                                    ),
                                  ));
                            })),
                  ),
                ],
              ),
            )
          : const Center(
              child: Text(
              "Sorry Episodes are not available yet! \t Cya later",
              style: TextStyle(color: Colors.white),
            )),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          setState(() {
            localList = localList.reversed.toList();
          });
        },
        child: const Icon(Icons.sort),
      ),
    );
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    writeWatchHistoryToFile();
    betterPlayerController.dispose();
  }
}
// ListView.builder(