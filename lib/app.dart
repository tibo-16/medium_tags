import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:medium_tags/home.dart';
import 'package:medium_tags/posts_model.dart';
import 'package:provider/provider.dart';

class App extends StatelessWidget {
  const App({Key? key}) : super(key: key);

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
