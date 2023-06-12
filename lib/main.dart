// ignore: unused_import
import 'dart:ui';

import 'package:animeapp/views/LayoutComp.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'models/animeApi.dart';

void main(List<String> args) {
  AnimeApi().setApi();

  runApp(GetMaterialApp(
    theme: ThemeData(fontFamily: 'Open_Sans'),
    debugShowCheckedModeBanner: false,
    initialRoute: '/home',
    routes: {
      '/home': (context) => const LayoutComp(),
    },
  ));
}
