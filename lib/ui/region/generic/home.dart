import 'package:dotted_line/dotted_line.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:rss_book/ui/region/feed/feed_page.dart';
import 'package:dart_rss/dart_rss.dart';
import 'package:rss_book/ui/styles/styles.dart';
import 'package:http/http.dart' as http;

class Home extends StatefulWidget {
  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  // Private properties

  List<Feed> _feeds = [
    Feed("https://www.drwindows.de/news/feed"),
  ];

  @override
  void initState() {
    // Load ech feed.
    _feeds.forEach((element) {
      element.load();
    });

    // Call super init.
    super.initState();
  }

  // - Overrides -

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: FutureBuilder(
        // Initialize FlutterFire:
        future: _feeds[0].load(),
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
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Title.
        Text(
          "The Feed's Book",
          style: GoogleFonts.goudyBookletter1911(
              fontSize: 42, fontWeight: FontWeight.w900),
        ),

        // Sub title.
        Text(
          "Read your feeds in a classic manor using your Surface Duo.",
          style: GoogleFonts.goudyBookletter1911(
            textStyle: Theme.of(context).textTheme.subtitle1,
            fontSize: 21,
            fontStyle: FontStyle.italic,
          ),
        ),
      ],
    );
  }

  Widget _makeBody() {
    return Padding(
      padding: EdgeInsets.fromLTRB(20, 40, 20, 20),
      child: Column(
        children: [
          // Title.
          _makeTitle(),

          // Table of content.
          // Expands.
          _makeList(),

          // Footer.
          _makeFooter()
        ],
      ),
    );
  }

  Widget _makeFooter() {
    return Text("Made with Flutter and <3.",
        style: GoogleFonts.goudyBookletter1911(), textAlign: TextAlign.center);
  }

  Widget _makeList() {
    return Expanded(
      child: ListView.builder(
        itemCount: _feeds.length,
        itemBuilder: (context, position) {
          return _makeFeedListItem(_feeds[position]);
        },
      ),
    );
  }

  Widget _makeFeedListItem(Feed feed) {
    List<Widget> articleWidgets = [];

    feed.data.items.forEach((element) {
      articleWidgets.add(_makeArticleListItem(element));
    });

    return Column(
      children: [
        // Feed title
        Row(
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            Text(
              "${feed.data.title} - ${feed.data.description} ",
              style: GoogleFonts.goudyBookletter1911(
                fontSize: 16,
                fontWeight: FontWeight.w600,
                textStyle: TextStyle(fontStyle: FontStyle.italic),
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
            Text('( ${feed.data.items.length} )',
                style: GoogleFonts.goudyBookletter1911()),
          ],
        ),

        // Feed items
        Column(
          children: articleWidgets,
        )
      ],
    );
  }

  Widget _makeArticleListItem(RssItem item) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(12, 4, 0, 4),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          Text(
              "${item.title.substring(0,25)}",
              maxLines: 3,
              softWrap: true,
              style: GoogleFonts.goudyBookletter1911(
                textStyle: TextStyle(fontStyle: FontStyle.italic),
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
        ],
      ),
    );
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
