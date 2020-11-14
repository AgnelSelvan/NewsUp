import 'package:flutter/material.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:newsup/screens/search.dart';

class Category extends StatefulWidget {
  Category({Key key}) : super(key: key);

  @override
  CcategoryState createState() => CcategoryState();
}

class CcategoryState extends State<Category> {
  Material MyItems(IconData icon, String heading, int color) {
    return Material(
      color: Colors.white,
      elevation: 4,
      shadowColor: Color(0x802196F3),
      borderRadius: BorderRadius.circular(24),
      child: Center(
        child: Padding(
          padding: EdgeInsets.all(8),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  Padding(
                    padding: EdgeInsets.all(8),
                    child: Text(
                      heading,
                      style: TextStyle(color: Color(color), fontSize: 20),
                    ),
                  ),
                  Material(
                    color: Color(color),
                    borderRadius: BorderRadius.circular(24),
                    child: Padding(
                      padding: EdgeInsets.all(16),
                      child: Icon(
                        icon,
                        size: 30,
                        color: Colors.white,
                      ),
                    ),
                  )
                ],
              ),
            ],
          ),
        ),
      ),
    );
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
            color: Colors.black,
          ),
          onTap: () {
            Navigator.pop(context);
          },
        ),
        actions: <Widget>[
          Icon(
            Icons.search,
            size: 50,
          )
        ],
        title: Center(
          child: Text(
            'News Up',
            textAlign: TextAlign.center,
            style: TextStyle(color: Colors.black),
          ),
        ),
      ),
      body: StaggeredGridView.count(
        crossAxisCount: 2,
        crossAxisSpacing: 10,
        mainAxisSpacing: 12,
        padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        children: <Widget>[
          GestureDetector(
            child: MyItems(Icons.graphic_eq, "General", 0xff6C63FF),
            onTap: () {
              // print("general");
              Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => SearchNews(search: "general")));
            },
          ),
          GestureDetector(
            child: MyItems(Icons.business, "Business", 0xFFFF9800),
            onTap: () {
              // print("general");
              Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => SearchNews(search: "business")));
            },
          ),
          GestureDetector(
            child: MyItems(Icons.play_for_work, "entertainment", 0xFF4CAF50),
            onTap: () {
              // print("general");
              Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) =>
                          SearchNews(search: "entertainment")));
            },
          ),
          GestureDetector(
            child: MyItems(Icons.games, "sports", 0xff2196F3),
            onTap: () {
              // print("general");
              Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => SearchNews(search: "sports")));
            },
          ),
          GestureDetector(
            child: MyItems(Icons.insert_invitation, "technology", 0xFFF44336),
            onTap: () {
              // print("general");
              Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => SearchNews(search: "technology")));
            },
          )
        ],
        staggeredTiles: [
          StaggeredTile.extent(2, 130),
          StaggeredTile.extent(1, 130),
          StaggeredTile.extent(1, 130),
          StaggeredTile.extent(1, 130),
          StaggeredTile.extent(1, 130),
        ],
      ),
    );
  }
}
