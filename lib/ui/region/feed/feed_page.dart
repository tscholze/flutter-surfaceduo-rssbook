import 'package:dart_rss/dart_rss.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:multiple_screens/multiple_screens.dart';
import 'package:rss_book/ui/region/feed/molecules/book_page.dart';

// https://stackoverflow.com/questions/51640388/flutter-textpainter-vs-paragraph-for-drawing-book-page
class FeedPage extends StatefulWidget {
  // - Private properties -
  RssItem item;

  // - Init -
  FeedPage({this.item});

  // - Overrides -

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
      body: SafeArea(
        child: SingleChildScrollView(
          child: Padding(
            padding: EdgeInsets.all(20),
            child: _makeSingleScreenContent(
            widget.item.title,
            removeAllHtmlTags(widget.item.content.value),
            4,
          ),
          ),
        ),
      ),
    );
  }

  //  Builds the dual screen content.
  Widget _makeDualScreenContent(String content) {
    return Row(
      children: [
        // Left
        Flexible(
          flex: 1,
          child: Padding(
            padding: EdgeInsets.fromLTRB(0, 0, 20, 0),
            child: BookPage(
              title: "Flutter + Surface Duo is awesome!",
              content: content,
              pageNumber: 1,
              isDuo: _isDuo,
            ),
          ),
        ),

        // Hinge spacer
        SizedBox(width: _hingeSize),

        // Right
        Flexible(
          flex: 1,
          child: BookPage(
            content: content,
            pageNumber: 2,
            isDuo: _isDuo,
          ),
        ),
      ],
    );
  }

  // Builds the single screen content.
  Widget _makeSingleScreenContent(
      String title, String content, int pageNumber) {
    return BookPage(
      title: title,
      content: content,
      pageNumber: pageNumber,
      isDuo: _isDuo,
    );
  }

  void _checkForDuo() async {
    try {
      _isDuo = await MultipleScreensMethods.isMultipleScreensDevice;
      _hingeSize = await _duoPlatform.invokeMethod('gethingeSize');
    } catch (_) {
      _isDuo = false;
      _isDuoSpanned = false;
    }
  }
}

String removeAllHtmlTags(String htmlText) {
  RegExp exp = RegExp(r"<[^>]*>", multiLine: true, caseSensitive: true);

  return htmlText.replaceAll(exp, '');
}
