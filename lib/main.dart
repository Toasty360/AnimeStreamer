import 'package:animeapp/views/home.dart';
import 'package:flutter/material.dart';

import 'views/Login.dart';
import 'views/createloginpin.dart';

void main(List<String> args) {
  runApp(MaterialApp(
    theme: ThemeData(fontFamily: 'Open_Sans'),

    debugShowCheckedModeBanner: false,
    initialRoute: '/loginPage',
    routes: {
      '/loginPage': (context) => const Login(),
      '/home':(context) => const Home(),
      '/createpinpage': (context) => const CreatePinPage(),
    },
  ));
}