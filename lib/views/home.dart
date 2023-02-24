import 'dart:convert';
import 'dart:io';

import 'package:animeapp/models/animeDetails.dart';
import 'package:animeapp/views/recentEpisode.dart';
import 'package:animeapp/views/search.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart';
import 'package:path_provider/path_provider.dart';

import '../models/anime.dart';
import 'animecard.dart';
import 'cards.dart';
import 'profile.dart';

class Home extends StatefulWidget {
  const Home({super.key});

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  int index = 0;
  List<Anime> animeList = [];
  bool isPlayerReady = false;
  late Map<String, AnimeDetails> animedetailsList;

  Future<void> updateList() async {
    List<Anime> temp = await readLocalWatchList();
    setState(() {
      animeList = temp;
    });
  }

  @override
  void initState() {
    super.initState();
    updateList();
    readplayer();
  }

  Future<String> get _localPath async {
    final directory = await getApplicationDocumentsDirectory();

    return directory.path;
  }

  Future<File> get _localFile async {
    final path = await _localPath;
    return File('$path/watchlist.txt');
  }

  Future<List<Anime>> readLocalWatchList() async {
    final file = await _localFile;
    final contents = await file.readAsString();
    List _list = jsonDecode(contents);
    _list = _list.map((e) => Anime.toAnime(e)).toList();
    // print(_list);
    return _list as List<Anime>;
  }

  Future<File> writeWatchlistToFile() async {
    print("data length will return in file ${animeList.length}");
    String jsonData =
        jsonEncode(animeList.map((e) => Anime.toJson(e)).toList());

    final file = await _localFile;
    return file.writeAsString(jsonData);
  }

  @override
  Widget build(BuildContext context) {
    List<Widget> pages = [
      Scaffold(
        body: Container(
          padding: const EdgeInsets.only(left: 8),
          child: animeList.isEmpty
              ? const Center(
                  child: Text("Nothing to see here"),
                )
              : Container(
                  // decoration: BoxDecoration(border: Border.all(width: 1)),
                  margin: EdgeInsets.only(top: 20),
                  // padding: EdgeInsets.only(left: 10),
                  // height: 200,
                  child: ListView.builder(
                      itemCount: animeList.length,
                      itemBuilder: (context, index) {
                        return IntrinsicHeight(
                            child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Cards(animeList[index]),
                            IconButton(
                                onPressed: () {
                                  setState(() {
                                    animeList.removeAt(index);
                                    writeWatchlistToFile();
                                  });
                                },
                                icon: const Icon(Icons.cancel_outlined,
                                    size: 30)),
                          ],
                        ));
                      }),
                ),
        ),
        floatingActionButton: FloatingActionButton(
          child: const Icon(Icons.refresh),
          onPressed: () async {
            setState(() {
              animeList.addAll(AnimeCard.mylist);
              animeList = animeList.toSet().toList();

              writeWatchlistToFile();
              readLocalWatchList().then((value) {
                print(value.length);
              });
            });
          },
        ),
      ),
      const search(),
      // Profile(animeList),
      const RecentEpisodes()
    ];
    return Scaffold(
      body: pages[index],
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: index,
        onTap: (int newIndex) {
          setState(() {
            index = newIndex;
          });
        },
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: "Home",
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.search),
            label: "Search",
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.airline_seat_recline_extra_rounded),
            label: "Latest",
          )
        ],
      ),
    );
  }

  void readplayer() async {
    var response = await get(Uri.parse("https://animestream.onrender.com/"));
    //  print(response.statusCode);
    if (response.statusCode == 200) {
      isPlayerReady = true;
    }
  }
}
