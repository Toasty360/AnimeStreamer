import 'package:animeapp/models/animeDetails_get.dart';
import 'package:flutter/material.dart';

import '../models/anime.dart';
import '../models/animeApi.dart';
import '../models/animeDetails.dart';
import 'animeDetailsContainer.dart';
import 'package:get/get.dart';

class AnimeCard extends StatelessWidget {
  late Anime item;

  static List<Anime> mylist = [];
  static List duplicateFilter = [];

  // static List<Anime> getMylist() => mylist;

  // static List getanimeTitles() => duplicateFilter;

  AnimeCard(this.item, {super.key});

  @override
  Widget build(BuildContext context) {
    AnimeDetails? _temp;
    return Container(
      margin: const EdgeInsets.only(bottom: 10),
      // decoration: BoxDecoration(
      //   borderRadius: BorderRadius.circular(10),
      //   gradient: LinearGradient(
      //     begin: Alignment.topLeft,
      //     end: Alignment.bottomRight,
      //     colors: [
      //       Colors.blue.shade200,
      //       Colors.blue.shade300,
      //       Colors.blue.shade500,
      //       Colors.blue.shade600,
      //     ],
      //   ),
      // ),
      decoration: BoxDecoration(
        border: Border.all(width: 1, color: Colors.white70),
          borderRadius: BorderRadius.circular(10),
          image: DecorationImage(
            fit: BoxFit.cover,
            opacity: 0.09,
            colorFilter: const ColorFilter.srgbToLinearGamma(),
            scale: 1.5,
            image: NetworkImage(item.animeImg!),
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
      child: InkWell(
        onTap: () async {
          // print("before api call");
          // item=Anime.toAnime([animeId, animeTitle, animeUrl, animeImg, status]);
          // _temp = await AnimeApi.getAnime(item.animeId ?? "");
          // print(_temp);
          // ignore: use_build_context_synchronously
          Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (context) => AnimeDetailsContainer(
                      {"id": item.animeId!, "title": item.animeTitle!})));
          // print("after navi");
        },
        child: Row(children: [
          Container(
            padding: const EdgeInsets.fromLTRB(10, 10, 0, 10),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(10),
            ),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(10.0),
              child: Image.network(
                item.animeImg!,
                width: 100,
              ),
            ),
          ),
          Container(
            padding: const EdgeInsets.all(20),
            margin: const EdgeInsets.only(left: 0),
            decoration: const BoxDecoration(),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              // textDirection: TextDirection.ltr,
              children: [
                SizedBox(
                    width: 150,
                    child: Text(
                      item.animeTitle!,
                      textAlign: TextAlign.center,
                      style: const TextStyle(
                          fontSize: 18,
                          color: Colors.amberAccent,
                          fontWeight: FontWeight.bold),
                      overflow: TextOverflow.clip,
                      // maxLines: 2,
                    )),
                const Divider(
                  height: 2,
                ),
                SizedBox(
                    width: 150,
                    child: Text(
                      item.status!,
                      textAlign: TextAlign.center,
                      style: const TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.bold,
                          color: Colors.green),
                      overflow: TextOverflow.clip,
                      maxLines: 2,
                    )),
                const Divider(),
                Container(
                    alignment: Alignment.centerRight,
                    width: 100,
                    decoration: const BoxDecoration(
                        // border: Border.all(width: 2)
                        ),
                    child: ElevatedButton(
                        child: const Icon(Icons.add),
                        onPressed: () async {
                          AnimeDataController animegetcont = Get.find();
                          animegetcont.addItemToList(item);
                          print("length at animeCard after adding the item");
                          print(animegetcont.x.length);
                          // if (!duplicateFilter.contains(item.animeId)) {
                          //   mylist.insert(0, item);
                          //   duplicateFilter.add(item.animeId);
                          //   ScaffoldMessenger.of(context).showSnackBar(
                          //       const SnackBar(
                          //           backgroundColor: Color(0xff1e88e5),
                          //           content: Center(
                          //               child: Text(
                          //                   'Anime added to your list :)'))));
                          // } else {
                          //   ScaffoldMessenger.of(context).showSnackBar(
                          //       const SnackBar(
                          //           backgroundColor: Color(0xff1e88e5),
                          //           content: Center(
                          //               child: Text(
                          //                   'Duplicates can\'t be added :('))));
                          // }
                        }))
              ],
            ),
          ),
        ]),
      ),
    );
  }
}
