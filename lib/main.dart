import 'package:flutter/material.dart';
// import 'package:docs/pages/choose_location.dart';
import 'package:docs/pages/home.dart';
// import 'package:docs/pages/loading.dart';

void main() {
  runApp(MaterialApp(
    initialRoute: '/home',
    routes: {
      // '/': (context) => Loading(),
      '/home': (context) => Home(),
    },
  ));
}

