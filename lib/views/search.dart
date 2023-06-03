import 'dart:async';

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
  var page = 1;
  bool goterror = false;
  bool isLoading = true;
  bool isDataNew = false;
  // var previousSearch="";
  // var currentSearch="";
  Future<void> getAnime(var value) async {
    if (isDataNew) {
      page = 1;
      isDataNew = false;
    }
    print(page);
    var _temp = await AnimeApi.getanimeList(value.toString(), page);
    page++;

    print(_temp.isEmpty);
    if (_temp.isEmpty) {
      setState(() {
        goterror = true;
      });
    } else {
      isLoading = false;

      setState(() {
        print("before if");
        if (data.isEmpty) {
          data = _temp;
        } else {
          data.addAll(_temp);
          data = data.toSet().toList();
        }
        print("after if");
      });
      print("ig data updated");
    }
    // print(data);
    // print(data.isEmpty);
    // print(_temp.isEmpty);
  }

  Widget loader = const Center(
    child: Text("Nothing to see here", style: TextStyle(color: Colors.white)),
  );

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: NotificationListener<ScrollNotification>(
        onNotification: (notification) {
          // print(data.isNotEmpty);
          // print(isLoading);
          if (notification.metrics.pixels ==
                  notification.metrics.maxScrollExtent &&
              _controller.text.isNotEmpty &&
              data.isNotEmpty &&
              !isLoading) {
            isLoading = true;
            getAnime(_controller.text);
            // setState(() {});
            // ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
            //   content: Text("Fetching more data"),
            //   duration: Duration(milliseconds: 50),
            // ));
            print("called the data");
          }
          return true;
        },
        child: Container(
            color: const Color(0xFF17203A),
            padding: const EdgeInsets.fromLTRB(10, 40, 10, 0),
            child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  TextField(
                    style: const TextStyle(color: Colors.white),
                    controller: _controller,
                    decoration: InputDecoration(
                        border: const UnderlineInputBorder(),
                        hintText: "Search",
                        fillColor: Colors.white,
                        hintStyle: const TextStyle(color: Colors.white),
                        suffixIcon: IconButton(
                          icon: const Icon(Icons.cancel, color: Colors.white),
                          onPressed: () {
                            _controller.clear();
                          },
                        )),
                    onSubmitted: (String value) async {
                      data = [];
                      loader = Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: const [
                            CircularProgressIndicator(),
                            SizedBox(
                              height: 20,
                            ),
                            Text(
                              "Please wait fetching the anime!",
                              style: TextStyle(color: Colors.white),
                            ),
                          ]);
                      setState(() {});
                      isDataNew = true;
                      getAnime(_controller.text);
                    },
                  ),
                  Expanded(
                    child: data.isEmpty
                        ? goterror
                            ? const Center(
                                child: Text("Nothing to see here",
                                    style: TextStyle(color: Colors.white)),
                              )
                            : Center(
                                child: loader,
                              )
                        : ListView.builder(
                            itemCount: data.length,
                            itemBuilder: (context, index) {
                              return AnimeCard(data[index]);
                            }),
                  ),
                ])),
      ),
      // floatingActionButton: FloatingActionButton(
      //     onPressed: () {
      //       if (_controller.text.isNotEmpty) {
      //         page++;
      //         getAnime(_controller.text);
      //         ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
      //           content: Text("Fetching more data"),
      //           duration: Duration(milliseconds: 50),
      //         ));
      //       }
      //     },
      //     child: const Icon(Icons.add_to_photos_outlined)),
    );
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
  }
}
