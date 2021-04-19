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
    Feed("https://www.drwindows.de/news/feed", "Dr. Windows"),
  ];

  @override
  void initState() {

    _feeds.forEach((element) { element.load(); });

    super.initState();
  }

  // - Overrides -

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
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
      ),
    );
  }

  // - Helper -

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

  Widget _makeFooter() {
    return Text("Made with Flutter and <3.",
        style: GoogleFonts.goudyBookletter1911(), textAlign: TextAlign.center);
  }

  Widget _makeList() {
    return Expanded(
      child: ListView.builder(
        itemCount: _feeds.length,
        itemBuilder: (context, position) {
          return _makeListItem(_feeds[position]);
        },
      ),
    );
  }

  Widget _makeListItem(Feed feed) {
    return TextButton(
      style: ButtonStyle(
          foregroundColor: MaterialStateProperty.all(Colors.black87)),
      onPressed: () {
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) {
            return FeedPage(
              item: null,
            );
          }),
        );
      },
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          Text(
            feed.name,
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
          Text('( 8 )', style: GoogleFonts.goudyBookletter1911()),
        ],
      ),
    );
  }
}

class Feed {
  // - Properties -

  final String url;
  final String name;
  List<FeedItem> items = [];

  // - Init -

  Feed(this.url, this.name) : super();

  // - Helper -

  Future<void> load() async {
    var rss = await http.read(url);
    var rssFeed = new RssFeed.parse(rss);
    rssFeed.items.forEach((item) { print(item.title); });
  }
}

class FeedItem {
  final String title;
  final String url;

  // - Init -

  const FeedItem({this.title, this.url});
}
