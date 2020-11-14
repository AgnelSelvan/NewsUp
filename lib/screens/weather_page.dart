import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:newsup/model/weatherModel.dart';
import 'package:http/http.dart' as http;

String API_KEY = '11a11666463417be2c54e36e429b6e87';

Future<List<Current>> fetchCurrentWeather(String location) async {
  final response = await http.get(
      'http://api.weatherstack.com/current?access_key=${API_KEY}&query=${location}');
  if (response.statusCode == 200) {
    // print(location);
    // print('Success');
    // print(json.decode(response.body)['request']);
    // print(json.decode(response.body)['location']);
    print(json.decode(response.body)['current']);
    // List current = json.decode(response.body)['current'];
    print(json.decode(response.body)['current'].toList().temperature);
    // List currents = json.decode(response.body)['current'];

    // return currents.map((current) => new Current.fromJson(current)).toList();
  } else {
    print("Failed to fetch!");
  }
}

class WeatherPage extends StatefulWidget {
  final String location;
  WeatherPage({Key key, @required this.location}) : super(key: key);

  @override
  _WeatherPageState createState() => _WeatherPageState();
}

class _WeatherPageState extends State<WeatherPage> {
  double screenHeight, screenWidth;
  var list_current;

  @override
  void initState() {
    super.initState();
    setState(() {
      list_current = fetchCurrentWeather(widget.location);
    });
    print(list_current);
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    screenHeight = size.height;
    screenWidth = size.width;
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white10,
        leading: GestureDetector(
          onTap: () {
            Navigator.pop(context);
          },
          child: Icon(Icons.arrow_left),
        ),
        actions: <Widget>[
          Padding(
            padding: EdgeInsets.only(right: 10),
            child: Icon(Icons.search),
          )
        ],
        elevation: 0.0,
        iconTheme: IconThemeData(color: Theme.of(context).primaryColor),
        title: Padding(
          padding: const EdgeInsets.only(right: 40.0),
          child: Center(
            child: Text(
              'Weather Up',
              textAlign: TextAlign.center,
              style: TextStyle(
                  color: Theme.of(context).primaryColor,
                  fontWeight: FontWeight.bold,
                  fontSize: 24),
            ),
          ),
        ),
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: <Widget>[
          // Container(
          //   height: 50,
          //   margin: EdgeInsets.symmetric(horizontal: 40, vertical: 10),
          //   child: ClipRRect(
          //     borderRadius: BorderRadius.circular(8.0),
          //     clipBehavior: Clip.hardEdge,
          //     child: Container(
          //       color: Color(0xffD8DBDF),
          //       child: Row(
          //         children: <Widget>[
          //           SizedBox(width: 20),
          //           Icon(Icons.search),
          //           SizedBox(width: 15),
          //           Text("Search")
          //         ],
          //       ),
          //     ),

          //   )
          // ),
          Container(
            child: Column(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: <Widget>[
                      Center(
                        child: Container(
                          child: Column(
                            children: <Widget>[
                              Icon(
                                Icons.wb_sunny,
                                size: 28,
                                color: Colors.orange,
                              ),
                              Text(
                                "32.1°",
                                style: TextStyle(
                                    color: Colors.black,
                                    fontSize: 48,
                                    fontWeight: FontWeight.bold),
                              ),
                              Text(
                                "Mumbai, Maharashtra",
                                style: TextStyle(color: Colors.grey),
                              ),
                              SizedBox(height: 30),
                              Container(
                                child: ClipRRect(
                                  borderRadius: BorderRadius.circular(8),
                                  child: Container(
                                    color: Colors.grey,
                                    child: Padding(
                                      padding: const EdgeInsets.all(8.0),
                                      child: Text("It's Smoke",
                                          style:
                                              TextStyle(color: Colors.white)),
                                    ),
                                  ),
                                ),
                              ),
                              SizedBox(
                                height: 30,
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
          ),
          
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: Container(
              alignment: Alignment.topLeft,
              child: Column(
                children: <Widget>[
                  Text(
                    "Additional Info",
                    style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                  ),
                  SizedBox(height: 20),
                  Container(
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                        Container(
                          child: Column(
                            children: <Widget>[
                              Text(
                                "65%",
                                style: TextStyle(
                                    fontWeight: FontWeight.bold, fontSize: 24),
                              ),
                              Text(
                                "Humidity",
                              ),
                            ],
                          ),
                        ),
                        SizedBox(width: 20),
                        Container(
                            height: 50,
                            decoration: new BoxDecoration(
                              border: Border(
                                top: BorderSide(width: 0.3, color: Colors.grey),
                                left:
                                    BorderSide(width: 0.3, color: Colors.grey),
                                right:
                                    BorderSide(width: 0.3, color: Colors.grey),
                                bottom:
                                    BorderSide(width: 0.3, color: Colors.grey),
                              ),
                            )),
                        SizedBox(width: 20),
                        Container(
                          child: Column(
                            children: <Widget>[
                              Text(
                                "65%",
                                style: TextStyle(
                                    fontWeight: FontWeight.bold, fontSize: 24),
                              ),
                              Text(
                                "Visibility",
                              ),
                            ],
                          ),
                        ),
                        SizedBox(width: 20),
                        Container(
                            height: 50,
                            decoration: new BoxDecoration(
                              border: Border(
                                top: BorderSide(width: 0.3, color: Colors.grey),
                                left:
                                    BorderSide(width: 0.3, color: Colors.grey),
                                right:
                                    BorderSide(width: 0.3, color: Colors.grey),
                                bottom:
                                    BorderSide(width: 0.3, color: Colors.grey),
                              ),
                            )),
                        SizedBox(width: 20),
                        Container(
                          child: Column(
                            children: <Widget>[
                              Text(
                                "1010",
                                style: TextStyle(
                                    fontWeight: FontWeight.bold, fontSize: 24),
                              ),
                              Text(
                                "Pressure",
                              ),
                            ],
                          ),
                        ),
                        // Text("Humidity")
                      ],
                    ),
                  ),
                  SizedBox(height: 30)
                ],
              ),
            ),
          )
        ],
      ),
    );
  }
}
