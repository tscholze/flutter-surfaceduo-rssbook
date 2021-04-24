import 'package:url_launcher/url_launcher.dart';

void launchURL(String url) async =>
    await canLaunch(url) ? await launch(url) : throw 'Could not launch $url';