import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:multiple_screens/multiple_screens.dart';
import 'package:rss_book/ui/region/feed/molecules/book_page.dart';

// https://stackoverflow.com/questions/51640388/flutter-textpainter-vs-paragraph-for-drawing-book-page
class FeedPage extends StatefulWidget {
  @override
  _FeedPageState createState() => _FeedPageState();
}

class _FeedPageState extends State<FeedPage> {
  // Method channel
  final _duoPlatform = const MethodChannel('duosdk.microsoft.dev');

  // Determines if the app runs on a Duo.
  bool _isDuo = false;

  // Determines if the app runs on a Duo and is
  // spanned.
  bool _isDuoSpanned = false;

  // Gets the actual hinge size.
  double _hingeSize = 0.0;

  final PageController pageController = PageController(initialPage: 0);

  @override
  void initState() {
    super.initState();

    // Listen to changes.
    MultipleScreensMethods.isAppSpannedStream().listen(
      (data) => setState(() => _isDuoSpanned = data),
    );

    // Check if it is a Duo.
    // If yes, set e.g. hinge size.
    _checkForDuo();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: EdgeInsets.fromLTRB(0, 40, 0, 20),
        child: PageView(
          scrollDirection: Axis.horizontal,
          controller: pageController,
          pageSnapping: true,
          children: _splitContentIntoTextWidgets(lorem),
        ),
      ),
    );
  }

  //  Builds the dual screen content.
  Widget _makeDualScreenContent() {
    return Row(
      children: [
        // Left
        Flexible(
          flex: 1,
          child: Padding(
            padding: EdgeInsets.fromLTRB(0, 0, 20, 0),
            child: BookPage(
              title: "Flutter + Surface Duo is awesome!",
              content: s,
              pageNumber: 1,
              isDuo: _isDuo,
            ),
          ),
        ),

        // Hinge spacer
        SizedBox(width: _hingeSize),

        // Right
        Flexible(
          flex: 1,
          child: BookPage(
            content: s,
            pageNumber: 2,
            isDuo: _isDuo,
          ),
        ),
      ],
    );
  }

  // Builds the single screen content.
  Widget _makeSingleScreenContent(String title, String content, int pageNumber) {
    return Padding(
      padding: EdgeInsets.fromLTRB(20, 0, 20, 0),
      child: BookPage(
        title: title,
        content: content,
        pageNumber: pageNumber,
        isDuo: _isDuo,
      ),
    );
  }

  void _checkForDuo() async {
    try {
      _isDuo = await MultipleScreensMethods.isMultipleScreensDevice;
      _hingeSize = await _duoPlatform.invokeMethod('gethingeSize');
    } catch (_) {
      _isDuo = false;
      _isDuoSpanned = false;
    }
  }

  List<Widget> _splitContentIntoTextWidgets(String content) {

    String alreadyAdded = "";
    List<Widget> texts = [];
    int lastIndex = 0;
    int pageCount = 1;

    while(alreadyAdded.length != content.length)
    {
      String t = content.substring(0, maxCharCountToFit(content.substring(lastIndex, content.length)));
      alreadyAdded += t;
      lastIndex = t.length;
      texts.add(_makeSingleScreenContent(null, t, pageCount));
      pageCount++;
      print("Added count: ${alreadyAdded.length} --- Has to be count: ${content.length}");
    }

    return texts;
  }

  int maxCharCountToFit(String content) {
    List<String> splitted = content.split(" ");

    for (int i = splitted.length; i >= 0; i--) {
      bool retry = TextPainter(
            text: TextSpan(text: splitted.sublist(0, splitted.length - i).join(" "), style: pageTextStyle),
            maxLines: 25,
            textScaleFactor: MediaQuery.of(context).textScaleFactor,
            textDirection: TextDirection.ltr,
          ).didExceedMaxLines ==
          false;

      if (retry == false) {
        return splitted.sublist(0, i).length;
      }
    }

    return 0;
  }
}

const s =
    """Lorem ipsum dolor sit amet, consetetur sadipscing elitr, sed diam nonumy eirmod tempor invidunt ut labore et dolore magna aliquyam erat, sed diam voluptua. At vero eos et accusam et justo duo dolores et ea rebum. Stet clita kasd gubergren, no sea takimata sanctus est Lorem ipsum dolor sit amet. Lorem ipsum dolor sit amet, consetetur sadipscing elitr, sed diam nonumy eirmod tempor invidunt ut labore et dolore magna aliquyam erat, sed diam voluptua. At vero eos et accusam et justo duo dolores et ea rebum. Stet clita kasd gubergren, no sea takimata sanctus est Lorem ipsum dolor sit amet. Lorem ipsum dolor sit amet, consetetur sadipscing elitr, sed diam nonumy eirmod tempor invidunt ut labore et dolore magna aliquyam erat, sed diam voluptua. At vero eos et accusam et justo duo dolores et ea rebum. Stet clita kasd gubergren, no sea takimata sanctus est Lorem ipsum dolor sit amet.
""";

const lorem =
"""Lorem ipsum dolor sit amet, consetetur sadipscing elitr, sed diam nonumy eirmod tempor invidunt ut labore et dolore magna aliquyam erat, sed diam voluptua. At vero eos et accusam et justo duo dolores et ea rebum. Stet clita kasd gubergren, no sea takimata sanctus est Lorem ipsum dolor sit amet. Lorem ipsum dolor sit amet, consetetur sadipscing elitr, sed diam nonumy eirmod tempor invidunt ut labore et dolore magna aliquyam erat, sed diam voluptua. At vero eos et accusam et justo duo dolores et ea rebum. Stet clita kasd gubergren, no sea takimata sanctus est Lorem ipsum dolor sit amet. Lorem ipsum dolor sit amet, consetetur sadipscing elitr, sed diam nonumy eirmod tempor invidunt ut labore et dolore magna aliquyam erat, sed diam voluptua. At vero eos et accusam et justo duo dolores et ea rebum. Stet clita kasd gubergren, no sea takimata sanctus est Lorem ipsum dolor sit amet. 

Duis autem vel eum iriure dolor in hendrerit in vulputate velit esse molestie consequat, vel illum dolore eu feugiat nulla facilisis at vero eros et accumsan et iusto odio dignissim qui blandit praesent luptatum zzril delenit augue duis dolore te feugait nulla facilisi. Lorem ipsum dolor sit amet, consectetuer adipiscing elit, sed diam nonummy nibh euismod tincidunt ut laoreet dolore magna aliquam erat volutpat. 

Ut wisi enim ad minim veniam, quis nostrud exerci tation ullamcorper suscipit lobortis nisl ut aliquip ex ea commodo consequat. Duis autem vel eum iriure dolor in hendrerit in vulputate velit esse molestie consequat, vel illum dolore eu feugiat nulla facilisis at vero eros et accumsan et iusto odio dignissim qui blandit praesent luptatum zzril delenit augue duis dolore te feugait nulla facilisi. 

Nam liber tempor cum soluta nobis eleifend option congue nihil imperdiet doming id quod mazim placerat facer possim assum. Lorem ipsum dolor sit amet, consectetuer adipiscing elit, sed diam nonummy nibh euismod tincidunt ut laoreet dolore magna aliquam erat volutpat. Ut wisi enim ad minim veniam, quis nostrud exerci tation ullamcorper suscipit lobortis nisl ut aliquip ex ea commodo consequat. 

Duis autem vel eum iriure dolor in hendrerit in vulputate velit esse molestie consequat, vel illum dolore eu feugiat nulla facilisis. 

At vero eos et accusam et justo duo dolores et ea rebum. Stet clita kasd gubergren, no sea takimata sanctus est Lorem ipsum dolor sit amet. Lorem ipsum dolor sit amet, consetetur sadipscing elitr, sed diam nonumy eirmod tempor invidunt ut labore et dolore magna aliquyam erat, sed diam voluptua. At vero eos et accusam et justo duo dolores et ea rebum. Stet clita kasd gubergren, no sea takimata sanctus est Lorem ipsum dolor sit amet. Lorem ipsum dolor sit amet, consetetur sadipscing elitr, At accusam aliquyam diam diam dolore dolores duo eirmod eos erat, et nonumy sed tempor et et invidunt justo labore Stet clita ea et gubergren, kasd magna no rebum. sanctus sea sed takimata ut vero voluptua. est Lorem ipsum dolor sit amet. Lorem ipsum dolor sit amet, consetetur sadipscing elitr, sed diam nonumy eirmod tempor invidunt ut labore et dolore magna aliquyam erat. 

Consetetur sadipscing elitr, sed diam nonumy eirmod tempor invidunt ut labore et dolore magna aliquyam erat, sed diam voluptua. At vero eos et accusam et justo duo dolores et ea rebum. Stet clita kasd gubergren, no sea takimata sanctus est Lorem ipsum dolor sit amet. Lorem ipsum dolor sit amet, consetetur sadipscing elitr, sed diam nonumy eirmod tempor invidunt ut labore et dolore magna aliquyam erat, sed diam voluptua. At vero eos et accusam et justo duo dolores et ea rebum. Stet clita kasd gubergren, no sea takimata sanctus est Lorem ipsum dolor sit amet. Lorem ipsum dolor sit amet, consetetur sadipscing elitr, sed diam nonumy eirmod tempor invidunt ut labore et dolore magna aliquyam erat, sed diam voluptua. At vero eos et accusam et justo duo dolores et ea rebum. Stet clita kasd gubergren, no sea takimata sanctus. Lorem ipsum dolor sit amet, consetetur sadipscing elitr, sed diam nonumy eirmod tempor invidunt ut labore et dolore magna aliquyam erat, sed diam voluptua. At vero eos et accusam et justo duo dolores et ea rebum. Stet clita kasd gubergren, no sea takimata sanctus est Lorem ipsum dolor sit amet. Lorem ipsum dolor sit amet, consetetur sadipscing elitr, sed diam nonumy eirmod tempor invidunt ut labore et dolore magna aliquyam erat, sed diam voluptua. At vero eos et accusam et justo duo dolores et ea rebum. Stet clita kasd gubergren, no sea takimata sanctus est Lorem ipsum dolor sit amet. Lorem ipsum dolor sit amet, consetetur sadipscing elitr, sed diam nonumy eirmod tempor invidunt ut labore et dolore magna aliquyam erat, sed diam voluptua. At vero eos et accusam et justo duo dolores et ea rebum. Stet clita kasd gubergren, no sea takimata sanctus est Lorem ipsum dolor sit amet. 

Duis autem vel eum iriure dolor in hendrerit in vulputate velit esse molestie consequat, vel illum dolore eu feugiat nulla facilisis at vero eros et accumsan et iusto odio dignissim qui blandit praesent luptatum zzril delenit augue duis dolore te feugait nulla facilisi. Lorem ipsum dolor sit amet, consectetuer adipiscing elit, sed diam nonummy nibh euismod tincidunt ut laoreet dolore magna aliquam erat volutpat. 

Ut wisi enim ad minim veniam, quis nostrud exerci tation ullamcorper suscipit lobortis nisl ut aliquip ex ea commodo consequat. Duis autem vel eum iriure dolor in hendrerit in vulputate velit esse molestie consequat, vel illum dolore eu feugiat nulla facilisis at vero eros et accumsan et iusto odio dignissim qui blandit praesent luptatum zzril delenit augue duis dolore te feugait nulla facilisi. 

Nam liber tempor cum soluta nobis eleifend option congue nihil imperdiet doming id quod mazim placerat facer possim assum. Lorem ipsum dolor sit amet, consectetuer adipiscing elit, sed diam nonummy nibh euismod tincidunt ut laoreet dolore magna aliquam erat volutpat. Ut wisi enim ad minim veniam, quis nostrud exerci tation ullamcorper suscipit lo""";