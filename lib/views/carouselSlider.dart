import 'package:animeapp/models/anime.dart';
import 'package:animeapp/views/animeDetailsContainer.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';

class CarouselContainer extends StatefulWidget {
  List<TopAnimeModel> topAnime;
  CarouselContainer({super.key, required this.topAnime});

  @override
  State<CarouselContainer> createState() => _CarouselContainerState();
}

class _CarouselContainerState extends State<CarouselContainer> {
  late List<TopAnimeModel> imgList;
  late List<Widget> imageSliders;
  bool isDataReady = false;
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    imgList = widget.topAnime;
    imageSliders = imgList
        .map((item) => GestureDetector(
              onTap: () {
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => AnimeDetailsContainer(Anime(
                            animeId: item.id,
                            animeImg: item.url,
                            animeTitle: item.title,
                            animeUrl: "null",
                            status: "null",
                            subOrDub: "null"))));
              },
              child: Container(
                child: Container(
                  // margin: const EdgeInsets.all(5.0),
                  child: ClipRRect(
                      borderRadius:
                          const BorderRadius.all(Radius.circular(5.0)),
                      child: Stack(
                        children: <Widget>[
                          Image.network(
                            item.url,
                            fit: BoxFit.cover,
                            width: 1000.0,
                            errorBuilder: (context, error, stackTrace) {
                              return Text(item.title);
                            },
                          ),
                          Positioned(
                            bottom: 0.0,
                            left: 0.0,
                            right: 0.0,
                            child: Container(
                              decoration: const BoxDecoration(
                                gradient: LinearGradient(
                                  colors: [
                                    Color.fromARGB(200, 0, 0, 0),
                                    Color.fromARGB(0, 0, 0, 0)
                                  ],
                                  begin: Alignment.bottomCenter,
                                  end: Alignment.topCenter,
                                ),
                              ),
                              padding: const EdgeInsets.symmetric(
                                  vertical: 10.0, horizontal: 20.0),
                              child: Text(
                                item.title != "" ? item.title : item.id,
                                style: const TextStyle(
                                  color: Colors.white,
                                  fontSize: 15.0,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                          ),
                        ],
                      )),
                ),
              ),
            ))
        .toList();
    if (imgList.isNotEmpty) isDataReady = true;
  }

  @override
  Widget build(BuildContext context) {
    return isDataReady
        ? Container(
            // height: 200,
            width: double.maxFinite,
            child: CarouselSlider(
              options: CarouselOptions(
                autoPlay: true,
                aspectRatio: 2.0,
                enlargeCenterPage: true,
              ),
              items: imageSliders,
            ),
          )
        : const Center();
  }
}
