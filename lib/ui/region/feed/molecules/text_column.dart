import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class TextColumn extends StatelessWidget {
  // - Private properties -

  final String text;
  final int maxLines;

  // - Init -

  TextColumn({this.text, this.maxLines});

  // - Overrides -

  @override
  Widget build(BuildContext context) {
    return Text(
      text,
      textAlign: TextAlign.justify,
      maxLines: maxLines,
      style: GoogleFonts.goudyBookletter1911(textStyle: pageTextStyle),
    );
  }
}

final pageTextStyle =
TextStyle(fontSize: 16, color: Colors.black87, letterSpacing: 1.3);
