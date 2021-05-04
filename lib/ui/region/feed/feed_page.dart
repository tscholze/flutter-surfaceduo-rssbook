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

  /// Determines if the app runs on a Duo and is
  /// spanned.
  bool _isDuoSpanned = false;

  /// Gets the actual hinge size.
  double _hingeSize = 0.0;

  // - Life cycle -

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
          child: _makeSingleScreenContent(widget.item),
        )),
      ),
    );
  }

  // - Helper -

  ///  Builds the dual screen content.
  Widget _makeDualScreenContent(RssItem item) {
    return Row(
      children: [
        // Left
        Flexible(
          flex: 1,
          child: Padding(
            padding: EdgeInsets.fromLTRB(0, 0, 20, 0),
            child: BookPage(
              item: item,
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
            item: item,
            isDuo: _isDuo,
          ),
        ),
      ],
    );
  }

  /// Builds the single screen content.
  Widget _makeSingleScreenContent(RssItem item) {
    return BookPage(
      item: item,
      isDuo: _isDuo,
    );
  }

  /// Checks if app runs on a Microsoft Surface Duo
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