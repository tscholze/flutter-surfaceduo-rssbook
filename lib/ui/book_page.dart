import 'package:dart_rss/dart_rss.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:rss_book/ui/styles/styles.dart';
import 'package:rss_book/utils/utils.dart';

class BookPage extends StatelessWidget {
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

  /// Builds the content for Duo devices.
  /// -> Large screens.
  Widget _makeDuoContent(BuildContext context) {
    var segments = _getContentSegments();

    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Left column
        SizedBox(
          width: MediaQuery.of(context).size.width / _getDivider() - 50,
          child: _makeTextColumn(segments[1]),
        ),

        // Spacer between columns
        SizedBox(
          width: 40,
        ),

        // Right column
        SizedBox(
          width: MediaQuery.of(context).size.width / _getDivider() - 50,
          child: _makeTextColumn(segments[1]),
        )
      ],
    );
  }

  /// Builds the content for non duo devices.
  /// -> Smaller screens.
  Widget _makeNonDuoContent() {
    return _makeTextColumn(
        removeAllHtmlTags(item.content.value),
    );
  }

  Widget _makeTextColumn(String text) {
    return Text(
      text,
      textAlign: TextAlign.justify,
      style: GoogleFonts.goudyBookletter1911(textStyle: body2Style),
    );
  }

  List<String> _getContentSegments() {
    var list = removeAllHtmlTags(item.content.value).split(" ");
    int halfIndex = (list.length / 2).floor();

    return [
      list.getRange(0, halfIndex).join(" "),
      list.getRange(halfIndex + 1, list.length).join(" ")
    ];
  }

  /// Gets the divider used for width calculations.
  int _getDivider() {
    return isSpanned ? 4 : 2;
  }
}
