import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_swiper/flutter_swiper.dart';
import 'package:intl/intl.dart';
import 'package:newsup/model/model.dart';
import 'package:http/http.dart' as http;
import 'package:url_launcher/url_launcher.dart';

String API_KEY = 'c8adb30d12ab4c61b110349d11239ed7';

Future<List<Article>> fetchAllNews() async {
  final response = await http.get(
      'http://newsapi.org/v2/everything?q=breaking-news&apiKey=${API_KEY}');

  if (response.statusCode == 200) {
    List articles = json.decode(response.body)['articles'];
    // print(articles);
    return articles.map((article) => new Article.fromJson(article)).toList();
  } else {
    throw Exception('Failed to load articles');
  }
}

Future<List<Source>> fetchNewsSource() async {
  final response =
      await http.get('http://newsapi.org/v2/sources?apiKey=${API_KEY}');

  if (response.statusCode == 200) {
    List sources = json.decode(response.body)['sources'];
    return sources.map((article) => new Source.fromJson(article)).toList();
  } else {
    throw Exception('Failed to load articles');
  }
}

Future<List<Article>> fetchNewsArticle(String source) async {
  final response = await http.get(
      'http://newsapi.org/v2/top-headlines?sources=${source}&apiKey=${API_KEY}');

  if (response.statusCode == 200) {
    List articles = json.decode(response.body)['articles'];
    print(articles);
    return articles.map((article) => new Article.fromJson(article)).toList();
  } else {
    throw Exception('Failed to load articles');
  }
}

class AllNews extends StatefulWidget {
  AllNews({Key key}) : super(key: key);

  @override
  _AllNewsState createState() => _AllNewsState();
}

class _AllNewsState extends State<AllNews> {
  // var list_sources;
  var list_articles;
  var refreshKey = GlobalKey<RefreshIndicatorState>();

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    // setState(() {
    //   list_sources = fetchNewsSource();
    // });
    refreshResourceList();
  }

  @override
  void dispose() {
    super.dispose();
  }

  Future<Null> refreshResourceList() async {
    refreshKey.currentState?.show(atTop: false);

    // setState(() {
    //   list_sources = fetchNewsSource();
    // });

    setState(() {
      list_articles = fetchAllNews();
    });

    return null;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white10,
        elevation: 0.0,
        leading: GestureDetector(
          onTap: () {
            Navigator.pop(context);
          },
          child: Icon(Icons.arrow_left),
        ),
        iconTheme: IconThemeData(color: Theme.of(context).primaryColor),
        title: Padding(
          padding: const EdgeInsets.only(right: 50.0),
          child: Center(
            child: Text(
              'News Up',
              textAlign: TextAlign.center,
              style: TextStyle(
                  color: Theme.of(context).primaryColor,
                  fontWeight: FontWeight.bold,
                  fontSize: 24),
            ),
          ),
        ),
      ),
      body: RefreshIndicator(
        onRefresh: refreshResourceList,
        child: FutureBuilder<List<Article>>(
          future: list_articles,
          builder: (context, snapshot) {
            if (snapshot.hasError) {
              return Text("Error : ${snapshot.error}");
            } else if (snapshot.hasData) {
              List<Article> articles = snapshot.data;
              articles.sort((b, a) {
                return a.publishedAt.compareTo(b.publishedAt);
              });
              return Swiper(
                itemCount: snapshot.data.length,
                itemBuilder: (context, int index) {
                  return GestureDetector(
                    onTap: () {
                      // print(widget.article.url);

                      _launchUrl(snapshot.data[index].url);
                    },
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: <Widget>[
                        Column(
                          children: <Widget>[
                            Container(
                              child: snapshot.data[index].urlToImage == null
                                  ? Image.asset('assets/images/newsup.png')
                                  : Image.network(
                                      snapshot.data[index].urlToImage,
                                    ),
                            ),
                            SizedBox(height: 20),
                            Column(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: <Widget>[
                                Container(
                                  margin: EdgeInsets.all(5),
                                  child: Text(
                                      snapshot.data[index].title == null
                                          ? "Breaking News"
                                          : snapshot.data[index].title,
                                      style: TextStyle(
                                          color: Colors.black,
                                          fontWeight: FontWeight.bold,
                                          fontSize: 20)),
                                ),
                                // SizedBox(height:),
                                Container(
                                  margin: EdgeInsets.all(5),
                                  child: Text(
                                      snapshot.data[index].description == null
                                          ? "Description"
                                          : snapshot.data[index].description,
                                      style: TextStyle(
                                          color: Colors.grey, fontSize: 18)),
                                ),
                              ],
                            ),
                          ],
                        ),
                        Container(
                          padding: EdgeInsets.symmetric(
                              horizontal: 10, vertical: 20),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: <Widget>[
                              Text(DateFormat('dd/MM/yyyy  hh:mm').format(
                                          DateTime.parse(
                                              snapshot.data[index].publishedAt)) ==
                                      null
                                  ? ""
                                  : DateFormat('dd/MM/yyyy  hh:mm').format(
                                      DateTime.parse(
                                          snapshot.data[index].publishedAt))),
                              Text(snapshot.data[index].author == null
                                  ? ""
                                  : snapshot.data[index].author.length > 50
                                      ? ""
                                      :snapshot.data[index].author)
                            ],
                          ),
                        ),
                      ],
                    ),
                  );
                },
                scale: 0.9,
                layout: SwiperLayout.DEFAULT,
              );
            }
            return Center(child: CircularProgressIndicator());
          },
        ),
      ),
      // body: Container(
      //   child: FutureBuilder<List<Source>>(
      //     future: list_sources,
      //     builder: (context, snapshot) {
      //       if (snapshot.hasError) {
      //         return Text("Error: ${snapshot.error}");
      //       } else if (snapshot.hasData) {
      //         List<Source> sources = snapshot.data;
      //         // return Swiper(
      //         //   itemCount: snapshot.data.length,
      //         //   // itemBuilder: sources.map((source) => Text(source.name)).toList(),
      //         //   itemBuilder: (context, int index){
      //         //     // return Text(snapshot.data[index].name);
      //         //     return FutureBuilder<List<Article>>(
      //         //       future: fetchNewsArticle(snapshot.data[index].name),
      //         //       builder: (context, content){
      //         //         if(content.hasError){
      //         //           return Text("Error: ${content.error}");
      //         //         }
      //         //         else if(content.hasData){
      //         //           List<Article> articles = content.data;
      //         //           return ListView(
      //         //             children: articles.map((article) => Text(article.author)).toList(),
      //         //           );
      //         //         }
      //         //         return CircularProgressIndicator();
      //         //       },
      //         //     );
      //         //   },
      //         // );
      //         return ListView(
      //           children: sources
      //               .map((source) => FutureBuilder<List<Article>>(
      //                     future: fetchNewsArticle(source.name),
      //                     builder: (context, snapshot){
      //                       if(snapshot.hasError){
      //                         Text("Error: ${snapshot.error}");
      //                       }
      //                       else if(snapshot.hasData){
      //                         print("Article:${snapshot.data}");
      //                         List<Article> articles = snapshot.data;
      //                         return ListView(
      //                           children: articles.map((article) => Text(article.description)).toList(),
      //                         );
      //                       }
      //                       else
      //                       Text("");
      //                     },
      //                   ))
      //               .toList(),
      //         );
      //       }
      //       return Center(child: CircularProgressIndicator());
      //     },
      //   ),
      // ),
    );
  }
  _launchUrl(String url) async {
    if(await canLaunch(url)){
      await launch(url);
    }
    else{
      throw ('Couldnt launch $url');
    }
  }
}
