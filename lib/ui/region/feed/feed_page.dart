import 'package:dart_rss/dart_rss.dart';
import 'package:dotted_line/dotted_line.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:multiple_screens/multiple_screens.dart';
import 'package:rss_book/ui/region/feed/molecules/book_page.dart';
import 'package:rss_book/ui/styles/styles.dart';
import 'package:rss_book/utils/utils.dart';

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
        child: Column(
          children: [
            ConstrainedBox(
              constraints: BoxConstraints(
                maxHeight: MediaQuery.of(context).size.height - 55,
              ),
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
            _makeBottom(context),
          ],
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

  Widget _makeBottom(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 8),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Top dotted border
          Padding(
            padding: const EdgeInsets.fromLTRB(0, 0, 0, 8),
            child: DottedLine(
              dashLength: 1,
              dashGapLength: 3,
              lineThickness: 1,
              dashColor: Colors.blueGrey,
            ),
          ),

          // Bottom  back button
          Row(
            children: [
              // Left button.
              // Show only when spanned.
              _isSpanned
                  ? SizedBox(width: 0, height: 0)
                  : InkWell(
                      onTap: () {
                        Navigator.pop(context);
                      },
                      child: Row(
                        children: [
                          Padding(
                            padding: const EdgeInsets.fromLTRB(0, 0, 4, 0),
                            child: FaIcon(
                              FontAwesomeIcons.chevronLeft,
                              size: 10,
                              color: Colors.black87,
                            ),
                          ),
                          Text(
                            "Tap to go back",
                            style: body1Style,
                          ),
                        ],
                      ),
                    ),
              // Spacer.
              Spacer(),

              // Right button.
              InkWell(
                onTap: () {
                  launchURL(widget.item.link);
                },
                child: Row(
                  children: [
                    Text(
                      "Open post in browser",
                      style: body1Style,
                    ),
                    Padding(
                      padding: EdgeInsets.fromLTRB(4, 0, 0, 0),
                      child: FaIcon(
                        FontAwesomeIcons.edge,
                        size: 12,
                        color: Colors.black87,
                      ),
                    )
                  ],
                ),
              ),
            ],
          )
        ],
      ),
    );
  }
}
