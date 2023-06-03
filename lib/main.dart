// ignore: unused_import
import 'dart:ui';

import 'package:animeapp/views/splash.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
void main(List<String> args) {
  runApp(GetMaterialApp(
    theme: ThemeData(fontFamily: 'Open_Sans'),
    debugShowCheckedModeBanner: false,
    initialRoute: '/home',
    routes: {
      '/home': (context) => Splash(),
    },
  ));
}

