import 'package:flutter/material.dart';
import 'package:rss_book/ui/region/generic/home.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'RSSBook - für dein Surface Duo',
      theme: ThemeData(
        primarySwatch: Colors.orange,
        accentColor: Colors.black,
        accentColorBrightness: Brightness.dark,
      ),
      home: Home(),
    );
  }
}