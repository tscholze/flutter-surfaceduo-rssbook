import 'package:dotted_line/dotted_line.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class BookPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Textual content.
        Text("Text"),
        Spacer(),
        _makeBottom()
      ],
    );
  }

  Widget _makeBottom() {
    return  Column(
        children: [
          SizedBox(
            height: 5,
            child: DottedLine(
              dashLength: 1,
              dashGapLength: 3,
              lineThickness: 1,
              dashColor: Colors.blueGrey,
            ),
          ),
          Text(
              "Page 1",
            style: GoogleFonts.goudyBookletter1911(fontSize: 10, color: Colors.blueGrey),
          )
        ],
      );
  }
}
