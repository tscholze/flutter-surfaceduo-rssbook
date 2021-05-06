import 'package:dart_rss/dart_rss.dart';
import 'package:dotted_line/dotted_line.dart';
import 'package:flutter/material.dart';
import 'package:rss_book/ui/region/feed/feed_page.dart';
import 'package:rss_book/ui/region/feed/molecules/text_column.dart';
import 'package:rss_book/ui/styles/styles.dart';
import 'package:rss_book/utils/utils.dart';

class BookPage extends StatelessWidget {
  // - Static properties -

  static const maxLinesOnlyText = 27;
  static const maxLinesWithTitle = 25;

  // - Final fields -

  final RssItem item;
  final bool isDuo;
  final bool isSpanned;

  // - Init -

  const BookPage({this.item, this.isDuo, this.isSpanned}) : super();

  // - Overriders -

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Textual content
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Optional header.
            _makeTitleIfRequired(),

            // Content
            isDuo ? _makeDuoContent(context) : _makeNonDuoContent()
          ],
        ),

        // Footer / Bottom
        _makeBottom(context),
      ],
    );
  }

  // - Private helper -

  Widget _makeTitleIfRequired() {
    // If `title`  is null, do not show a label.
    if (item.title == null) return SizedBox(width: 0, height: 0);

    // Else wise, show a title label with a spacer.
    return Column(
      children: [
        // Title
        Text(
            item.title,
            textAlign: TextAlign.left,
            maxLines: 2,
            style: titleStyle,
        ),

        // Spacer
        SizedBox(
          width: 0,
          height: 20,
        )
      ],
    );
  }

  Widget _makeDuoContent(BuildContext context) {
    return Row(
      children: [
        // Left column
        SizedBox(
          width: MediaQuery.of(context).size.width / _getDivider() - 50,
          child: TextColumn(
            text: removeAllHtmlTags(item.content.value),
          ),
        ),

        // Spacer between columns
        SizedBox(
          width: 40,
        ),

        // Right column
        SizedBox(
          width: MediaQuery.of(context).size.width / _getDivider() - 50,
          child: TextColumn(
            text: removeAllHtmlTags(item.content.value),
          ),
        )
      ],
    );
  }

  Widget _makeNonDuoContent() {
    return TextColumn(
      text: removeAllHtmlTags(item.content.value),
    );
  }

  Widget _makeBottom(BuildContext context) {
    return Column(
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
            InkWell(
              onTap: () {
                Navigator.pop(context);
              },
              child: Text(
                "< Tap to go back",
                style: body1Style,
              ),
            ),

            // Spacer.
            Spacer(),

            // Right button.
            InkWell(
              onTap: () {
                launchURL(item.link);
              },
              child: Text(
                "Open post in browser",
                style: body1Style,
              ),
            ),
          ],
        )
      ],
    );
  }

  int _getDivider() {
    return isSpanned ? 4 : 2;
  }
}
