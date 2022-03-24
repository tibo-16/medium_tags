import 'package:flutter/material.dart';
import 'package:medium_tags/post_item.dart';
import 'package:medium_tags/posts_model.dart';
import 'package:provider/provider.dart';

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
