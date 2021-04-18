import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class AppFooter extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Text(
        "Made with Flutter and <3.",
        style: GoogleFonts.goudyBookletter1911(),
        textAlign: TextAlign.center
    );
  }
}
