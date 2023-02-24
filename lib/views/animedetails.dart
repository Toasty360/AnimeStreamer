import 'package:flutter/material.dart';
import 'package:http/http.dart';
import 'package:url_launcher/url_launcher.dart';

import '../models/animeApi.dart';
import '../models/animeDetails.dart';
import 'streamEpisode.dart';

class AnimeDetailsContainer extends StatefulWidget {
  final AnimeDetails item;
  const AnimeDetailsContainer(this.item);

  @override
  _AnimeDetailsContainerState createState() => _AnimeDetailsContainerState();
}

class _AnimeDetailsContainerState extends State<AnimeDetailsContainer> {
  var genreLength = 0;
  var genreString = "";
  @override
  void initState() {
    if (widget.item.genres != null) {
      genreString = widget.item.genres.toString();
      setState(() {
        genreString = genreString.substring(1, genreString.length - 1);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return widget.item.animeTitle != null
        ? Scaffold(
            appBar: AppBar(
              elevation: 0.0,
              iconTheme: const IconThemeData(color: Colors.black),
              backgroundColor: Colors.white,
              title: Text(
                widget.item.animeTitle!,
                style: const TextStyle(color: Colors.black),
              ),
            ),
            body: Container(
                margin: const EdgeInsets.only(top: 10),
                padding: const EdgeInsets.fromLTRB(20, 0, 20, 0),
                child: ListView(
                  children: [
                    Container(
                        padding: const EdgeInsets.all(10),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(10),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.grey.shade600,
                              spreadRadius: 1,
                              blurRadius: 15,
                              offset: const Offset(5, 5),
                            ),
                            const BoxShadow(
                                color: Colors.white,
                                offset: Offset(-5, -5),
                                blurRadius: 15,
                                spreadRadius: 1),
                          ],
                          gradient: LinearGradient(
                            begin: Alignment.topLeft,
                            end: Alignment.bottomRight,
                            colors: [
                              Colors.blue.shade100,
                              Colors.blue.shade200,
                              Colors.blue.shade300,
                              Colors.blue.shade400,
                            ],
                          ),
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            ClipRRect(
                              borderRadius: BorderRadius.circular(10.0),
                              child: Image.network(
                                widget.item.animeImg!,
                                width: 150,
                              ),
                            ),
                            Container(
                              width: 140,
                              // height: 200,
                              decoration: const BoxDecoration(
                                  // border: Border.all(width: 1),
                                  ),
                              margin: const EdgeInsets.only(left: 10),
                              child: Column(
                                children: [
                                  Text(widget.item.animeTitle!,
                                      style: const TextStyle(
                                          color: Colors.amber,
                                          fontWeight: FontWeight.bold,
                                          fontSize: 20,
                                          letterSpacing: 1)),
                                  Text(
                                    widget.item.status!,
                                    style: const TextStyle(fontSize: 10),
                                  ),
                                  const Divider(),
                                  const Text(
                                    "Genres",
                                    textAlign: TextAlign.left,
                                    style: TextStyle(
                                      color: Colors.blueAccent,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                  Text(genreString),
                                  const Divider(),
                                  Text(
                                      'Total Eps : ${widget.item.totalEpisodes!}'),
                                ],
                              ),
                            )
                          ],
                        )),
                    const Divider(),
                    //synopsis
                    Container(
                      margin: const EdgeInsets.only(top: 10, bottom: 10),
                      child: Text(widget.item.synopsis!),
                    ),
                    const Divider(),
                    //Episodes
                    TextButton(onPressed: (){
                      print(widget.item.episodesList.length);
                      Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) =>
                                  StreamAnime(widget.item.episodesList, widget.item.animeTitle)));
                    }, child: const Text("Watch Anime now!"))
                  ],
                )))
        : Scaffold(
            appBar: AppBar(title: const Text("Sorry")),
            body: Container(
              child: Center(
                  child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                // ignore: prefer_const_literals_to_create_immutables
                children: [
                  const Icon(
                    Icons.cloud_off_rounded,
                    size: 50,
                  ),
                  const Divider(),
                  const Text("Faild to get data from the server")
                ],
              )),
            ),
          );
  }

}
