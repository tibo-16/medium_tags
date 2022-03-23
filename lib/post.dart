import 'package:equatable/equatable.dart';

class Post extends Equatable {
  const Post({
    required this.publishedDate,
    required this.author,
    required this.title,
    required this.link,
  });

  final DateTime publishedDate;
  final String author;
  final String title;
  final String link;

  @override
  List<Object?> get props => [publishedDate, author, title, link];
}
