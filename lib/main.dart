import 'KnattraHomePage.dart';
import 'package:flutter/material.dart';

void main() {
  runApp(new KnattraApp());
}

class KnattraApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Knattra Treasure Hunt',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: KnattraHomePage(),
    );
  }
}


