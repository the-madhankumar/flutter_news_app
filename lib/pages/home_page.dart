import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import '../models/article.dart';
import '../const.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final Dio dio = Dio();
  List<Article> articles = [];

  @override
  void initState() {
    super.initState();
    _getNews();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          "News",
          style: TextStyle(
            fontSize: 24,
            fontWeight: FontWeight.bold,
          ),
        ),
        backgroundColor: Colors.blueAccent,
      ),
      body: _buildUI(),
    );
  }

  Widget _buildUI() {
    return ListView.builder(
      itemCount: articles.length,
      itemBuilder: (context, index) {
        final article = articles[index];
        return Card(
          elevation: 3,
          margin: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
          child: InkWell(
            onTap: () {
              _launchUrl(
                Uri.parse(article.url ?? ""),
              );
            },
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                ClipRRect(
                  borderRadius: const BorderRadius.only(
                    topLeft: Radius.circular(8),
                    topRight: Radius.circular(8),
                  ),
                  child: Image.network(
                    article.urlToImage ?? PLACEHOLDER_IMAGE_LINK,
                    height: 200,
                    fit: BoxFit.cover,
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        article.title ?? "",
                        style: const TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        article.publishedAt ?? "",
                        style: const TextStyle(
                          color: Colors.grey,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Future<void> _getNews() async {
    final response = await dio.get(
      'https://newsapi.org/v2/top-headlines?country=us&category=business&apiKey=${NEWS_API_KEY}',
    );
    final articlesJson = response.data["articles"] as List;
    setState(() {
      List<Article> newsArticle =
          articlesJson.map((a) => Article.fromJson(a)).toList();
      newsArticle = newsArticle.where((a) => a.title != "[Removed]").toList();
      articles = newsArticle;
    });
  }

  Future<void> _launchUrl(Uri url) async {
    // ignore: deprecated_member_use
    if (!await canLaunch(url.toString())) {
      throw Exception('Could not launch $url');
    } else {
      // ignore: deprecated_member_use
      await launch(url.toString());
    }
  }
}
