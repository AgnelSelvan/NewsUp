import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:intl/intl.dart';
import 'package:newsup/model/model.dart';
import 'package:newsup/screens/all_news.dart';
import 'package:newsup/screens/category.dart';
import 'package:newsup/screens/home.dart';
import 'package:http/http.dart' as http;
import 'package:newsup/screens/search.dart';
import 'package:newsup/screens/view_news.dart';
import 'package:newsup/screens/weather_page.dart';

String API_KEY = 'c8adb30d12ab4c61b110349d11239ed7';

Future<List<Article>> fetchNewsArticle() async {
  final response = await http
      .get('http://newsapi.org/v2/everything?q=all&apiKey=${API_KEY}');

  if (response.statusCode == 200) {
    List articles = json.decode(response.body)['articles'];
    // print(articles);
    return articles.map((article) => new Article.fromJson(article)).toList();
  } else {
    throw Exception('Failed to load articles');
  }
}

class MenuDashboard extends StatefulWidget {
  const MenuDashboard({Key key}) : super(key: key);

  @override
  _MenuDashboardState createState() => _MenuDashboardState();
}

class _MenuDashboardState extends State<MenuDashboard>
    with SingleTickerProviderStateMixin {
  bool isCollapsed = true;
  double screenHeight, screenWidth;
  final Duration duration = const Duration(milliseconds: 500);
  AnimationController _controller;
  Animation<double> _scaleAnimation;
  Animation<Offset> _slideAnimation;
  var list_articles;
  var refreshKey = GlobalKey<RefreshIndicatorState>();

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    refreshResourceList();
    _controller = AnimationController(vsync: this, duration: duration);
    _scaleAnimation = Tween<double>(begin: 1, end: 0.6).animate(_controller);
    _slideAnimation = Tween<Offset>(begin: Offset(-1, 0), end: Offset(0, 0))
        .animate(_controller);
  }

  @override
  void dispose() {
    // TODO: implement dispose
    _controller.dispose();
    super.dispose();
  }

  Future<Null> refreshResourceList() async {
    refreshKey.currentState?.show(atTop: false);

    setState(() {
      list_articles = fetchNewsArticle();
    });

    return null;
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    screenHeight = size.height;
    screenWidth = size.width;

    final tabs = [
      Stack(
        children: <Widget>[dashboard()],
      ),
      Center(child: Text("Weather"))
    ];

    return Scaffold(
      extendBody: true,
      // body: Stack(
      //   children: <Widget>[
      //     menu(context),
      //     dashboard(context),
      //   ],
      // ),
      appBar: AppBar(
        backgroundColor: Colors.white10,
        elevation: 0.0,
        iconTheme: IconThemeData(color: Theme.of(context).primaryColor),
        title: Padding(
          padding: const EdgeInsets.only(right: 40.0),
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
        actions: <Widget>[
          GestureDetector(
            child: Padding(
              padding: const EdgeInsets.only(right: 10.0),
              child: Icon(Icons.ac_unit),
            ),
            onTap: () async {
              final position = await Geolocator().getCurrentPosition(desiredAccuracy: LocationAccuracy.high);
              List<Placemark> placemarks = await Geolocator().placemarkFromCoordinates(position.latitude, position.longitude);
              Placemark placemark = placemarks[0];
              String _location = '${placemark.locality} ${placemark.country}';
              print(_location);
              Navigator.push(context, MaterialPageRoute(builder: (context) => WeatherPage(location: _location,)));
            },
          )
        ],
      ),

      drawer: SizedBox(
        width: MediaQuery.of(context).size.width * 0.7,
        child: Drawer(
          elevation: 10,
          child: ListView(
            children: <Widget>[
              DrawerHeader(
                child: Text(
                  'News Up',
                  style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                ),
                decoration: BoxDecoration(
                    color: Colors.white,
                    image: DecorationImage(
                      image: AssetImage("assets/images/newsup.png"),
                    )),
              ),
              GestureDetector(
                onTap: () {
                  Navigator.push(context,
                      MaterialPageRoute(builder: (context) => AllNews()));
                },
                child: Padding(
                  padding: const EdgeInsets.symmetric(
                      vertical: 10.0, horizontal: 20),
                  child: Row(
                    children: <Widget>[
                      Icon(
                        Icons.timer,
                        size: 16,
                      ),
                      SizedBox(width: 15),
                      Text("Recent News",
                          style: TextStyle(
                            fontSize: 16,
                          )),
                    ],
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 10.0),
                child: Divider(height: 15),
              ),
              GestureDetector(
                onTap: () {
                  Navigator.push(
                      context, MaterialPageRoute(builder: (context) => Home()));
                },
                child: Padding(
                  padding: const EdgeInsets.symmetric(
                      vertical: 10.0, horizontal: 20),
                  child: Row(
                    children: <Widget>[
                      Icon(
                        Icons.live_tv,
                        size: 16,
                      ),
                      SizedBox(width: 15),
                      Text("Channels",
                          style: TextStyle(
                            fontSize: 16,
                          )),
                    ],
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 10.0),
                child: Divider(height: 15),
              ),
              GestureDetector(
                onTap: () {
                  Navigator.push(context,
                      MaterialPageRoute(builder: (context) => Category()));
                },
                child: Padding(
                  padding: const EdgeInsets.symmetric(
                      vertical: 10.0, horizontal: 20),
                  child: Row(
                    children: <Widget>[
                      Icon(
                        Icons.line_style,
                        size: 16,
                      ),
                      SizedBox(width: 15),
                      Text("Category",
                          style: TextStyle(
                            fontSize: 16,
                          )),
                    ],
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 10.0),
                child: Divider(height: 15),
              )
            ],
          ),
        ),
      ),

      body: Stack(
        children: <Widget>[dashboard()],
      ),
    );
  }

  // Widget menu(context) {
  //   return SlideTransition(
  //     position: _slideAnimation,
  //     child: Align(
  //       alignment: Alignment.centerLeft,
  //       child: Container(
  //         padding: EdgeInsets.only(left: 0.05 * screenWidth),
  //         child: Column(
  //           mainAxisSize: MainAxisSize.min,
  //           crossAxisAlignment: CrossAxisAlignment.start,
  //           mainAxisAlignment: MainAxisAlignment.spaceAround,
  //           children: <Widget>[
  //             Column(
  //               children: <Widget>[
  //                 Container(
  //                   padding: EdgeInsets.only(left: 0.05 * screenWidth),
  //                   child: CircleAvatar(
  //                     backgroundImage:
  //                         ExactAssetImage('assets/images/newsup.png'),
  //                     maxRadius: 70,
  //                   ),
  //                 ),
  //                 Container(
  //                     padding: EdgeInsets.only(left: 0.05 * screenWidth),
  //                     child: Text(
  //                       "New Up",
  //                       style: TextStyle(
  //                           fontSize: 24,
  //                           fontWeight: FontWeight.bold,
  //                           color: Colors.grey[800]),
  //                     )),
  //                 SizedBox(height: 50)
  //               ],
  //             ),
  //             GestureDetector(
  //               child: Row(
  //                 children: <Widget>[
  //                   Icon(
  //                     Icons.inbox,
  //                     size: 18,
  //                     color: Colors.grey[700],
  //                   ),
  //                   SizedBox(
  //                     width: 10,
  //                   ),
  //                   Text(
  //                     'All',
  //                     style: TextStyle(fontSize: 22, color: Colors.grey[700]),
  //                   )
  //                 ],
  //               ),
  //               onTap: () {
  //                 setState(() {
  //                   if (isCollapsed)
  //                     _controller.forward();
  //                   else
  //                     _controller.reverse();
  //                   isCollapsed = !isCollapsed;
  //                 });
  //               },
  //             ),
  //             SizedBox(height: 10),
  //             GestureDetector(
  //               onTap: () {
  //                 Navigator.push(
  //                     context, MaterialPageRoute(builder: (context) => Home()));
  //               },
  //               child: Row(
  //                 children: <Widget>[
  //                   Icon(
  //                     Icons.check_box_outline_blank,
  //                     size: 18,
  //                     color: Colors.grey[700],
  //                   ),
  //                   SizedBox(width: 10),
  //                   Text(
  //                     'Channels',
  //                     style: TextStyle(fontSize: 22, color: Colors.grey[700]),
  //                   ),
  //                 ],
  //               ),
  //             ),
  //             SizedBox(height: 10),
  //             GestureDetector(
  //               onTap: () {
  //                 Navigator.push(context,
  //                     MaterialPageRoute(builder: (context) => Category()));
  //               },
  //               child: Row(
  //                 children: <Widget>[
  //                   Icon(
  //                     Icons.category,
  //                     size: 18,
  //                     color: Colors.grey[700],
  //                   ),
  //                   SizedBox(width: 10),
  //                   Text(
  //                     'Category',
  //                     style: TextStyle(fontSize: 22, color: Colors.grey[700]),
  //                   ),
  //                 ],
  //               ),
  //             ),
  //             SizedBox(height: 10),
  //           ],
  //         ),
  //       ),
  //     ),
  //   );
  // }

  Widget dashboard() {
    return RefreshIndicator(
      key: refreshKey,
      onRefresh: refreshResourceList,
      child: AnimatedPositioned(
        duration: duration,
        top: 0,
        bottom: 0,
        left: isCollapsed ? 0 : 0.6 * screenWidth,
        right: isCollapsed ? 0 : -0.5 * screenWidth,
        child: ScaleTransition(
          scale: _scaleAnimation,
          child: SingleChildScrollView(
            scrollDirection: Axis.vertical,
            physics: ClampingScrollPhysics(),
            child: Material(
              animationDuration: duration,
              borderRadius: BorderRadius.all(Radius.circular(5)),
              elevation: 10,
              child: Container(
                padding: EdgeInsets.only(left: 16, right: 16),
                child: Column(
                  children: <Widget>[
                    Container(
                      height: 200,
                      child: PageView(
                        controller: PageController(viewportFraction: 0.9),
                        scrollDirection: Axis.horizontal,
                        pageSnapping: true,
                        children: <Widget>[
                          GestureDetector(
                            onTap: () {
                              Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) => SearchNews(
                                            search: "game",
                                          )));
                            },
                            child: Stack(
                                alignment: Alignment(0, 0),
                                children: <Widget>[
                                  Container(
                                    margin: EdgeInsets.symmetric(horizontal: 4),
                                    child: Image.asset(
                                      'assets/images/games.jpg',
                                      height: screenHeight,
                                      width: screenWidth,
                                    ),
                                  ),
                                  Container(
                                    margin: EdgeInsets.symmetric(
                                        vertical: 20, horizontal: 5),
                                    decoration: BoxDecoration(
                                        color: new Color.fromARGB(90, 0, 0, 0)),
                                  ),
                                  Text(
                                    "Games",
                                    style: TextStyle(
                                        fontSize: 28,
                                        fontWeight: FontWeight.bold,
                                        color: Colors.white),
                                  )
                                ]),
                          ),
                          GestureDetector(
                            onTap: () {
                              Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) =>
                                          SearchNews(search: "weather")));
                            },
                            child: Stack(
                                alignment: Alignment(0, 0),
                                children: <Widget>[
                                  Container(
                                    margin: EdgeInsets.symmetric(horizontal: 4),
                                    child: Image.asset(
                                      'assets/images/weather.jpg',
                                      height: screenHeight,
                                      width: screenWidth,
                                    ),
                                  ),
                                  Container(
                                    margin: EdgeInsets.symmetric(
                                        vertical: 5, horizontal: 5),
                                    decoration: BoxDecoration(
                                        color: new Color.fromARGB(
                                            90, 108, 99, 255)),
                                  ),
                                  Text(
                                    "Weather",
                                    style: TextStyle(
                                        fontSize: 28,
                                        fontWeight: FontWeight.bold,
                                        color: Colors.white),
                                  )
                                ]),
                          ),
                          GestureDetector(
                            onTap: () {
                              Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) =>
                                          SearchNews(search: "coronavirus")));
                            },
                            child: Stack(
                                alignment: Alignment(0, 0),
                                children: <Widget>[
                                  Container(
                                    margin: EdgeInsets.symmetric(horizontal: 4),
                                    child: Image.asset(
                                      'assets/images/corona.jpg',
                                      height: screenHeight,
                                      width: screenWidth,
                                    ),
                                  ),
                                  Container(
                                    margin: EdgeInsets.symmetric(
                                        vertical: 45, horizontal: 5),
                                    decoration: BoxDecoration(
                                        color: new Color.fromARGB(
                                            90, 108, 99, 255)),
                                  ),
                                  Text(
                                    "Corona",
                                    style: TextStyle(
                                        fontSize: 28,
                                        fontWeight: FontWeight.bold,
                                        color: Colors.white),
                                  )
                                ]),
                          ),
                          GestureDetector(
                            onTap: () {
                              Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) =>
                                          SearchNews(search: "stop corona")));
                            },
                            child: Stack(
                                alignment: Alignment(0, 0),
                                children: <Widget>[
                                  Container(
                                    margin: EdgeInsets.symmetric(horizontal: 4),
                                    child: Image.asset(
                                      'assets/images/stopcorona.jpg',
                                      height: screenHeight,
                                      width: screenWidth,
                                    ),
                                  ),
                                  Container(
                                    margin: EdgeInsets.symmetric(
                                        vertical: 5, horizontal: 5),
                                    decoration: BoxDecoration(
                                        color: new Color.fromARGB(
                                            90, 108, 99, 255)),
                                  ),
                                  Text(
                                    "5 Things to stop corona",
                                    style: TextStyle(
                                        fontSize: 28,
                                        fontWeight: FontWeight.bold,
                                        color: Colors.white),
                                  )
                                ]),
                          ),
                          GestureDetector(
                            onTap: () {
                              Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) =>
                                          SearchNews(search: "social media")));
                            },
                            child: Stack(
                                alignment: Alignment(0, 0),
                                children: <Widget>[
                                  Container(
                                    margin: EdgeInsets.symmetric(horizontal: 4),
                                    child: Image.asset(
                                      'assets/images/social.jpg',
                                      height: screenHeight,
                                      width: screenWidth,
                                    ),
                                  ),
                                  Container(
                                    margin: EdgeInsets.symmetric(
                                        vertical: 5, horizontal: 5),
                                    decoration: BoxDecoration(
                                        color: new Color.fromARGB(
                                            90, 108, 99, 255)),
                                  ),
                                  Text(
                                    "Social Media",
                                    style: TextStyle(
                                        fontSize: 28,
                                        fontWeight: FontWeight.bold,
                                        color: Colors.white),
                                  )
                                ]),
                          ),
                          GestureDetector(
                            onTap: () {
                              Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) =>
                                          SearchNews(search: "music")));
                            },
                            child: Stack(
                                alignment: Alignment(0, 0),
                                children: <Widget>[
                                  Container(
                                    margin: EdgeInsets.symmetric(horizontal: 4),
                                    child: Image.asset(
                                      'assets/images/music.jpeg',
                                      height: screenHeight,
                                      width: screenWidth,
                                    ),
                                  ),
                                  Container(
                                    margin: EdgeInsets.symmetric(
                                        vertical: 5, horizontal: 5),
                                    decoration: BoxDecoration(
                                        color: new Color.fromARGB(
                                            90, 108, 99, 255)),
                                  ),
                                  Text(
                                    "Music",
                                    style: TextStyle(
                                        fontSize: 28,
                                        fontWeight: FontWeight.bold,
                                        color: Colors.white),
                                  )
                                ]),
                          ),
                        ],
                      ),
                    ),
                    SizedBox(height: 20),
                    Container(
                      child: FutureBuilder<List<Article>>(
                        future: list_articles,
                        builder: (context, snapshot) {
                          if (snapshot.hasError) {
                            return Text("Error: ${snapshot.error}");
                          } else if (snapshot.hasData) {
                            List<Article> articles = snapshot.data;
                            articles.sort((b, a) {
                              return a.publishedAt.compareTo(b.publishedAt);
                            });
                            return ListView.separated(
                              shrinkWrap: true,
                              scrollDirection: Axis.vertical,
                              itemCount: 5,
                              itemBuilder: (context, int index) {
                                if (snapshot.hasData) {
                                  return GestureDetector(
                                    onTap: () {
                                      print(snapshot.data[index]);
                                      Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                              builder: (context) => viewNews(
                                                  article:
                                                      snapshot.data[index])));
                                    },
                                    child: ListTile(
                                      title: Text(
                                        snapshot.data[index].title,
                                      ),
                                      contentPadding: EdgeInsets.all(4),
                                      subtitle: Text(
                                        "Published At: ${DateFormat('dd/MM/yyyy  hh:mm').format(DateTime.parse(snapshot.data[index].publishedAt))}",
                                        style: TextStyle(
                                            color: Theme.of(context)
                                                .primaryColor),
                                      ),
                                      trailing: Image.network(
                                          snapshot.data[index].urlToImage),
                                    ),
                                  );
                                } else {
                                  return CircularProgressIndicator();
                                }
                              },
                              separatorBuilder: (context, index) {
                                return Divider(
                                  height: 15,
                                );
                              },
                            );
                          }
                          return CircularProgressIndicator();
                        },
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class DataSearch extends SearchDelegate<String> {
  final search = [
    "games",
    "corona",
    "trending",
    "stop corona",
    "technology",
    'top news',
    "weather"
  ];

  final recentsearch = ["game", "weather"];

  @override
  List<Widget> buildActions(BuildContext context) {
    return [
      IconButton(
          icon: Icon(Icons.clear),
          onPressed: () {
            query = "";
          })
    ];
  }

  @override
  Widget buildLeading(BuildContext context) {
    return IconButton(
        icon: AnimatedIcon(
            icon: AnimatedIcons.menu_arrow, progress: transitionAnimation),
        onPressed: () {
          close(context, null);
        });
  }

  @override
  Widget buildResults(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Navigator.push(context,
            MaterialPageRoute(builder: (context) => SearchNews(search: query)));
      },
      child: Container(
        color: Colors.white,
        child: Container(
          padding: EdgeInsets.symmetric(vertical: 10, horizontal: 10),
          child: Text(
            query,
            style: TextStyle(color: Colors.black, fontSize: 28),
          ),
        ),
      ),
    );
  }

  @override
  Widget buildSuggestions(BuildContext context) {
    final suggestionList = query.isEmpty
        ? recentsearch
        : search.where((p) => p.toLowerCase().startsWith(query)).toList();
    return ListView.builder(
      itemBuilder: (context, index) => ListTile(
        onTap: () {
          // query = query == null ? "Breaking-news" : query;
          // print(query);
          // Navigator.push(context, MaterialPageRoute(builder: (context) => SearchNews(search: query)));
          showResults(context);
        },
        leading: Icon(Icons.av_timer),
        title: RichText(
            text: TextSpan(
                text: suggestionList[index].substring(0, query.length),
                style:
                    TextStyle(color: Colors.black, fontWeight: FontWeight.bold),
                children: [
              TextSpan(
                  text: suggestionList[index].substring(query.length),
                  style: TextStyle(color: Colors.grey))
            ])),
      ),
      itemCount: suggestionList.length,
    );
  }
}
