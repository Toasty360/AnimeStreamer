import 'package:animeapp/models/animeApi.dart';
import 'package:animeapp/models/recentAnimeEps.dart';
import 'package:flutter/material.dart';

import 'animedetails.dart';

class RecentEpisodes extends StatefulWidget {
  const RecentEpisodes({super.key});

  @override
  State<RecentEpisodes> createState() => _RecentEpisodesState();
}

class _RecentEpisodesState extends State<RecentEpisodes> {
  static List<RecentEps> list = [];
  int page = 1;
  bool isLoaded = false;

  @override
  void initState() {
    super.initState();
    fetchdata();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: isLoaded
          ? ListView.builder(
            physics: const AlwaysScrollableScrollPhysics(),
              itemCount: list.length,
              itemBuilder: (context, index) {
                return Container(
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
                  width: double.infinity,
                  padding: const EdgeInsets.all(10),
                  margin: const EdgeInsets.all(10),
                  // height: 200,
                  child: Row(children: [
                    InkWell(
                      onTap: () async {
                        var itemDetails =
                            await AnimeApi.getAnime(list[index].animeId!);

                        // ignore: use_build_context_synchronously
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) =>
                                    AnimeDetailsContainer(itemDetails)));
                      },
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(10.0),
                        child: Image.network(
                          list[index].animeImg!,
                          width: 150,
                        ),
                      ),
                    ),
                    Expanded(
                        child: Container(
                            // decoration: BoxDecoration(border: Border.all(width: 1)),
                            height: 150,
                            padding: const EdgeInsets.all(10),
                            child: Column(
                              children: [
                                Container(
                                  height: 50,
                                  child: Text(
                                    list[index].animeTitle!,
                                    style: const TextStyle(fontSize: 18),
                                    overflow: TextOverflow.fade,
                                  ),
                                ),
                                Expanded(
                                    child: Row(
                                  children: [
                                    const Text(
                                      "EP:",
                                      style: TextStyle(fontSize: 18),
                                    ),
                                    const SizedBox(width: 10,),
                                    Text(
                                      list[index].episodeNum!,
                                      style: const TextStyle(fontSize: 18),
                                    ),
                                  ],
                                )),
                                Expanded(
                                    child: Row(
                                  children: [
                                    const Text(
                                      "Type:",
                                      style: TextStyle(fontSize: 18),
                                    ),
                                    const SizedBox(width: 10,),
                                    Text(
                                  list[index].subOrDub!,
                                      style: const TextStyle(fontSize: 18),
                                    ),
                                  ],
                                ))
                              ],
                            ))),
                  ]),
                );
              })
          : const Center(
              child: CircularProgressIndicator(),
            ),
      floatingActionButton: FloatingActionButton(
          onPressed: () async {
            List<RecentEps> data = await AnimeApi.getRecentEps("$page");
            setState(() {
              list.addAll(data);
              page += 1;
            });
          },
          child: Icon(Icons.refresh)),
    );
  }

  fetchdata() async {
    List<RecentEps> data = await AnimeApi.getRecentEps('$page');
    setState(() {
      list = data;
      isLoaded = true;
      page += 1;
    });
  }
}
