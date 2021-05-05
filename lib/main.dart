import 'package:flutter/material.dart';
import 'package:multiple_screens/multiple_screens_methods.dart';
import 'package:rss_book/ui/region/generic/home.dart';
import 'package:rss_book/ui/region/generic/home_dualscreen.dart';

void main() {
  runApp(App());
}

class App extends StatefulWidget {
  const App({Key key}) : super(key: key);

  @override
  _AppState createState() => _AppState();
}

class _AppState extends State<App> {
  bool _isAppSpannedStream = false;

  @override
  void initState() {
    super.initState();
    MultipleScreensMethods.isAppSpannedStream().listen(
      (data) => setState(() => _isAppSpannedStream = data),
    );
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'RSSBook for Surface Duo',
      theme: ThemeData(
        primarySwatch: Colors.orange,
        accentColor: Colors.black,
        accentColorBrightness: Brightness.dark,
      ),
      home: _isAppSpannedStream ? HomeDualScreen() : Home(),
    );
  }
}
