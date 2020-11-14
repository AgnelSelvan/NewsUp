import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:newsup/model/model.dart';
import 'package:http/http.dart' as http;
import 'package:newsup/screens/article_screen.dart';

String API_KEY = 'c8adb30d12ab4c61b110349d11239ed7';

Future<List<Source>> fetchNewsArticle() async {
  final response =
      await http.get('http://newsapi.org/v2/sources?apiKey=${API_KEY}');

  if (response.statusCode == 200) {
    List sources = json.decode(response.body)['sources'];
    return sources.map((article) => new Source.fromJson(article)).toList();
  } else {
    throw Exception('Failed to load articles');
  }
}

class Home extends StatefulWidget {
  Home({Key key}) : super(key: key);

  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  var list_sources;
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
        actions: <Widget>[
          Icon(Icons.search, size: 50,)
        ],
        leading: InkWell(
          child: Icon(Icons.arrow_left, color: Theme.of(context).primaryColor,),
          onTap: (){
            Navigator.pop(context);
          },
        ),
        title: Center(child:  Text("Channel List", style: TextStyle(color: Theme.of(context).primaryColor, fontWeight: FontWeight.bold),textAlign: TextAlign.center,),)
      ),
      body: Center(
        child: RefreshIndicator(
            key: refreshKey,
            child: FutureBuilder<List<Source>>(
              future: list_sources,
              builder: (context, snapshot) {
                if (snapshot.hasError) {
                  Text("Error: ${snapshot.error}");
                } else if (snapshot.hasData) {
                  List<Source> sources = snapshot.data;
                  return new ListView(
                    shrinkWrap: true,
                    scrollDirection: Axis.vertical,
                    children: sources
                        .map((source) => GestureDetector(
                              onTap: () {
                                Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) =>
                                            articleScreen(
                                                source: source)));
                              },
                              child: Card(
                                elevation: 1.0,
                                color: Colors.white,
                                margin: EdgeInsets.symmetric(
                                    horizontal: 14.0, vertical: 8.0),
                                child: Row(
                                  crossAxisAlignment:
                                      CrossAxisAlignment.start,
                                  children: <Widget>[
                                    Container(
                                      margin: EdgeInsets.symmetric(
                                          horizontal: 2.0),
                                      width: 100.0,
                                      height: 140,
                                      child: Image.asset(
                                          'assets/images/newsup.png'),
                                    ),
                                    Expanded(
                                        child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: <Widget>[
                                        Row(
                                          children: <Widget>[
                                            Expanded(
                                              child: Container(
                                                margin: EdgeInsets.only(
                                                    top: 20,
                                                    bottom: 10),
                                                child: Text(
                                                  '${source.id}',
                                                  style: TextStyle(
                                                      fontSize: 24,
                                                      fontWeight:
                                                          FontWeight
                                                              .bold,
                                                      color:
                                                          Theme.of(context).primaryColor),
                                                ),
                                              ),
                                            )
                                          ],
                                        ),
                                        Container(
                                          margin: EdgeInsets.only(
                                              top: 20, bottom: 10),
                                          child: Text(
                                            '${source.description}',
                                            style: TextStyle(
                                                fontSize: 12,
                                                color: Colors.blueGrey),
                                          ),
                                        ),
                                        Container(
                                          margin: EdgeInsets.only(
                                              top: 20, bottom: 10),
                                          child: Text(
                                            'Category: ${source.category}',
                                            style: TextStyle(
                                                fontSize: 12,
                                                fontWeight:
                                                    FontWeight.bold,
                                                color: Colors.blueGrey),
                                          ),
                                        ),
                                      ],
                                    )),
                                  ],
                                ),
                              ),
                            ))
                        .toList(),
                  );
                }
                return CircularProgressIndicator();
              },
            ),
            onRefresh: refreshResourceList),
      ),
    );
  }

  Future<Null> refreshResourceList() async {
    refreshKey.currentState?.show(atTop: false);

    setState(() {
      list_sources = fetchNewsArticle();
    });

    return null;
  }
}
