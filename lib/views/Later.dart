import 'dart:async';

import 'package:animeapp/models/anime.dart';
import 'package:animeapp/models/animeApi.dart';
import 'package:animeapp/models/animeDetails.dart';
import 'package:animeapp/models/animeDetails_get.dart';
import 'package:animeapp/views/cards.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class Later extends StatefulWidget {
  const Later({super.key});

  @override
  State<Later> createState() => _LaterState();
}

class _LaterState extends State<Later> {
  static List<Anime> animeList = [];
  AnimeDataController animedatacont = Get.put(AnimeDataController());
  late Map<String, AnimeDetails> animedetailsList;
  late List<TopAnimeModel> topair;
  bool istopAirReady = false;

  getTopAir() async {
    topair = await AnimeApi.getTopAiring();
    istopAirReady = true;
  }

  @override
  void initState() {
    super.initState();
    if (animeList.isEmpty) {
      Timer.periodic(const Duration(seconds: 1), (timer) {
        animeList = animedatacont.x;
        setState(() {});
      });
    }
    // getTopAir();
    // print(context.orientation);
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Container(
        child: animeList.isEmpty
            ? const Center(
                child: Text(
                  "Nothing to see here",
                  style: TextStyle(color: Colors.white),
                ),
              )
            : GetBuilder<AnimeDataController>(
                builder: (controller) {
                  List<Anime> animeList = controller.x;
                  return ListView.builder(
                      itemCount: animeList.length,
                      itemBuilder: (context, index) {
                        return Dismissible(
                            direction: DismissDirection.startToEnd,
                            key: Key(animeList[index].animeId!),
                            background: Container(
                              margin: const EdgeInsets.all(10),
                              decoration: BoxDecoration(
                                // border: Border.all(width: 1),
                                borderRadius: BorderRadius.circular(10),
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
                                  padding: EdgeInsets.only(left: 16),
                                  child: Icon(Icons.delete),
                                ),
                              ),
                            ),
                            child: Cards(animeList[index]),
                            confirmDismiss: (direction) async {
                              bool delete = true;
                              final snackbarController =
                                  ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(
                                  content: Text(
                                      'Deleted ${animeList[index].animeId}'),
                                  duration: const Duration(milliseconds: 100),
                                  action: SnackBarAction(
                                      label: 'Undo',
                                      onPressed: () => delete = false),
                                ),
                              );
                              await snackbarController.closed;
                              return delete;
                            },
                            onDismissed: (direction) {
                              // animedatacont.setData(animeList);
                              animedatacont.removeAt(index);
                              setState(() {
                                animeList.removeAt(index);
                              });
                            });
                      });
                },
              ),
      ),
    );
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    if (animedatacont.x.length != animeList.length) {
      animedatacont.setData(animeList);
    }
  }
}
