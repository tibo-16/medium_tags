import 'dart:collection';

import 'package:flutter/cupertino.dart';
import 'package:medium_tags/post.dart';
import 'package:medium_tags/scraper.dart';

class PostsModel extends ChangeNotifier {
  PostsModel()
      : _lastCheckedDate = DateTime.now(),
        _currentTag = 'flutter',
        _loading = false,
        _hasError = false,
        _fetchCount = 1,
        super();

  DateTime _lastCheckedDate;
  String _currentTag;
  bool _loading;
  bool _hasError;
  int _fetchCount;

  final int _batchSize = 25;
  final List<Post> _posts = [];

  String get tag => _currentTag;

  UnmodifiableListView<Post> get posts => UnmodifiableListView(_posts);

  int get postsCount => _posts.length;

  bool get loading => _loading;

  bool get hasError => _hasError;

  Future<void> fetchPosts() async {
    // prevent multiple requests
    if (_loading) {
      return;
    }

    _loading = true;
    _hasError = false;
    notifyListeners();

    while (postsCount < _batchSize * _fetchCount) {
      try {
        final newPosts = await Scraper.getPosts(_currentTag, _lastCheckedDate);
        _posts.addAll(newPosts);
        _lastCheckedDate = _lastCheckedDate.subtract(const Duration(days: 1));
      } catch (_) {
        _hasError = true;
        break;
      }
    }

    _loading = false;
    _fetchCount++;
    notifyListeners();
  }

  void updateTag(String tag) {
    _lastCheckedDate = DateTime.now();
    _currentTag = tag.toLowerCase().replaceAll(' ', '-');
    _posts.clear();
    _hasError = false;
    _fetchCount = 1;

    fetchPosts();
  }
}
