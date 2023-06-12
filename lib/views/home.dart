import 'package:animeapp/models/anime.dart';
import 'package:animeapp/models/animeApi.dart';
import 'package:animeapp/views/carouselSlider.dart';
import 'package:flutter/material.dart';
import 'animeDetailsContainer.dart';

class Home extends StatefulWidget {
  const Home({super.key});

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  static List<TopAnimeModel> topair = [];
  static bool istopAirReady = false;
  // Widget topAirCards;

  getTopAir() async {
    topair = await AnimeApi.getTopAiring();
    istopAirReady = true;
    setState(() {});
    // topair
    //     .map((item) => )
    //     .toList();
  }

  @override
  void initState() {
    super.initState();
    if (topair.isEmpty) {
      getTopAir();
    }
    // print(context.orientation);
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
        child: Container(
      child: istopAirReady
          ? ListView.builder(
              itemCount: topair.length,
              itemBuilder: (BuildContext context, int index) {
                return GestureDetector(
                  onTap: () {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => AnimeDetailsContainer(Anime(
                                animeId: topair[index].id,
                                animeImg: topair[index].url,
                                animeTitle: topair[index].title,
                                animeUrl: "null",
                                status: "null",
                                subOrDub: "null"))));
                  },
                  child: Container(
                    height: 200,
                    margin: EdgeInsets.all(5),
                    padding: EdgeInsets.all(8),
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(10),
                        image: DecorationImage(
                          fit: BoxFit.cover,
                          opacity: 0.09,
                          colorFilter: const ColorFilter.srgbToLinearGamma(),
                          scale: 1.5,
                          image: NetworkImage(topair[index].url),
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
                          borderRadius: BorderRadius.circular(10.0),
                          child: Image.network(
                            topair[index].url,
                            height: 400,
                            errorBuilder: (context, error, stackTrace) {
                              return Container(
                                  color: Colors.amber,
                                  alignment: Alignment.center,
                                  child: const Text(
                                    'Whoops!',
                                    style: TextStyle(fontSize: 30),
                                  ));
                            },
                          ),
                        ),
                        Expanded(
                            child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Container(
                              // decoration: BoxDecoration(border: Border.all(width: 10, color: Colors.black)),
                              padding: const EdgeInsets.only(left: 10),
                              width: 200,
                              child: Text(
                                topair[index].title != ""
                                    ? topair[index].title
                                    : topair[index].id,
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
                              margin: EdgeInsets.only(top: 10, left: 10),
                              child: Text(
                                topair[index]
                                    .geners
                                    .replaceAll(RegExp(r'[\[\]]'), ""),
                                style: const TextStyle(
                                    fontSize: 15,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.green),
                                overflow: TextOverflow.ellipsis,
                                maxLines: 3,
                              ),
                            )
                          ],
                        ))
                      ],
                    ),
                  ),
                );
              },
            )
          : const Center(
              child: CircularProgressIndicator(),
            ),
    ));
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
  }
}
