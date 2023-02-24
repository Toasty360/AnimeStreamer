import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:path_provider/path_provider.dart';
import 'package:url_launcher/url_launcher.dart';

import '../models/animeApi.dart';
import '../models/animeDetails.dart';

class StreamAnime extends StatefulWidget {
  List<EpisodeDetails>? epslist;
  String? animeTitle;

  StreamAnime(this.epslist, this.animeTitle);

  // StreamAnime(epslist, animeTitle) {
  //   this.animeTitle = animeTitle;
  //   this.epslist = epslist;
  // }

  @override
  State<StreamAnime> createState() => _StreamAnimeState();
}

class _StreamAnimeState extends State<StreamAnime> {
  Color clor = Colors.lightBlue;
  late List<EpisodeDetails> localList = widget.epslist ?? [];
  late List<String> watchedIndexes = [];

  // Map<String, List<String>> watchHistory = {};

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

  @override
  void initState() {
    super.initState();
    updateIndex();
    // setState(() {
    //   updateIndex();
    // });
    // watchedIndexes = watchHistory[widget.animeTitle] ?? [];
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Episode list"),
        elevation: 0.0,
        actions: [
          IconButton(
              onPressed: () {
                writeWatchHistoryToFile();
              },
              icon: const Icon(
                Icons.history_edu_rounded,
                semanticLabel: "Save watch history",
              ),
              tooltip: "save watch history")
        ],
      ),
      body: localList.isNotEmpty
          ? Container(
              // margin: EdgeInsets.only(top: 10),
              padding: const EdgeInsets.fromLTRB(10, 20, 10, 10),
              width: double.infinity,
              height: double.infinity,
              child: GridView.builder(
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 4,
                      crossAxisSpacing: 4.0,
                      mainAxisSpacing: 4.0),
                  itemCount: localList.length,
                  itemBuilder: (context, index) {
                    var episode = localList[index];
                    return Container(
                        padding: const EdgeInsets.all(10),
                        margin: const EdgeInsets.all(10),
                        // width: 100,
                        // height: 200,
                        decoration: BoxDecoration(
                          // border: Border.all(width: 1),
                          borderRadius: BorderRadius.circular(10),
                          color:
                              watchedIndexes.contains('${episode.episodeNum}')
                                  ? Colors.lightGreen
                                  : Colors.lightBlue,
                          boxShadow: const [
                            BoxShadow(
                                color: Colors.grey,
                                blurRadius: 5,
                                spreadRadius: 1,
                                offset: Offset(4, 4)),
                          ],
                        ),
                        child: TextButton(
                          onPressed: () async {
                            if (!watchedIndexes.contains(episode.episodeNum)) {
                              setState(() {
                                watchedIndexes.add("${episode.episodeNum}");
                              });
                            }
                            var epsStreamingData =
                                await AnimeApi.getAnimeStreamURL(
                                    '${episode.episodeId}');
                            print(
                                "https://animestream.onrender.com/${epsStreamingData.file}");
                            launchUrl(Uri.parse(
                                "https://animestream.onrender.com/${epsStreamingData.file}"));
                          },
                          child: Text(
                            '${episode.episodeNum}',
                            style: const TextStyle(color: Colors.white),
                          ),
                        ));
                  }))
          : const Center(
              child:
                  Text("Sorry Episodes are not available yet! \t Cya later")),
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
}
// ListView.builder(