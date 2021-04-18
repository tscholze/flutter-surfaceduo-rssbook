import 'package:flutter/material.dart';
import 'package:rss_book/region/feed/feed_page.dart';

import 'package:rss_book/region/generic/molecules/app_footer.dart';

import 'molecules/app_title.dart';

class Home extends StatefulWidget {
  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: EdgeInsets.fromLTRB(20, 40, 20, 20),
        child: Column(
          children: [
            // Header.
            AppTitle(),

            TextButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) {
                      return FeedPage();
                    }),
                  );
                },
                child: Text("Tap me")),
            // Spacer.
            // To move the footer to the bottom.
            Spacer(),

            // Footer.
            AppFooter(),
          ],
        ),
      ),
    );
  }
}
