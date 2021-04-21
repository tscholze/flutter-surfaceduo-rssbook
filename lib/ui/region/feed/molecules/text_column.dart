import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:rss_book/ui/styles/styles.dart';

class TextColumn extends StatelessWidget {
  // - Private properties -

  final String text;

  // - Init -

  TextColumn({this.text});

  // - Overrides -

  @override
  Widget build(BuildContext context) {
    return Text(
      text,
      textAlign: TextAlign.justify,
      style: GoogleFonts.goudyBookletter1911(textStyle: pageTextStyle),
    );
  }
}
