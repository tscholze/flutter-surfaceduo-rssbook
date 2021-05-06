import 'package:dart_rss/dart_rss.dart';
import 'package:dotted_line/dotted_line.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:rss_book/models/feed.dart';
import 'package:rss_book/ui/styles/styles.dart';
import 'package:rss_book/ui/transitions/slide_left_route.dart';
import 'package:rss_book/ui/ui_utils.dart';
import 'package:rss_book/utils/utils.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

import 'feed_page.dart';

class Home extends StatefulWidget {
  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  // - Private properties -

  /// Hardcoded list of feeds that will be fetched.
  List<Feed> _feeds = [
    Feed("https://thesurfaceguide.com/feed/"),
    Feed("https://www.drwindows.de/news/feed"),
    Feed("https://tscholze.uber.space/feed"),
  ];

  // - Overrides -

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: FutureBuilder(
        future:
            Future.wait([_feeds[0].load(), _feeds[1].load(), _feeds[2].load()]),
        builder: (context, snapshot) {
          // 1. Handle errors.
          if (snapshot.hasError) {
            return _makeErrorText(snapshot.error);
          }

          // 2. Check if futures has been completed.
          if (snapshot.connectionState == ConnectionState.done) {
            return _makeBody();
          }

          // Otherwise, show loading indicator.
          return _makeProgressIndicator();
        },
      ),
    );
  }

  // - Helper -

  Widget _makeErrorText(Error error) {
    return Center(
      child: Text(error.toString()),
    );
  }

  Widget _makeProgressIndicator() {
    return Center(
      child: CircularProgressIndicator(
        valueColor: new AlwaysStoppedAnimation<Color>(Colors.black87),
      ),
    );
  }

  Widget _makeTitle() {
    return Column(
      children: [
        // Title.
        Text(
          "The Feed's Book",
          style: titleStyle,
        ),

        // Sub title.
        Text(
          "Read your feeds in a classic manor.",
          style: subtitleStyle,
        ),
        Padding(
          padding: EdgeInsets.fromLTRB(0, 8, 0, 0),
          child: makeDottedLine(),
        )
      ],
    );
  }

  Widget _makeBody() {
    return Column(
      children: [
        ConstrainedBox(
          constraints: BoxConstraints(
              maxHeight: MediaQuery.of(context).size.height - 55),
          child: SingleChildScrollView(
            child: Padding(
              padding: EdgeInsets.fromLTRB(20, 40, 20, 0),
              child: Column(
                children: [
                  // Title.
                  _makeTitle(),

                  // Table of content.
                  // Expands.
                  _makeList(),
                ],
              ),
            ),
          ),
        ),
        // Bottom
        _makeBottom(
          context,
        ),
      ],
    );
  }

  Widget _makeBottom(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(20, 10, 20, 0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Top dotted border
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: makeDottedLine(),
          ),

          // Bottom  back button
          Row(
            children: [
              // Left button
              InkWell(
                onTap: () {
                  Navigator.pop(context);
                },
                child: Row(
                  children: [
                    Row(
                      children: [
                        Icon(
                          FontAwesomeIcons.microsoft,
                          size: 12,
                        ),
                        Padding(
                          padding: const EdgeInsets.fromLTRB(4, 0, 0, 0),
                          child: Text(
                            "Made with Flutter for Surface Duo",
                            style: body1Style,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),

              // Middle Spacer
              Spacer(),

              // Right button
              InkWell(
                onTap: () {
                  launchURL(
                      "https://github.com/tscholze/flutter-surfaceduo-rssbook");
                },
                child: Row(
                  children: [
                    Row(
                      children: [
                        Padding(
                          padding: const EdgeInsets.fromLTRB(0, 0, 4, 0),
                          child: Text(
                            "Visit on GitHub",
                            style: body1Style,
                          ),
                        ),
                        Icon(
                          FontAwesomeIcons.github,
                          size: 12,
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          )
        ],
      ),
    );
  }

  Widget _makeList() {
    List<Widget> items = [];
    _feeds.forEach((element) {
      items.add(_makeFeedListItem(element));
    });

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 16),
      child: Column(
        children: items,
      ),
    );
  }

  Widget _makeFeedListItem(Feed feed) {
    List<Widget> articleWidgets = [];

    feed.data.items.forEach((element) {
      articleWidgets.add(_makeArticleListItem(element));
    });

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Column(
        children: [
          // Feed title
          _makeFeedTitle(feed),

          // Feed items
          Column(
            children: articleWidgets,
          )
        ],
      ),
    );
  }

  /// Creates a feed title widget based on given [feed].
  Widget _makeFeedTitle(Feed feed) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.end,
      children: [
        Container(
          width: MediaQuery.of(context).size.width - 80,
          child: Text(
            "${feed.data.title} - ${feed.data.description}",
            overflow: TextOverflow.clip,
            style: GoogleFonts.goudyBookletter1911(
              fontSize: 16,
              fontWeight: FontWeight.w600,
              textStyle: TextStyle(fontStyle: FontStyle.italic),
            ),
          ),
        ),
        Expanded(
          child: Padding(
            padding: EdgeInsets.fromLTRB(8, 0, 8, 4),
            child: makeDottedLine(),
          ),
        ),
        Text(
          '( ${feed.data.items.length} )',
          style: GoogleFonts.goudyBookletter1911(
            fontSize: 16,
            fontWeight: FontWeight.w600,
            textStyle: TextStyle(fontStyle: FontStyle.italic),
          ),
        ),
      ],
    );
  }

  /// Creates an article list item based on given [item].
  Widget _makeArticleListItem(RssItem item) {
    return InkWell(
      onTap: () {
        Navigator.push(
          context,
          SlideLeftRoute(
            page: FeedPage(item: item),
          ),
        );
      },
      child: Padding(
        padding: const EdgeInsets.fromLTRB(12, 4, 0, 4),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            // Title
            ConstrainedBox(
              constraints: BoxConstraints(
                maxWidth: MediaQuery.of(context).size.width * 0.75,
              ),
              child: Text(
                "${item.title}",
                maxLines: 1,
                overflow: TextOverflow.clip,
                style: GoogleFonts.goudyBookletter1911(
                  textStyle: TextStyle(fontStyle: FontStyle.italic),
                ),
              ),
            ),

            // Line
            Expanded(
              child: Padding(
                padding: EdgeInsets.fromLTRB(8, 0, 8, 4),
                child: makeDottedLine(),
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _showToast(BuildContext context) {
    ScaffoldMessenger.of(context)
        .showSnackBar(SnackBar(content: Center(child: Text("TEST"))));
  }
}
