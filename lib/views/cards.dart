import 'package:animeapp/models/anime.dart';
import 'package:animeapp/models/animeApi.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import '../models/animeDetails.dart';
import 'animedetails.dart';

class Cards extends StatelessWidget {
  late Anime item;

  Cards(this.item);
  @override
  Widget build(BuildContext context) {
    AnimeDetails _temp;
    return Container(
        // margin: EdgeInsets.fromLTRB(5, 10, 5, 10),
        margin: EdgeInsets.only(top: 10),
        // padding: EdgeInsets.all(10),
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
        // decoration: BoxDecoration(
        //   color: Colors.blue,
        //   borderRadius: BorderRadius.circular(10),
        // ),
        child: Row(children: [
          Container(
            padding: const EdgeInsets.fromLTRB(10, 10, 0, 10),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(10),
            ),
            child: InkWell(
              onTap: () async {

                var itemDetails= await AnimeApi.getAnime(item.animeId??"");

                // ignore: use_build_context_synchronously
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => AnimeDetailsContainer(itemDetails)));
              },
              child: ClipRRect(
                borderRadius: BorderRadius.circular(10.0),
                child: Image.network(
                  item.animeImg!,
                  width: 100,
                ),
              ),
            ),
          ),
          Container(
              padding: EdgeInsets.all(20),
              margin: EdgeInsets.only(left: 0),
              child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  // textDirection: TextDirection.ltr,
                  children: [
                    Container(
                      width: 150,
                      child: Text(
                        item.animeTitle!,
                        textAlign: TextAlign.center,
                        style: TextStyle(fontSize: 18, color: Colors.amberAccent, fontWeight: FontWeight.bold),
                        overflow: TextOverflow.clip,
                        maxLines: 2,
                      ),
                    ),
                    Divider(),
                    Container(
                        width: 150,
                        child: Text(
                          item.status!,
                          textAlign: TextAlign.center,
                          style: TextStyle(fontSize: 15),
                          overflow: TextOverflow.clip,
                          maxLines: 2,
                        )),
                  ]))
        ]));
  }
}
