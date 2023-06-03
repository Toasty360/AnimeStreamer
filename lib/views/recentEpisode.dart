import 'package:animeapp/models/animeApi.dart';
import 'package:animeapp/models/animeDetails.dart';
import 'package:flutter/material.dart';
import 'package:flutter_staggered_animations/flutter_staggered_animations.dart';

import 'animeDetailsContainer.dart';

class RecentEpisodes extends StatefulWidget {
  const RecentEpisodes({super.key});

  @override
  State<RecentEpisodes> createState() => _RecentEpisodesState();
}

class _RecentEpisodesState extends State<RecentEpisodes> {
  static List<RecentEps> list = [];
  int page = 1;
  bool isLoaded = false;

  fetchdata() async {
    List<RecentEps> data = await AnimeApi.getRecentEps('$page');
    setState(() {
      list = data;
      isLoaded = true;
      page += 1;
    });
    print(data[0]);
  }

  @override
  void initState() {
    super.initState();
    fetchdata();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF17203A),
      body: NotificationListener<ScrollNotification>(
        onNotification: (notification) {
          if (notification.metrics.pixels ==
                  notification.metrics.maxScrollExtent &&
              isLoaded) {
            isLoaded = false;

            Future.microtask(
              () async {
                List<RecentEps> data = await AnimeApi.getRecentEps("$page");
                setState(() {
                  list.addAll(data);
                  isLoaded=true;
                  page++;
                });
              },
            );
          }
          return true;
        },
        child: isLoaded
            ? ListView.builder(
                itemCount: list.length,
                itemBuilder: (context, index) {
                  return AnimationConfiguration.staggeredGrid(
                      position: index,
                      duration: const Duration(milliseconds: 50),
                      columnCount: index,
                      child: ScaleAnimation(
                          duration: const Duration(milliseconds: 150),
                          curve: Curves.fastLinearToSlowEaseIn,
                          child: FadeInAnimation(
                              child: Container(
                            margin: const EdgeInsets.all(5),
                            padding: const EdgeInsets.all(3),
                            // decoration: BoxDecoration(
                            //   borderRadius: BorderRadius.circular(10),
                            //   gradient: LinearGradient(
                            //     begin: Alignment.topLeft,
                            //     end: Alignment.bottomRight,
                            //     colors: [
                            //       Colors.grey.shade200,
                            //       Colors.grey.shade300,
                            //       Colors.grey.shade500,
                            //       Colors.grey.shade600,
                            //     ],
                            //   ),
                            // ),
                            child: GestureDetector(
                                onTap: () async {
                                  Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                          builder: (context) =>
                                              AnimeDetailsContainer({
                                                "id": list[index].id,
                                                "title": list[index].title
                                              })));
                                },
                                child: Container(
                                  padding: EdgeInsets.all(10),
                                  height: 150,
                                  decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(10),
                                      image: DecorationImage(
                                        fit: BoxFit.cover,
                                        opacity: 0.09,
                                        colorFilter: const ColorFilter
                                            .srgbToLinearGamma(),
                                        scale: 1.5,
                                        image: NetworkImage(list[index].image),
                                        onError: (exception, stackTrace) {
                                          Container(
                                              color: Colors.amber,
                                              alignment: Alignment.center,
                                              child: const Text(
                                                'Whoops!',
                                                style: TextStyle(fontSize: 20),
                                              ));
                                        },
                                      )),
                                  child: Row(
                                    children: [
                                      ClipRRect(
                                        borderRadius:
                                            BorderRadius.circular(10.0),
                                        child: Image.network(
                                          list[index].image,
                                          height: 400,
                                          errorBuilder:
                                              (context, error, stackTrace) {
                                            return Container(
                                                color: Colors.amber,
                                                alignment: Alignment.center,
                                                child: const Text(
                                                  'Whoops!',
                                                  style:
                                                      TextStyle(fontSize: 30),
                                                ));
                                          },
                                        ),
                                      ),
                                      Expanded(
                                          child: Column(
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        children: [
                                          Container(
                                            // decoration: BoxDecoration(border: Border.all(width: 10, color: Colors.black)),
                                            padding:
                                                const EdgeInsets.only(left: 10),
                                            width: 200,
                                            child: Text(
                                              list[index].title != ""
                                                  ? list[index].title
                                                  : list[index].id,
                                              style: const TextStyle(
                                                  fontSize: 18,
                                                  fontWeight: FontWeight.bold,
                                                  color: Colors.white),
                                              maxLines: 2,
                                              textAlign: TextAlign.center,
                                              overflow: TextOverflow.ellipsis,
                                            ),
                                          ),
                                          Container(
                                            margin: EdgeInsets.only(top: 10),
                                            child: Text(
                                              list[index].episodeNumber,
                                              style: const TextStyle(
                                                  fontSize: 15,
                                                  fontWeight: FontWeight.bold,
                                                  color: Colors.green),
                                            ),
                                          )
                                        ],
                                      ))
                                    ],
                                  ),
                                )),
                          ))));
                })
            : Center(
                child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: const [
                    CircularProgressIndicator(),
                    SizedBox(
                      height: 20,
                    ),
                    Text(
                      "Please wait fetching the latest episodes!",
                      style: TextStyle(color: Colors.white),
                    ),
                  ])),
      ),
      // floatingActionButton: FloatingActionButton(
      //     onPressed: () async {
      //       if (list != []) {
      //         page += 1;
      //       }
      //       List<RecentEps> data = await AnimeApi.getRecentEps("$page");
      //       setState(() {
      //         list.addAll(data);
      //       });
      //     },
      //     child: const Icon(Icons.format_list_bulleted_add)),
    );
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
  }
}
