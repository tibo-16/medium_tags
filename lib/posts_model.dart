import 'dart:collection';

import 'package:flutter/cupertino.dart';
import 'package:medium_tags/post.dart';
import 'package:medium_tags/scraper.dart';

class PostsModel extends ChangeNotifier {
  PostsModel()
      : _lastCheckedDate = DateTime.now(),
        _currentTag = 'flutter',
        super();

  DateTime _lastCheckedDate;
  String _currentTag;

  final int _batchSize = 25;
  final List<Post> _posts = [];

  String get tag => _currentTag;
  UnmodifiableListView<Post> get posts => UnmodifiableListView(_posts);
  int get postsCount => _posts.length;

  void init() async {
    final newPosts = await Scraper.getPosts(_currentTag, _lastCheckedDate);
    _posts.addAll(newPosts);

    notifyListeners();
  }

  void updateTag(String tag) {
    _lastCheckedDate = DateTime.now();
    _currentTag = tag;
    _posts.clear();

    init();
  }
}
