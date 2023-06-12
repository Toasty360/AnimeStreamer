// ignore: file_names
import 'package:animeapp/views/Later.dart';
import 'package:animeapp/views/Schedule.dart';
import 'package:animeapp/views/recentEpisode.dart';
import 'package:animeapp/views/search.dart';
import 'package:flutter/material.dart';
import 'Later.dart';
import 'Home.dart';
import 'package:get/get.dart';

class LayoutComp extends StatefulWidget {
  const LayoutComp({super.key});

  @override
  State<LayoutComp> createState() => LayoutCompState();
}

class LayoutCompState extends State<LayoutComp> {
  int index = 0;
  // List<Anime> animeList = [];
  // AnimeDataController animedatacont = Get.put(AnimeDataController());
  // late Map<String, AnimeDetails> animedetailsList;
  // late List<TopAnimeModel> topair;
  // bool istopAirReady = false;

  // Future<void> updateList() async {
  //   List<Anime> temp = await readLocalWatchList();
  //   setState(() {
  //     animeList = temp;
  //   });
  // }

  // getTopAir() async {
  //   topair = await AnimeApi.getTopAiring();
  //   istopAirReady = true;
  // }

  // @override
  // void initState() {
  //   super.initState();
  //   // updateList();
  //   Timer.periodic(const Duration(seconds: 1), (timer) {
  //     animeList = animedatacont.x;
  //     setState(() {});
  //   });
  //   getTopAir();
  //   // animeList = animedatacont.x;
  // }

  // Future<String> get _localPath async {
  //   final directory = await getApplicationDocumentsDirectory();
  //   return directory.path;
  // }
  // Future<File> get _localFile async {
  //   final path = await _localPath;
  //   return File('$path/watchlist.txt');
  // }
  // Future<List<Anime>> readLocalWatchList() async {
  //   final file = await _localFile;
  //   final contents = await file.readAsString();
  //   List _list = jsonDecode(contents);
  //   _list = _list.map((e) => Anime.toAnime(e)).toList();
  //   // print(_list);
  //   return _list as List<Anime>;
  // }
  // Future<File> writeWatchlistToFile() async {
  //   print("data length will return in file ${animeList.length}");
  //   String jsonData =
  //       jsonEncode(animeList.map((e) => Anime.toJson(e)).toList());
  //   final file = await _localFile;
  //   return file.writeAsString(jsonData);
  // }

  @override
  Widget build(BuildContext context) {
    List<Widget> pages = [
      const Home(),
      const Later(),
      const search(),
      const RecentEpisodes(),
      const Schedule(),
    ];
    return Scaffold(
      body: pages[index],
      backgroundColor: const Color(0xFF17203A),
      bottomNavigationBar: Container(
        height: 65,
        decoration: const BoxDecoration(
          color: Color(0xFF17203A),
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(20),
            topRight: Radius.circular(20),
          ),
        ),
        child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              GestureDetector(
                onTap: () {
                  setState(() {
                    index = 0;
                  });
                },
                child: Container(
                    height: double.infinity,
                    decoration: BoxDecoration(
                        border:
                            Border.all(width: 1, color: Colors.transparent)),
                    padding: const EdgeInsets.only(left: 10, right: 10, top: 5),
                    margin: EdgeInsets.zero,
                    width: context.width / 5,
                    child: index == 0
                        ? Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: const [
                              Icon(Icons.trending_up,
                                  color: Colors.greenAccent),
                              Text(
                                "Trends",
                                style: TextStyle(color: Colors.greenAccent),
                              )
                            ],
                          )
                        : const Center(
                            child: Icon(Icons.trending_up, color: Colors.white),
                          )),
              ),
              GestureDetector(
                onTap: () {
                  setState(() {
                    index = 1;
                  });
                },
                child: Container(
                  decoration: BoxDecoration(
                      border: Border.all(width: 1, color: Colors.transparent)),
                  height: double.infinity,
                  padding: const EdgeInsets.only(left: 10, right: 10, top: 5),
                  margin: EdgeInsets.zero,
                  width: context.width / 5,
                  child: index == 1
                      ? Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: const [
                            Icon(Icons.bookmark, color: Colors.greenAccent),
                            Text(
                              "Later",
                              style: TextStyle(color: Colors.greenAccent),
                            )
                          ],
                        )
                      : const Center(
                          child: Icon(Icons.bookmark, color: Colors.white),
                        ),
                ),
              ),
              GestureDetector(
                onTap: () {
                  setState(() {
                    index = 2;
                  });
                },
                child: Container(
                  decoration: BoxDecoration(
                      border: Border.all(width: 1, color: Colors.transparent)),
                  height: double.infinity,
                  padding: const EdgeInsets.only(left: 10, right: 10, top: 5),
                  margin: EdgeInsets.zero,
                  width: context.width / 5,
                  child: index == 2
                      ? Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: const [
                            Icon(Icons.search, color: Colors.greenAccent),
                            Text(
                              "Search",
                              style: TextStyle(color: Colors.greenAccent),
                            )
                          ],
                        )
                      : const Center(
                          child: Icon(Icons.search, color: Colors.white),
                        ),
                ),
              ),
              GestureDetector(
                onTap: () {
                  setState(() {
                    index = 3;
                  });
                },
                child: Container(
                  decoration: BoxDecoration(
                      border: Border.all(width: 1, color: Colors.transparent)),
                  height: double.infinity,
                  padding: const EdgeInsets.only(left: 10, right: 10, top: 5),
                  margin: EdgeInsets.zero,
                  width: context.width / 5,
                  child: index == 3
                      ? Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: const [
                            Icon(Icons.all_inclusive_rounded,
                                color: Colors.greenAccent),
                            Text(
                              "Latest",
                              style: TextStyle(color: Colors.greenAccent),
                            )
                          ],
                        )
                      : const Center(
                          child: Icon(Icons.all_inclusive_rounded,
                              color: Colors.white),
                        ),
                ),
              ),
              GestureDetector(
                onTap: () {
                  setState(() {
                    index = 4;
                  });
                },
                child: Container(
                  decoration: BoxDecoration(
                      border: Border.all(width: 1, color: Colors.transparent)),
                  height: double.infinity,
                  padding: const EdgeInsets.only(left: 10, right: 10, top: 5),
                  margin: EdgeInsets.zero,
                  width: context.width / 5,
                  child: index == 4
                      ? Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: const [
                            Icon(Icons.schedule, color: Colors.greenAccent),
                            Text(
                              "Next",
                              style: TextStyle(color: Colors.greenAccent),
                              overflow: TextOverflow.ellipsis,
                            )
                          ],
                        )
                      : const Center(
                          child: Icon(Icons.schedule, color: Colors.white),
                        ),
                ),
              ),
            ]),
      ),
    );
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
  }
}
