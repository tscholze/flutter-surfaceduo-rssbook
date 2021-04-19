import 'package:dotted_line/dotted_line.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:rss_book/ui/region/feed/molecules/text_column.dart';
import 'package:rss_book/ui/styles/styles.dart';

class BookPage extends StatelessWidget {
  // - Static properties -

  static const maxLinesOnlyText = 27;
  static const maxLinesWithTitle = 25;

  // - Final fields -

  final int pageNumber;
  final String title;
  final String content;
  final bool isDuo;

  // - Init -

  const BookPage({this.title, this.content, this.pageNumber, this.isDuo})
      : super();

  // - Overriders -

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
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

          // Spacer to move footer to the bottom
          Spacer(),

          // Footer / Bottom
          _makeBottom()
        ],
      ),
    );
  }

  // - Private helper -

  Widget _makeTitleIfRequired() {
    // If `title`  is null, do not show a label.
    if (title == null) return SizedBox(width: 0, height: 0);

    // Else wise, show a title label with a spacer.
    return Column(
      children: [
        // Title
        Text(title, textAlign: TextAlign.left, maxLines: 2, style: titleStyle),

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
          width: MediaQuery.of(context).size.width / 4 - 50,
          child: TextColumn(
            text: content,
          ),
        ),

        // Spacer between columns
        SizedBox(
          width: 40,
        ),

        // Right column
        SizedBox(
          width: MediaQuery.of(context).size.width / 4 - 50,
          child: TextColumn(
            text: content,
          ),
        )
      ],
    );
  }

  Widget _makeNonDuoContent() {
    return TextColumn(
      text: content,
    );
  }

  Widget _makeBottom() {
    return Column(
      children: [
        // Top dotted border
        SizedBox(
          height: 5,
          child: DottedLine(
            dashLength: 1,
            dashGapLength: 3,
            lineThickness: 1,
            dashColor: Colors.blueGrey,
          ),
        ),

        // Bottom text
        Text(
          "Page $pageNumber",
          style: GoogleFonts.goudyBookletter1911(
            fontSize: 10,
            color: Colors.blueGrey,
          ),
        )
      ],
    );
  }
}
