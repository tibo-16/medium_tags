import 'package:flutter/material.dart';
import 'package:flutter_inappwebview/flutter_inappwebview.dart';
import 'package:medium_tags/post.dart';
import 'package:medium_tags/scraper.dart';

class PostItem extends StatefulWidget {
  PostItem({Key? key, required Post post})
      : _post = post,
        super(key: key);

  final Post _post;
  final ChromeSafariBrowser _browser = ChromeSafariBrowser();

  @override
  State<PostItem> createState() => _PostItemState();
}

class _PostItemState extends State<PostItem> {
  @override
  Widget build(BuildContext context) {
    return Card(
      child: InkWell(
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Flexible(child: Text(widget._post.author)),
                  Container(
                    decoration: BoxDecoration(
                      color:
                          ColorX.getColorFromDate(widget._post.publishedDate),
                      borderRadius: BorderRadius.circular(10.0),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.all(4.0),
                      child: Text(
                        widget._post.publishedDate.toMediumDate(),
                        style: TextStyle(
                          color: ColorX.getColorFromDate(
                                  widget._post.publishedDate)
                              .getTextColor(),
                          fontSize: 12.0,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
              Padding(
                padding: const EdgeInsets.only(top: 8.0),
                child: Text(
                  widget._post.title,
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 14.0,
                  ),
                ),
              )
            ],
          ),
        ),
        onTap: () async {
          await widget._browser.open(url: Uri.parse(widget._post.link));
        },
      ),
    );
  }
}

extension ColorX on Color {
  Color getTextColor() {
    // get YIQ ratio
    final yiq = ((red * 299) + (green * 587) + (blue * 114)) / 1000;

    // check contrast
    return yiq >= 128 ? Colors.black : Colors.white;
  }

  static Color getColorFromDate(DateTime date) {
    final colors = <Color>[
      Colors.amber,
      Colors.black,
      Colors.blue,
      Colors.blueGrey,
      Colors.brown,
      Colors.cyan,
      Colors.deepPurpleAccent,
      Colors.deepOrange,
      Colors.grey,
      Colors.green,
      Colors.indigo,
      Colors.lightBlueAccent,
      Colors.lightGreenAccent,
      Colors.lime,
      Colors.orange,
      Colors.pink,
      Colors.purple,
      Colors.red,
      Colors.teal,
      Colors.yellow,
      Colors.blueAccent,
      Colors.pinkAccent,
      Colors.orangeAccent,
      Colors.greenAccent,
      Colors.indigoAccent,
      Colors.amberAccent,
      Colors.redAccent,
      Colors.white30,
      Colors.limeAccent,
      Colors.deepPurple,
      Colors.cyanAccent,
    ];

    return colors[date.day - 1];
  }
}
