import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:newsup/model/model.dart';
import 'package:http/http.dart' as http;
import 'package:newsup/screens/view_news.dart';
import 'package:url_launcher/url_launcher.dart';


String API_KEY = 'c8adb30d12ab4c61b110349d11239ed7';

Future<List<Article>> fetchNewsArticle(String source) async{
    final response = await http.get('http://newsapi.org/v2/top-headlines?sources=${source}&apiKey=${API_KEY}');

  if(response.statusCode == 200){
    List articles = json.decode(response.body)['articles'];
    return articles.map((article) => new Article.fromJson(article)).toList();
  }
  else {
    throw Exception('Failed to load articles');
  }
}

class articleScreen extends StatefulWidget {
  final Source source;
  articleScreen({Key key, @required this.source}) : super(key: key);

  @override
  _articleScreenState createState() => _articleScreenState();
}

class _articleScreenState extends State<articleScreen> {
  var list_articles;
  var refreshKey = GlobalKey<RefreshIndicatorState>();

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    refreshResourceList();
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
            size: 30,
          )
        ],
        title: Center(
          child: Text(
            widget.source.name,
            textAlign: TextAlign.center,
            style: TextStyle(color: Theme.of(context).primaryColor),
          ),
        ),
      ),
      body: Center(
        child: RefreshIndicator(
          child: FutureBuilder<List<Article>>(
            future: list_articles,
            builder: (context, snapshot){
              if(snapshot.hasError){
                return Text(snapshot.error);
              }
              else if(snapshot.hasData){
                List<Article> articles = snapshot.data;
                articles.sort((b, a){
                  return a.publishedAt.compareTo(b.publishedAt);
                });
                return ListView(
                  children: articles.map((article) => GestureDetector(
                    onTap: (){
                      // _launchUrl(widget.source.url);
                      Navigator.push(context, MaterialPageRoute(builder: (context) => viewNews(article: article)));
                      // print(snapshot.data['title']);
                    },
                    child: Card(
                      elevation: 1.0,
                      color: Colors.white,
                      margin: EdgeInsets.all(8.0),
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                        Container(
                          margin: EdgeInsets.symmetric(vertical:20, horizontal:4),
                          width: 100,
                          height: 100,
                          child: article.urlToImage != null? Image.network(article.urlToImage) : Image.asset('assets/images/newsup.png'),
                        ),
                        Expanded( 
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: <Widget>[
                              Row(
                                children: <Widget>[
                                  Expanded(
                                    child: Container(
                                      margin: EdgeInsets.only(top: 16, left:5),
                                      child: Text(article.title == null ? "" : article.title, style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Theme.of(context).primaryColor),),
                                    ),
                                  )
                                ],
                              ),
                              SizedBox(height: 10,),
                              Container(
                                child: Text(article.description == null ? "" : article.description, style: TextStyle(color: Colors.grey, fontSize: 12),),
                              ),
                              SizedBox(height: 10,),
                              Container(
                                child: Text(article.publishedAt == null ? "" : 'Published At: ${DateFormat('dd/MM/yyyy  hh:mm').format(DateTime.parse(article.publishedAt))}', style: TextStyle(color: Colors.grey[600], fontSize: 12),),
                              ),
                              SizedBox(height: 20,),
                              

                            ],
                          ),
                        )
                        
                      ],),
                    ),
                  )).toList(),
                );
                // return ListView.builder(itemCount: snapshot.data.length,
                //   itemBuilder: (context, int index){
                //     if(snapshot.data[index].title == "bbc-news"){
                //       return Card(
                //       elevation: 1.0,
                //       color: Colors.white,
                //       margin: EdgeInsets.all(8.0),
                //       child: Row(
                //         crossAxisAlignment: CrossAxisAlignment.start,
                //         children: <Widget>[
                //         Container(
                //           margin: EdgeInsets.symmetric(vertical:20, horizontal:4),
                //           width: 100,
                //           height: 100,
                //           child: snapshot.data[index].urlToImage != null? Image.network(snapshot.data[index].urlToImage) : Image.asset('assets/images/newsup.png'),
                //         ),
                //         Expanded(
                //           child: Column(
                //             crossAxisAlignment: CrossAxisAlignment.start,
                //             children: <Widget>[
                //               Row(
                //                 children: <Widget>[
                //                   Expanded(
                //                     child: Container(
                //                       margin: EdgeInsets.only(top: 16, left:5),
                //                       child: Text(snapshot.data[index].title, style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),),
                //                     ),
                //                   )
                //                 ],
                //               ),
                //               SizedBox(height: 10,),
                //               Container(
                //                 child: Text(snapshot.data[index].description, style: TextStyle(color: Colors.grey, fontSize: 12),),
                //               ),
                //               SizedBox(height: 10,),
                //               Container(
                //                 child: Text('Published At: ${DateFormat('yyyy/MM/dd  hh:mm:ss').format(DateTime.parse(snapshot.data[index].publishedAt))}', style: TextStyle(color: Colors.grey, fontSize: 12),),
                //               ),
                //               SizedBox(height: 20,),
                              

                //             ],
                //           ),
                //         )
                        
                //       ],),
                    
                //   );
                //     }
                //     else{
                //       return Text("Yes");
                //     }
                //   },
                // );
              }
              return CircularProgressIndicator();
            },
          ),
          onRefresh: refreshResourceList,
      ),
    ));
  }
  Future<Null> refreshResourceList() async {
    refreshKey.currentState?.show(atTop: false);

    setState(() {
      list_articles = fetchNewsArticle(widget.source.id);
    });

    return null;
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