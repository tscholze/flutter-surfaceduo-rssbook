import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class AppTitle extends StatelessWidget {

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Title.
        Text(
          "The Feed's Book",
          style: GoogleFonts.goudyBookletter1911(
            fontSize: 42,
            fontWeight: FontWeight.w900
          ),
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
}