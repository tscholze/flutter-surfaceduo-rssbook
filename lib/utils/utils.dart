import 'package:url_launcher/url_launcher.dart';

/// String helper to remove all html tags in given string.
String removeAllHtmlTags(String htmlText) {
  RegExp exp = RegExp(r"<[^>]*>", multiLine: true, caseSensitive: true);

  return htmlText.replaceAll(exp, '');
}

/// Launches the system's browser.
void launchURL(String url) async =>
    await canLaunch(url) ? await launch(url) : throw 'Could not launch $url';