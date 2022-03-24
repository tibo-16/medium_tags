import 'package:flutter/material.dart';
import 'package:medium_tags/home.dart';
import 'package:medium_tags/posts_model.dart';
import 'package:provider/provider.dart';

class Start extends StatefulWidget {
  const Start({Key? key}) : super(key: key);

  @override
  State<Start> createState() => _StartState();
}

class _StartState extends State<Start> {
  late TextEditingController _controller;

  @override
  void initState() {
    _controller = TextEditingController(text: 'flutter');
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        final currentFocus = FocusScope.of(context);
        if (!currentFocus.hasPrimaryFocus) {
          currentFocus.unfocus();
        }
      },
      child: Scaffold(
        body: Center(
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Theme(
              data: Theme.of(context).copyWith(
                  colorScheme:
                      ThemeData().colorScheme.copyWith(primary: Colors.black)),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  const Align(
                    alignment: Alignment.center,
                    child: Text(
                      'Medium Tags',
                      style: TextStyle(
                        fontFamily: 'NoeDisplay',
                        fontSize: 40.0,
                      ),
                    ),
                  ),
                  const SizedBox(height: 16.0),
                  TextField(
                    controller: _controller,
                    keyboardType: TextInputType.text,
                    textInputAction: TextInputAction.done,
                    autocorrect: false,
                    decoration: InputDecoration(
                      prefixIcon: const Icon(Icons.search),
                      focusColor: Colors.black,
                      enabledBorder: OutlineInputBorder(
                        borderSide: const BorderSide(
                          color: Colors.grey,
                          width: 1.0,
                        ),
                        borderRadius: BorderRadius.circular(25.0),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderSide: const BorderSide(
                          color: Colors.black,
                          width: 1.0,
                        ),
                        borderRadius: BorderRadius.circular(25.0),
                      ),
                    ),
                  ),
                  const SizedBox(height: 16.0),
                  ElevatedButton(
                    onPressed: () => navigate(context),
                    child: const Text('Show posts'),
                    style: ElevatedButton.styleFrom(
                      shape: const RoundedRectangleBorder(
                          borderRadius:
                              BorderRadius.all(Radius.circular(25.0))),
                      minimumSize: const Size(80, 44),
                    ),
                  )
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  void navigate(BuildContext context) {
    Provider.of<PostsModel>(context, listen: false).updateTag(_controller.text);
    Navigator.of(context).push(MaterialPageRoute(builder: (_) => const Home()));
  }
}
