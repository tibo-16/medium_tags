import 'package:html/parser.dart';
import 'package:html_unescape/html_unescape.dart';
import 'package:http/http.dart';
import 'package:medium_tags/post.dart';

class Scraper {
  static final Client _client = Client();
  static final HtmlUnescape _unescape = HtmlUnescape();

  static const String _baseUrl = 'https://medium.com/tag';

  static Future<List<Post>> getPosts(String tag, DateTime date) async {
    final url = '$_baseUrl/$tag/archive/${date.toMediumDate()}';

    final response = await _client.get(Uri.parse(url));
    if (response.statusCode != 200) {
      throw Exception('Could not load posts');
    }

    final posts = <Post>[];

    final document = parse(response.body);
    final postElements = document.getElementsByClassName('postArticle');
    for (var element in postElements) {
      final timeElement = element.querySelector('time');
      final time = timeElement?.attributes['datetime'];

      if (time != null && time.startsWith(date.toDateString())) {
        final authorElement = element.querySelector('.postMetaInline > a');
        final author = _unescape.convert(authorElement?.innerHtml ?? '');

        var titleElement = element.querySelector('div.section-inner h3');
        titleElement ??= element.querySelector('div.section-inner p');
        var title = _unescape.convert(titleElement?.innerHtml ?? '');
        title = title.replaceAll(RegExp(r'<[^>]*>'), "");

        final linkElement = element.querySelector('.postArticle-readMore > a');
        final link = linkElement?.attributes['href'] ?? '';

        posts.add(Post(
            publishedDate: date, author: author, title: title, link: link));
      }
    }

    return posts;
  }
}

extension DateTimeX on DateTime {
  String toMediumDate() {
    return '${year.toString().padLeft(4, '0')}/${month.toString().padLeft(2, '0')}/${day.toString().padLeft(2, '0')}';
  }

  String toDateString() {
    return '${year.toString().padLeft(4, '0')}-${month.toString().padLeft(2, '0')}-${day.toString().padLeft(2, '0')}';
  }
}
