import 'package:dart_rss/domain/rss_feed.dart';
import 'package:http/http.dart' as http;

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