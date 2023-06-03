import 'package:animeapp/models/anime.dart';
import 'package:flutter/material.dart';
import 'animeDetailsContainer.dart';

class Cards extends StatelessWidget {
  late Anime item;
  Cards(this.item);
  @override
  Widget build(BuildContext context) {
    return Container(
        margin: const EdgeInsets.all(10),
        decoration: BoxDecoration(
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
          ),
        ),
        child: InkWell(
          onTap: () {
            // ignore: use_build_context_synchronously
            Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) => AnimeDetailsContainer(
                        {"id": item.animeId!, "title": item.animeTitle!})));
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
                  errorBuilder: (context, error, stackTrace) {
                    return Container(
                        color: Colors.amber,
                        alignment: Alignment.center,
                        child: const Text(
                          'Whoops!',
                          style: TextStyle(fontSize: 10),
                        ));
                  },
                ),
              ),
            ),
            Container(
                padding: const EdgeInsets.all(20),
                margin: const EdgeInsets.only(left: 0),
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
                              color: Colors.white,
                              fontWeight: FontWeight.bold),
                          overflow: TextOverflow.clip,
                          maxLines: 2,
                        ),
                      ),
                      const Divider(),
                      SizedBox(
                          width: 150,
                          child: Text(
                            item.status!,
                            textAlign: TextAlign.center,
                            style: const TextStyle(
                                fontSize: 15,
                                fontWeight: FontWeight.bold,
                                color: Colors.lightGreen),
                            overflow: TextOverflow.clip,
                            maxLines: 2,
                          )),
                    ]))
          ]),
        ));
  }
}
