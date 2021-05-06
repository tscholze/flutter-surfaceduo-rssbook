import 'package:dart_rss/dart_rss.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:multiple_screens/multiple_screens.dart';
import 'package:rss_book/ui/region/feed/molecules/book_page.dart';

class FeedPage extends StatefulWidget {
  // - Private properties -

  /// Underlying item (data source) of the widget.
  final RssItem item;

  // - Init -

  FeedPage({this.item});

  // - Overrides -

  @override
  _FeedPageState createState() => _FeedPageState();
}

class _FeedPageState extends State<FeedPage> {
  // - Private properties -

  /// Method channel
  final _duoPlatform = const MethodChannel('duosdk.microsoft.dev');

  /// Determines if the app runs on a Duo.
  bool _isDuo = false;

  /// Determines if the app is spanned.
  bool _isSpanned = false;

  // - Life cycle -

  @override
  void initState() {
    super.initState();

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
            child: BookPage(
              item: widget.item,
              isDuo: _isDuo,
              isSpanned: _isSpanned,
            ),
          ),
        ),
      ),
    );
  }

  // - Helper -

  /// Checks if app runs on a Microsoft Surface Duo
  void _checkForDuo() async {
    try {
      var tmpIsDuo = await MultipleScreensMethods.isMultipleScreensDevice;
      var tmpIsSpanned = await MultipleScreensMethods.isAppSpanned;
      setState(() {
        _isDuo = tmpIsDuo;
        _isSpanned = tmpIsSpanned;
      });
    } catch (_) {
      setState(() {
        _isDuo = false;
      });
    }
  }
}
