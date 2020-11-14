import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:newsup/model/model.dart';
import 'package:http/http.dart' as http;
import 'package:newsup/screens/view_news.dart';

String API_KEY = 'c8adb30d12ab4c61b110349d11239ed7';

Future<List<Article>> fetchNewsArticle(String search) async {
  final response = await http
      .get('http://newsapi.org/v2/everything?q=$search&apiKey=$API_KEY');

  if (response.statusCode == 200) {
    List articles = json.decode(response.body)['articles'];
    // print(articles);
    return articles.map((article) => new Article.fromJson(article)).toList();
  } else {
    throw Exception('Failed to load articles');
  }
}

class SearchNews extends StatefulWidget {
  final String search;
  SearchNews({Key key, @required this.search}) : super(key: key);

  @override
  _SearchNewsState createState() => _SearchNewsState();
}

class _SearchNewsState extends State<SearchNews> {
  var list_articles;
  var refreshKey = GlobalKey<RefreshIndicatorState>();

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    refreshResourceList();
  }

  Future<Null> refreshResourceList() async {
    refreshKey.currentState?.show(atTop: false);

    setState(() {
      list_articles = fetchNewsArticle(widget.search);
    });

    return null;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.white10,
          elevation: 0.0,
          leading: InkWell(
            child: Icon(
              Icons.arrow_left,
              color: Theme.of(context).primaryColor,
            ),
            onTap: () {
              Navigator.pop(context);
            },
          ),
          actions: <Widget>[
            Icon(
              Icons.search,
              size: 60,
            )
          ],
          title: Center(
            child: Text(
              widget.search == "news" ? "News Up" : widget.search,
              textAlign: TextAlign.center,
              style: TextStyle(color: Theme.of(context).primaryColor, fontWeight: FontWeight.bold, fontSize: 24),
            ),
          ),
        ),
        body: Container(
            padding: EdgeInsets.only(left: 16, right: 16),
            child: RefreshIndicator(
              onRefresh: refreshResourceList,
              child: Container(
                child: FutureBuilder<List<Article>>(
                  future: list_articles,
                  builder: (context, snapshot) {
                    if (snapshot.hasError) {
                      return Text("Error: ${snapshot.error}");
                    } else if (snapshot.hasData) {
                      if (snapshot.data.length == 0) {
                        return Text("Wrong search");
                      }
                      List<Article> articles = snapshot.data;
                      articles.sort((a, b) {
                        return b.publishedAt.compareTo(a.publishedAt);
                      });
                      return ListView(
                          scrollDirection: Axis.vertical,
                          shrinkWrap: true,
                          children: articles
                              .map((article) => GestureDetector(
                                    onTap: () {
                                      Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                              builder: (context) =>
                                                  viewNews(article: article)));
                                    },
                                    child: ListTile(
                                      title: Text(article.title == null
                                          ? ""
                                          : article.title, style: TextStyle(color:Theme.of(context).primaryColor),),
                                      contentPadding: EdgeInsets.all(4),
                                      subtitle: Text(article.publishedAt == null
                                          ? ""
                                          : "Published At: ${DateFormat('dd/MM/yyyy  hh:mm').format(DateTime.parse(article.publishedAt))}"),
                                      trailing: article.urlToImage == null
                                          ? Image.asset(
                                              "assets/images/newsup.png")
                                          : Image.network(
                                              article.urlToImage,
                                              width: 70,
                                            ),
                                    ),
                                  ))
                              .toList());
                    }
                    return Center(child: CircularProgressIndicator());
                  },
                ),
              ),
            )));
  }
}
