import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:animeapp/models/animeApi.dart';
import 'package:animeapp/models/animeDetails.dart';
import 'package:animeapp/models/animeDetails_get.dart';
import 'package:animeapp/views/carouselSlider.dart';
import 'package:animeapp/views/menu.dart';
import 'package:animeapp/views/recentEpisode.dart';
import 'package:animeapp/views/search.dart';
import 'package:flutter/material.dart';
import 'package:flutter_staggered_animations/flutter_staggered_animations.dart';
import 'package:http/http.dart';
import 'package:path_provider/path_provider.dart';

import '../models/anime.dart';
import 'cards.dart';
import 'package:get/get.dart';

class Home extends StatefulWidget {
  const Home({super.key});

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  int index = 0;
  List<Anime> animeList = [];
  AnimeDataController animedatacont = Get.put(AnimeDataController());
  late Map<String, AnimeDetails> animedetailsList;

  bool serverStatus = false;

  Future<void> updateList() async {
    List<Anime> temp = await readLocalWatchList();
    setState(() {
      animeList = temp;
    });
  }

  late List<TopAnimeModel> topair;
  bool istopAirReady = false;

  getTopAir() async {
    topair = await AnimeApi.getTopAiring();
    istopAirReady = true;
    print(topair[0].url);
  }

  @override
  void initState() {
    super.initState();
    getTopAir();
    // updateList();
    Timer.periodic(const Duration(seconds: 1), (timer) {
      animeList = animedatacont.x;
      setState(() {});
    });
    // animeList = animedatacont.x;
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
        drawer: const Drawer(
            elevation: 0.0, backgroundColor: Colors.white, child: MenuPage()),
        appBar: AppBar(
          backgroundColor: const Color(0xFF17203A),
          elevation: 0.0,
          actions: [
            Container(
                margin: const EdgeInsets.all(10),
                child: GestureDetector(
                  child: CircleAvatar(
                    backgroundColor: serverStatus ? Colors.green : Colors.amber,
                    radius: 10,
                  ),
                  onTap: () async {
                    readplayer();
                    // Timer.periodic(Duration(milliseconds: 1, microseconds: 100), (timer) {});
                    // showDialog(
                    //   context: context,
                    //   builder: (context) {
                    //     return const AlertDialog(
                    //       title: Text("Success"),
                    //       titleTextStyle: TextStyle(
                    //           fontWeight: FontWeight.bold,
                    //           color: Colors.black,
                    //           fontSize: 20),
                    //       backgroundColor: Colors.greenAccent,
                    //       shape: RoundedRectangleBorder(
                    //           borderRadius:
                    //               BorderRadius.all(Radius.circular(20))),
                    //       content: Text("Save successfully"),
                    //     );
                    //   },
                    // );
                    print("ok");
                  },
                ))
          ],
        ),
        body: Container(
            color: const Color(0xFF17203A),
            padding: const EdgeInsets.only(left: 8),
            child: Column(
              children: [
                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.all(5),
                  // decoration: BoxDecoration(border: Border.all(width: 1)),
                  child: const Text(
                    "Top Airing",
                    textAlign: TextAlign.start,
                    style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        color: Colors.white),
                  ),
                ),
                const SizedBox(
                  height: 20,
                ),
                istopAirReady
                    ? CarouselContainer(
                        topAnime: topair,
                      )
                    : const Center(
                        child: CircularProgressIndicator(),
                      ),
                const SizedBox(
                  height: 20,
                ),
                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.all(5),
                  // decoration: BoxDecoration(border: Border.all(width: 1)),
                  child: const Text(
                    "WatchList",
                    textAlign: TextAlign.start,
                    style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        color: Colors.white),
                  ),
                ),
                animeList.isEmpty
                    ? const Center(
                        child: Text(
                          "Nothing to see here",
                          style: TextStyle(color: Colors.white),
                        ),
                      )
                    : Expanded(
                        child: GetBuilder<AnimeDataController>(
                          builder: (controller) {
                            List<Anime> animeList = controller.x;

                            return ListView.builder(
                                itemCount: animeList.length,
                                itemBuilder: (context, index) {
                                  double _w = MediaQuery.of(context).size.width;
                                  return AnimationConfiguration.staggeredList(
                                    position: index,
                                    delay: const Duration(milliseconds: 50),
                                    child: SlideAnimation(
                                      duration:
                                          const Duration(milliseconds: 2500),
                                      curve: Curves.fastLinearToSlowEaseIn,
                                      horizontalOffset: 30,
                                      verticalOffset: 300.0,
                                      child: FlipAnimation(
                                        duration:
                                            const Duration(milliseconds: 3000),
                                        curve: Curves.fastLinearToSlowEaseIn,
                                        flipAxis: FlipAxis.y,
                                        child: Dismissible(
                                            direction:
                                                DismissDirection.startToEnd,
                                            key: Key(animeList[index].animeId!),
                                            background: Container(
                                              margin: const EdgeInsets.all(10),
                                              decoration: BoxDecoration(
                                                // border: Border.all(width: 1),
                                                borderRadius:
                                                    BorderRadius.circular(10),
                                                gradient: LinearGradient(
                                                  begin: Alignment.topLeft,
                                                  end: Alignment.bottomRight,
                                                  colors: [
                                                    Colors.red.shade200,
                                                    Colors.red.shade300,
                                                    Colors.red.shade500,
                                                    Colors.red.shade600,
                                                  ],
                                                ),
                                              ),
                                              child: const Align(
                                                alignment: Alignment.centerLeft,
                                                child: Padding(
                                                  padding:
                                                      EdgeInsets.only(left: 16),
                                                  child: Icon(Icons.delete),
                                                ),
                                              ),
                                            ),
                                            child: Cards(animeList[index]),
                                            confirmDismiss: (direction) async {
                                              bool delete = true;
                                              final snackbarController =
                                                  ScaffoldMessenger.of(context)
                                                      .showSnackBar(
                                                SnackBar(
                                                  content: Text(
                                                      'Deleted ${animeList[index].animeId}'),
                                                  duration: const Duration(
                                                      milliseconds: 100),
                                                  action: SnackBarAction(
                                                      label: 'Undo',
                                                      onPressed: () =>
                                                          delete = false),
                                                ),
                                              );
                                              await snackbarController.closed;
                                              return delete;
                                            },
                                            onDismissed: (direction) {
                                              setState(() {
                                                animeList.removeAt(index);
                                                writeWatchlistToFile();
                                              });
                                            }),
                                      ),
                                    ),
                                  );
                                });
                          },
                        ),
                      ),
              ],
            )),
      ),
      const search(),
      const RecentEpisodes()
    ];
    return Scaffold(
      body: pages[index],
      backgroundColor: const Color(0xFF17203A),
      bottomNavigationBar: Container(
        height: 60,
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
                  height: 50,
                  padding: const EdgeInsets.only(left: 10, right: 10, top: 5),
                  margin: EdgeInsets.zero,
                  decoration: index == 0
                      ? BoxDecoration(
                          color: Theme.of(context).primaryColor,
                          borderRadius: BorderRadius.circular(10))
                      : const BoxDecoration(),
                  child: Column(
                    children: const [
                      Icon(Icons.home_filled, color: Colors.white),
                      Text(
                        "Home",
                        style: TextStyle(color: Colors.white),
                      )
                    ],
                  ),
                ),
              ),
              GestureDetector(
                onTap: () {
                  setState(() {
                    index = 1;
                  });
                },
                child: Container(
                  height: 50,
                  padding: const EdgeInsets.only(left: 10, right: 10, top: 5),
                  margin: EdgeInsets.zero,
                  decoration: index == 1
                      ? BoxDecoration(
                          color: Theme.of(context).primaryColor,
                          borderRadius: BorderRadius.circular(10))
                      : const BoxDecoration(),
                  child: Column(
                    children: const [
                      Icon(Icons.search, color: Colors.white),
                      Text(
                        "Search",
                        style: TextStyle(color: Colors.white),
                      )
                    ],
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
                  height: 50,
                  padding: const EdgeInsets.only(left: 10, right: 10, top: 5),
                  margin: EdgeInsets.zero,
                  decoration: index == 2
                      ? BoxDecoration(
                          color: Theme.of(context).primaryColor,
                          borderRadius: BorderRadius.circular(10))
                      : const BoxDecoration(),
                  child: Column(
                    children: const [
                      Icon(Icons.all_inclusive_rounded, color: Colors.white),
                      Text(
                        "Latest",
                        style: TextStyle(color: Colors.white),
                      )
                    ],
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

  void readplayer() async {
    var response = await get(Uri.parse("https://toasty-kun.vercel.app/"));
    //  print(response.statusCode);
    if (response.statusCode == 200) {
      serverStatus = true;
      print(serverStatus);
    }
    setState(() {});
  }
}


      // bottomNavigationBar: BottomNavigationBar(
      //   backgroundColor: const Color(0xFF17203A),
      //   fixedColor: Colors.white,
      //   // selectedLabelStyle: const TextStyle(color: Colors.white),
      //   // unselectedLabelStyle: const TextStyle(color: Colors.white),
      //   currentIndex: index,
      //   onTap: (int newIndex) {
      //     setState(() {
      //       index = newIndex;
      //     });
      //   },
      //   items: const [
      //     BottomNavigationBarItem(
      //       icon: Icon(Icons.home, color: Colors.white),
      //       label: "Home",
      //     ),
      //     BottomNavigationBarItem(
      //       icon: Icon(Icons.search, color: Colors.white),
      //       label: "Search",
      //     ),
      //     BottomNavigationBarItem(
      //       icon: Icon(Icons.all_inclusive_rounded, color: Colors.white),
      //       label: "Latest",
      //     )
      //   ],
      // ),




// class SlideAnimation1 extends StatelessWidget {
//   @override
//   Widget build(BuildContext context) {
//     double _w = MediaQuery.of(context).size.width;
//     return Scaffold(
//       appBar: AppBar(
//           title: const Text("Go Back"),
//           centerTitle: true,),
//       body: AnimationLimiter(
//         child: ListView.builder(
//           padding: EdgeInsets.all(_w / 30),
//           physics:
//               const BouncingScrollPhysics(parent: AlwaysScrollableScrollPhysics()),
//           itemCount: 20,
//           itemBuilder: (BuildContext c, int i) {
//             return         },
//         ),
//       ),
//     );
//   }
// }