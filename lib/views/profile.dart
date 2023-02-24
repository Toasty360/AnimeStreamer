import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:http/http.dart';
import 'package:path_provider/path_provider.dart';
import 'package:url_launcher/url_launcher.dart';

import '../models/anime.dart';
import '../models/animeDetails.dart';
import 'createloginpin.dart';

class Profile extends StatefulWidget {
  List<Anime> mylist;
  Profile(this.mylist);

  @override
  _ProfileState createState() => _ProfileState();
}

class _ProfileState extends State<Profile> {
  var compCount;
  var ongCount;
  var totCount;
  List<Anime>? popularAnimeList;

  Future<String> get _localPath async {
    final directory = await getApplicationDocumentsDirectory();
    return directory.path;
  }

  Future<File> get _localFile async {
    final path = await _localPath;
    return File('$path/watchlist.txt');
  }

  Future<File> get _localFileForPin async {
    final path = await _localPath;
    return File('$path/Pin.txt');
  }

  Future<File> createPin(String pin) async {
    final file = await _localFileForPin;
    return file.writeAsString(pin);
  }

  Future<Future<FileSystemEntity>> clearData() async {
    final file = await _localFile;
    print("i hope i deleted the data");
    return file.writeAsString("");
  }

  Future<List?> fetchData() async {
    try {
      final file = await _localFile;
      final contents = await file.readAsString();
      return jsonDecode(contents);
    } catch (e) {
      return null;
    }
  }

  @override
  initState() {
    super.initState();
    var _temp = 0;
    totCount = 0;
    compCount = 0;
    ongCount = 0;
    if (widget.mylist != null) {
      for (Anime anime in widget.mylist) {
        _temp += anime.status == 'Completed' ? 1 : 0;
        print(anime.status);
      }
      setState(() {
        totCount = widget.mylist.length;
        compCount = _temp;
        ongCount = widget.mylist.length - _temp;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Center(
        child: ListView(
      children: [
        Container(
          height: 200,
          margin: const EdgeInsets.all(20),
          padding: const EdgeInsets.all(20),
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
                  blurRadius: 20,
                  spreadRadius: 1),
            ],
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
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Center(
                  child: Text(
                "Human",
                style: TextStyle(
                    fontSize: 25,
                    color: Colors.amber,
                    fontWeight: FontWeight.bold),
              )),
              const Center(
                child: Text("Weeb",
                    style: TextStyle(color: Colors.white, height: 2)),
              ),
              const Divider(thickness: 2),
              Expanded(child: 
                Column(
                      children: [
                        const Text("WatchList Count",style: TextStyle(fontSize: 20, color: Colors.white)),
                        Text(totCount.toString(),
                            style:
                                const TextStyle(height: 2, color: Color.fromARGB(255, 8, 66, 12), fontSize: 18))
                      ]
              )),
              
              // Expanded(
              //   child: Row(
              //     children: [
              //       Expanded(
              //           child: Column(
              //         children: [
              //           const Text("Total"),
              //           Text(totCount.toString(),
              //               style:
              //                   const TextStyle(height: 2, color: Colors.black))
              //         ],
              //       )),
              //       Expanded(
              //           child: Column(
              //         children: [
              //           const Text("Completed"),
              //           Text(compCount.toString(),
              //               style:
              //                   const TextStyle(height: 2, color: Colors.black))
              //         ],
              //       )),
              //       Expanded(
              //           child: Column(
              //         children: [
              //           const Text("Ongoing"),
              //           Text(ongCount.toString(),
              //               style: TextStyle(
              //                   height: 2, color: Colors.orange.shade400))
              //         ],
              //       ))
                  // ],
              //   ),
              // ),
            ],
          ),
        ),
        TextButton(
            onPressed: () {
              Navigator.push(context,
                  MaterialPageRoute(builder: (context) => const CreatePinPage()));
            },
            child: const Text("Click here to update Pin")),
      ]
    ));
  }
}

 // TextButton(
        //     onPressed: () {
        //       setState(() {
        //         clearData();
        //       });
        //       print(totCount);
        //       ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
        //           backgroundColor: Color(0xff1e88e5),
        //           content: Center(
        //               child: Text(
        //                   'Restart the application to see the changes!'))));
        //     },
        //     child: const Text("Click here to remove data :(")),
