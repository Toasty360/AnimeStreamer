import 'package:animeapp/models/anime.dart';
import 'package:animeapp/models/animeDetails_get.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';

import '../models/animeApi.dart';
import '../models/animeDetails.dart';
import 'streamEpisode.dart';

class AnimeDetailsContainer extends StatefulWidget {
  // final Map<String, String> data;
  final Anime item;
  const AnimeDetailsContainer(this.item, {super.key});

  @override
  // ignore: library_private_types_in_public_api
  _AnimeDetailsContainerState createState() => _AnimeDetailsContainerState();
}

class _AnimeDetailsContainerState extends State<AnimeDetailsContainer> {
  static var genreLength = 0;
  static var genreString = "";
  static Map<String, AnimeDetails> tempAniDetails = {};
  bool status = true;
  bool isLoaded = false;
  // late AnimeDetails? itemDetails = AnimeDetails.dummydata();
  late List<AnimeDetails> itemDetails = [];
  AnimeDataController animedatacont = Get.put(AnimeDataController());
  bool isSaved = false;
  int savedIndex = -1;

  fetchData() async {
    var temp = await AnimeApi.getAnime(widget.item.animeId!);

    setState(() {
      isLoaded = true;
      itemDetails = [temp];
      tempAniDetails[widget.item.animeTitle!] = temp;
      genreString = itemDetails[0].genres.toString();
      status = itemDetails[0].status == "Completed" ? true : false;
      genreString = genreString.substring(1, genreString.length - 1);
      isLoaded = true;
    });
  }

  @override
  void initState() {
    for (var item in animedatacont.x) {
      if (item.animeTitle == widget.item.animeTitle) {
        isSaved = true;
        savedIndex = animedatacont.x.indexOf(item);
      }
    }
    if (tempAniDetails.containsKey(widget.item.animeTitle)) {
      itemDetails = [tempAniDetails[widget.item.animeTitle]!];
    } else {
      fetchData();
    }
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return itemDetails.isNotEmpty
        ? Scaffold(
            backgroundColor: const Color(0xFF17203A),
            appBar: AppBar(
              elevation: 0.0,
              iconTheme: const IconThemeData(color: Colors.white),
              backgroundColor: const Color(0xFF17203A),
              title: Text(
                itemDetails[0].title,
                style: const TextStyle(
                  color: Colors.white,
                ),
              ),
              actions: [
                // TextButton(child: isSaved?Text("Saved") ,onPressed: ())
                IconButton(
                  onPressed: () {
                    if (isSaved) {
                      animedatacont.removeAt(savedIndex);
                      isSaved = false;
                    } else {
                      animedatacont.addItemToList(Anime(
                          animeId: itemDetails[0].id,
                          animeImg: itemDetails[0].animeImg,
                          animeTitle: itemDetails[0].title,
                          animeUrl: itemDetails[0].url,
                          status: itemDetails[0].status,
                          subOrDub: itemDetails[0].subOrDub));
                      isSaved = true;
                    }
                    setState(() {});
                  },
                  icon: Icon(MdiIcons.bookmark),
                  color: isSaved ? Colors.greenAccent : Colors.white,
                )
              ],
            ),
            body: Container(
                // margin: const EdgeInsets.only(top: 10),
                margin: const EdgeInsets.fromLTRB(20, 10, 20, 0),
                child: ListView(
                  children: [
                    Container(
                        padding: const EdgeInsets.all(10),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(10),
                          gradient: LinearGradient(
                            begin: Alignment.topLeft,
                            end: Alignment.bottomRight,
                            colors: [
                              Colors.blue.shade200,
                              Colors.blue.shade300,
                              Colors.blue.shade500,
                              Colors.blue.shade600,
                            ],
                          ),
                        ),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            Container(
                              padding: const EdgeInsets.all(5),
                              child: Text(
                                itemDetails[0].title,
                                style: TextStyle(
                                    color: Colors.amber.shade600,
                                    fontWeight: FontWeight.bold,
                                    // fontFamily: "Takota",
                                    fontSize: 18,
                                    letterSpacing: 1,
                                    overflow: TextOverflow.clip),
                                textAlign: TextAlign.center,
                              ),
                            ),
                            Container(
                              padding: EdgeInsets.only(bottom: 5),
                              child: SizedBox(
                                child: Row(
                                  children: [
                                    ClipRRect(
                                      borderRadius: BorderRadius.circular(10.0),
                                      child: Image.network(
                                        itemDetails[0].animeImg,
                                        width: 150,
                                      ),
                                    ),
                                    Container(
                                      width: 140,
                                      // height: 150,
                                      // decoration: BoxDecoration(
                                      //     border: Border.all(width: 1),
                                      //     ),
                                      margin: const EdgeInsets.only(left: 10),
                                      child: Column(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceEvenly,
                                        children: [
                                          SizedBox(
                                              width: double.infinity,
                                              child: Row(
                                                children: [
                                                  const Text("Status: "),
                                                  Text(
                                                    "${itemDetails[0].status}",
                                                    style: TextStyle(
                                                        fontSize: 13,
                                                        color: status
                                                            ? Colors
                                                                .green.shade900
                                                            : Colors.amber
                                                                .shade400),
                                                  ),
                                                ],
                                              )),
                                          const Divider(),
                                          const SizedBox(
                                              width: double.infinity,
                                              child: Text(
                                                "Genres",
                                                textAlign: TextAlign.left,
                                                style: TextStyle(
                                                  color: Colors.blueAccent,
                                                  fontWeight: FontWeight.bold,
                                                ),
                                              )),
                                          Container(
                                              width: double.infinity,
                                              height: 100,
                                              child: Text(
                                                genreString,
                                                overflow: TextOverflow.fade,
                                              )),
                                          const Divider(),
                                          SizedBox(
                                              width: double.infinity,
                                              child: Row(
                                                children: [
                                                  const Text("Total Eps : "),
                                                  Text(
                                                      itemDetails[0]
                                                          .totalEpisodes,
                                                      style: TextStyle(
                                                          color: Colors
                                                              .amber.shade400)),
                                                ],
                                              )),
                                        ],
                                      ),
                                    )
                                  ],
                                ),
                              ),
                            ),
                          ],
                        )),
                    const Divider(),
                    //synopsis
                    Container(
                      margin: const EdgeInsets.only(top: 10, bottom: 10),
                      padding: EdgeInsets.all(10),
                      child: Text(
                        itemDetails[0].synopsis,
                        style: const TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.w200,
                        ),
                        textAlign: TextAlign.justify,
                      ),
                    ),
                    const Divider(),
                    //Episodes
                    TextButton(
                        onPressed: () {
                          print(itemDetails[0].episodesList.length);
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => StreamAnime(
                                      itemDetails[0].episodesList,
                                      itemDetails[0].title,
                                      1)));
                        },
                        child: const Text("Watch Anime now!")),
                    //
                    // const Divider(),
                    // //Episodes
                    // TextButton(
                    //     onPressed: () {
                    //       print(itemDetails[0].episodesList.length);
                    //       Navigator.push(
                    //           context,
                    //           MaterialPageRoute(
                    //               builder: (context) => StreamAnime(
                    //                   itemDetails[0].episodesList,
                    //                   itemDetails[0].title,
                    //                   1)));
                    //     },
                    //     child: const Text("Watch Anime now from zoro!")),
                  ],
                )))
        : Scaffold(
            backgroundColor: const Color(0xFF17203A),
            appBar: AppBar(
                title: Text("${widget.item.animeTitle}"),
                backgroundColor: const Color(0xFF17203A)),
            body: Center(
                child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: const [
                CircularProgressIndicator(),
                // const Divider(),
                SizedBox(
                  height: 10,
                ),
                Text(
                  "Fetching data from the server",
                  style: TextStyle(color: Colors.white),
                )
              ],
            )),
          );
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
  }
}
