import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:multiple_screens/multiple_screens.dart';
import 'package:rss_book/region/feed/molecules/book_page.dart';

// https://stackoverflow.com/questions/51640388/flutter-textpainter-vs-paragraph-for-drawing-book-page
class FeedPage extends StatefulWidget {
  @override
  _FeedPageState createState() => _FeedPageState();
}

class _FeedPageState extends State<FeedPage> {
  // Method channel
  final _duoPlatform = const MethodChannel('duosdk.microsoft.dev');

  // Determines if the app runs on a Duo.
  bool _isDuo = false;

  // Determines if the app runs on a Duo and is
  // spanned.
  bool _isDuoSpanned = false;

  // Gets the actual hinge size.
  double _hingeSize = 0.0;

  @override
  void initState() {
    super.initState();

    // Listen to changes.
    MultipleScreensMethods.isAppSpannedStream().listen(
      (data) => setState(() => _isDuoSpanned = data),
    );

    // Check if it is a Duo.
    // If yes, set e.g. hinge size.
    _checkForDuo();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: EdgeInsets.fromLTRB(20, 40, 20, 20),
        child: _isDuoSpanned
            ? _makeDualScreenContent()
            : _makeSingleScreenContent(),
      ),
    );
  }

  //  Builds the dual screen content.
  Widget _makeDualScreenContent() {
    return Row(
      children: [
        // Left
        Flexible(
          flex: 1,
          child: Padding(
            padding: EdgeInsets.fromLTRB(0, 0, 20, 0),
            child: BookPage(title: "Flutter + Surface Duo is awesome!", pageNumber: 1,),
          ),
        ),

        // Hinge spacer
        SizedBox(width: 40),

        // Right
        Flexible(
          flex: 1,
          child: Center(
            child: Padding(
              padding: EdgeInsets.fromLTRB(20, 0, 0, 0),
              child: BookPage(pageNumber: 2,),
            ),
          ),
        ),
      ],
    );
  }

  // Builds the single screen content.
  Widget _makeSingleScreenContent() {
    return Center(
      child: Text("Single"),
    );
  }

  void _checkForDuo() async {
    try {
      _isDuo = await MultipleScreensMethods.isMultipleScreensDevice;
      _hingeSize = await _duoPlatform.invokeMethod('gethingeSize');
    } catch (_) {
      // if we fail it is likely because we aren't on a Surface Duo
    }
  }
}