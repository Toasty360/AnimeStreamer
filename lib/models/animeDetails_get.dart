import 'dart:convert';
import 'dart:io';

import 'package:animeapp/models/anime.dart';
import 'package:get/get.dart';
import 'package:path_provider/path_provider.dart';

class AnimeDataController extends GetxController {
  List<Anime> _savedList = [];

  List<Anime> get x => _savedList;

  AnimeDataController() {
    getInitialData();
  }

  //loads the data from the local file
  //it happens only once
  void getInitialData() async {
    _savedList = await readLocalWatchList();
  }

  void setData(List<Anime> newList) {
    _savedList = newList;
    writeWatchlistToFile();
  }

  void removeAt(int i) {
    _savedList.removeAt(i);
    writeWatchlistToFile();
  }

  void addItemToList(Anime item) {
    _savedList.add(item);
    _savedList = _savedList.toSet().toList();
    writeWatchlistToFile();
    update();
  }

  Future<String> get _localPath async {
    final directory = await getApplicationDocumentsDirectory();

    return directory.path;
  }

  Future<File> get _localFile async {
    final path = await _localPath;
    return File('$path/watchlist.txt');
  }

  Future<List<Anime>> readLocalWatchList() async {
    final file = await _localFile;
    final contents = await file.readAsString();
    List _list = jsonDecode(contents);
    _list = _list.map((e) => Anime.toAnime(e)).toList();
    // print(_list);
    return _list as List<Anime>;
  }

  Future<File> writeWatchlistToFile() async {
    print("data length will return in file ${_savedList.length}");
    String jsonData =
        jsonEncode(_savedList.map((e) => Anime.toJson(e)).toList());

    final file = await _localFile;
    return file.writeAsString(jsonData);
  }
}
