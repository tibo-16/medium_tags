import 'package:flutter/material.dart';
import 'package:medium_tags/post.dart';
import 'package:medium_tags/posts_model.dart';
import 'package:medium_tags/scraper.dart';
import 'package:provider/provider.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: ChangeNotifierProvider(
        create: (_) => PostsModel()..fetchPosts(),
        child: const Home(),
      ),
    );
  }
}

class Home extends StatefulWidget {
  const Home({Key? key}) : super(key: key);

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  late ScrollController _controller;

  @override
  void initState() {
    _controller = ScrollController()..addListener(loadMore);
    super.initState();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<PostsModel>(builder: (context, model, _) {
      return Scaffold(
        appBar: AppBar(title: Text(model.tag)),
        body: SafeArea(
          bottom: true,
          child: model.loading && model.postsCount == 0
              ? const Center(child: CircularProgressIndicator())
              : Column(
                  children: [
                    Expanded(
                      child: ListView.builder(
                        controller: _controller,
                        itemBuilder: (_, index) =>
                            PostItem(post: model.posts[index]),
                        itemCount: model.postsCount,
                      ),
                    ),
                    if (model.loading) const CircularProgressIndicator()
                  ],
                ),
        ),
      );
    });
  }

  void loadMore() async {
    if (_controller.position.maxScrollExtent == _controller.position.pixels) {
      await Provider.of<PostsModel>(context, listen: false).fetchPosts();
    }
  }
}

class PostItem extends StatelessWidget {
  const PostItem({Key? key, required Post post})
      : _post = post,
        super(key: key);

  final Post _post;

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Flexible(child: Text(_post.author)),
                Container(
                  decoration: BoxDecoration(
                    color: ColorX.getColorFromDate(_post.publishedDate),
                    borderRadius: BorderRadius.circular(10.0),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(4.0),
                    child: Text(
                      _post.publishedDate.toMediumDate(),
                      style: TextStyle(
                        color: ColorX.getColorFromDate(_post.publishedDate)
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
                _post.title,
                style: const TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 14.0,
                ),
              ),
            )
          ],
        ),
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
