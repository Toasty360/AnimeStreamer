import 'package:flutter/material.dart';

import '../models/anime.dart';
import '../models/animeApi.dart';
import 'animecard.dart';

class search extends StatefulWidget {
  const search({super.key});

  @override
  State<search> createState() => _searchState();
}

class _searchState extends State<search> {


  static List<Anime> data = [];
  final _controller = TextEditingController();
  
  Future<void> getAnime(var value) async {
    var _temp = await AnimeApi.getanimeList(value.toString());
    setState(() {
      data = _temp;
    });
  }


  @override
  Widget build(BuildContext context) {
    return Container(
          padding: const EdgeInsets.fromLTRB(20, 50, 20, 0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              TextField(
                controller: _controller,
                decoration: InputDecoration(
                    border: const UnderlineInputBorder(),
                    hintText: "Search",
                    suffixIcon: IconButton(
                      icon: const Icon(Icons.cancel),
                      onPressed: () {
                        _controller.clear();
                      },
                    )),
                onSubmitted: (String value) async {
                  getAnime(_controller.text);
                  print("entered");
                },
              ),
              Expanded(
                  child: Container(
                child: data.isEmpty
                    ? const Center(
                        child: Text("Nothing to see here"),
                      )
                    : ListView.builder(
                        itemCount: data.length,
                        itemBuilder: (context, index) {
                          return AnimeCard(data[index]);
                        }),
              ))
            ],
          ));
  }
}