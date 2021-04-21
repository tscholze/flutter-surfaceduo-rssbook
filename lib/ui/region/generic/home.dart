import 'package:dart_rss/dart_rss.dart';
import 'package:dotted_line/dotted_line.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:http/http.dart' as http;

import '../feed/feed_page.dart';

class Home extends StatefulWidget {
  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  // Private properties

  List<Feed> _feeds = [
    Feed("https://www.drwindows.de/news/feed"),
    Feed("https://www.drwindows.de/news/feed"),
    Feed("https://www.drwindows.de/news/feed"),
  ];

  @override
  void initState() {
    // Call super init.
    super.initState();
  }

  // - Overrides -

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: FutureBuilder(
        // Initialize FlutterFire:
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
          style: GoogleFonts.goudyBookletter1911(
              fontSize: 36, fontWeight: FontWeight.w900),
        ),

        // Sub title.
        Text(
          "Read your feeds in a classic manor.",
          style: GoogleFonts.goudyBookletter1911(
            textStyle: Theme.of(context).textTheme.subtitle1,
            fontSize: 21,
            fontStyle: FontStyle.italic,
          ),
        ),
        Padding(
          padding: EdgeInsets.fromLTRB(0, 8, 0, 0),
          child: _makeDottedLine(),
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
              padding: EdgeInsets.fromLTRB(20, 40, 20, 20),
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

        // Footer.
        _makeFooter()
      ],
    );
  }

  Widget _makeFooter() {
    return Column(
      children: [
        Padding(
          padding: EdgeInsets.symmetric(vertical: 8),
          child: _makeDottedLine(),
        ),
        RichText(
          text: new TextSpan(
            style: GoogleFonts.goudyBookletter1911(color: Colors.grey),
            children: <TextSpan>[
              new TextSpan(text: 'Made with Flutter and '),
              new TextSpan(text: '❤', style: new TextStyle(fontSize: 8)),
            ],
          ),
        ),
      ],
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

  Widget _makeFeedTitle(Feed feed) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.end,
      children: [
        Container(
          width: MediaQuery.of(context).size.width - 75,
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
            child: DottedLine(
                dashLength: 1,
                dashGapLength: 3,
                lineThickness: 1,
                dashColor: Colors.blueGrey),
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
                child: _makeDottedLine(),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _makeDottedLine() {
    return DottedLine(
        dashLength: 1,
        dashGapLength: 3,
        lineThickness: 1,
        dashColor: Colors.blueGrey);
  }
}

class Feed {
  // - Properties -

  final String url;
  RssFeed data;

  // - Init -

  Feed(this.url) : super();

  // - Helper -

  Future<void> load() async {
    var rss = await http.read(url);
    data = new RssFeed.parse(rss);
  }
}

class SlideLeftRoute extends PageRouteBuilder {
  final Widget page;
  SlideLeftRoute({this.page})
      : super(
          pageBuilder: (
            BuildContext context,
            Animation<double> animation,
            Animation<double> secondaryAnimation,
          ) =>
              page,
          transitionsBuilder: (
            BuildContext context,
            Animation<double> animation,
            Animation<double> secondaryAnimation,
            Widget child,
          ) =>
              SlideTransition(
            position: Tween<Offset>(
              begin: const Offset(1, 0),
              end: Offset.zero,
            ).animate(animation),
            child: child,
          ),
        );
}
