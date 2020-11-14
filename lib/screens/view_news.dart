// import 'package:advanced_share/advanced_share.dart';
import 'package:flutter/material.dart';
import 'package:image_picker_saver/image_picker_saver.dart';
import 'package:intl/intl.dart';
import 'package:newsup/model/model.dart';
import 'package:share/share.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:http/http.dart';

class viewNews extends StatefulWidget {
  final Article article;
  viewNews({Key key, @required this.article}) : super(key: key);

  @override
  _viewNewsState createState() => _viewNewsState();
}

class _viewNewsState extends State<viewNews> {
  @override
  void initState() {
    super.initState();
    print(widget.article.author);
    _onImageSave();
  }

  _onImageSave() async {
    // var filePath = await ImagePickerSaver.saveFile(fileData: widget.article.urlToImage.bodyBytes);

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
          GestureDetector(
            child: Padding(
              padding: const EdgeInsets.only(right:15.0),
              child: Icon(
                Icons.share,
                size: 20,
                color: Theme.of(context).primaryColor,
              ),
            ),
            onTap: () {
               Share.share(widget.article.title, subject: widget.article.author,);
            },
          ),
          // RaisedButton(onPressed: (){
          //       // AdvancedShare.generic(url: widget.article.url, msg: widget.article.urlToImage, title: widget.article.title);
          //   Share.share("Hii", subject: "Hello");
          // },
          // child: Text("Share"),)
        ],
        title: Center(
          child: Text(
            widget.article.source.name,
            textAlign: TextAlign.center,
            style: TextStyle(color: Theme.of(context).primaryColor),
          ),
        ),
      ),
      body: Container(
        margin: EdgeInsets.symmetric(horizontal: 5),
        child: GestureDetector(
          onTap: () {
            // print(widget.article.url);

            _launchUrl(widget.article.url);
          },
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              Column(
                children: <Widget>[
                  Container(
                    child: widget.article.urlToImage == null
                        ? Image.asset('assets/images/newsup.png')
                        : Image.network(
                            widget.article.urlToImage,
                          ),
                  ),
                  SizedBox(height: 20),
                  Column(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: <Widget>[
                      Container(
                        margin: EdgeInsets.all(5),
                        child: Text(
                            widget.article.title == null
                                ? "Breaking News"
                                : widget.article.title,
                            style: TextStyle(
                                color: Colors.black,
                                fontWeight: FontWeight.bold,
                                fontSize: 20)),
                      ),
                      // SizedBox(height:),
                      Container(
                        margin: EdgeInsets.all(5),
                        child: Text(
                            widget.article.description == null
                                ? "Description"
                                : widget.article.description,
                            style: TextStyle(color: Colors.grey, fontSize: 18)),
                      ),
                    ],
                  ),
                ],
              ),
              Container(
                padding: EdgeInsets.symmetric(horizontal: 10, vertical: 20),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: <Widget>[
                    Text(DateFormat('dd/MM/yyyy  hh:mm').format(
                                DateTime.parse(widget.article.publishedAt)) ==
                            null
                        ? ""
                        : DateFormat('dd/MM/yyyy  hh:mm').format(
                            DateTime.parse(widget.article.publishedAt))),
                    Text(widget.article.author == null
                        ? ""
                        : widget.article.author.length > 50
                            ? ""
                            : widget.article.author)
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  _launchUrl(String url) async {
    if (await canLaunch(url)) {
      await launch(url);
    } else {
      throw ('Couldnt launch $url');
    }
  }
}
