import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

void main() {
  runApp(MyApp());
}

class News {
  final String title;
  final String description;
  final String author;
  final String urlToImage;

  //this.author,

  News(this.title, this.description, this.author, this.urlToImage);
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: HomePage(),
    );
  }
}

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  var query = "wsj.com";
  var endpoint = "everything";

  Future<List<News>> getNews() async {
    var data = await http.get(
        'http://newsapi.org/v2/$endpoint?domains=$query&apiKey=95fd30be6dd547c882e9e7f93433b3e9');

    var jsonData = json.decode(data.body);
    var newsData = jsonData['articles'];
    List<News> news = [];
    print(newsData);
    for (var data in newsData) {
      News newsItem = News(data['title'], data['description'], data['author'],
          data['urlToImage']);

      print(newsItem);
      news.add(newsItem);
    }

    return news;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("News"),
      ),
      body: Container(
        child: FutureBuilder(
            future: getNews(),
            builder: (BuildContext context, AsyncSnapshot snapshot) {
              if (snapshot.data == null) {
                return Container(
                  child: Center(
                    child: CircularProgressIndicator(),
                  ),
                );
              } else {
                return ListView.builder(
                  itemCount: snapshot.data.length,
                  itemBuilder: (BuildContext context, int index) {
                    return InkWell(
                      onTap: () {
                        News news = News(
                          snapshot.data[index].title,
                          snapshot.data[index].description,
                          snapshot.data[index].author,
                          snapshot.data[index].urlToImage,
                        );

                        Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => Details(news: news)),
                        );
                      },
                      child: Card(
                        child: Row(
                          children: [
                            Container(
                              width: 120,
                              height: 100,
                              child: ClipRRect(
                                borderRadius: BorderRadius.all(
                                  Radius.circular(8),
                                ),
                                child: snapshot.data[index].urlToImage == null
                                    ? Image.network("")
                                    : Image.network(
                                        snapshot.data[index].urlToImage,
                                        fit: BoxFit.cover),
                              ),
                            ),
                            Expanded(
                              child: ListTile(
                                title: Text(snapshot.data[index].title),
                                subtitle: Text(
                                    snapshot.data[index].author == null
                                        ? "unknown Author"
                                        : snapshot.data[index].author),
                              ),
                            )
                          ],
                        ),
                      ),
                    );
                  },
                );
              }
            }),
      ),
    );
  }
}

class Details extends StatelessWidget {
  final News news;
  Details({this.news});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Container(
          child: Column(
            children: <Widget>[
              Stack(
                children: <Widget>[
                  Container(
                    height: 400,
                    child: Image.network(
                      '${this.news.urlToImage}',
                      fit: BoxFit.cover,
                    ),
                  ),
                  AppBar(
                    backgroundColor: Colors.transparent,
                    elevation: 0,
                  ),
                ],
              ),
              Padding(
                padding: const EdgeInsets.all(8),
                child: Column(
                  children: <Widget>[
                    Text(
                      '${this.news.title}',
                      style: TextStyle(
                        color: Colors.black87,
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        letterSpacing: 0.2,
                        wordSpacing: 0.6,
                      ),
                    ),
                    SizedBox(
                      height: 20,
                    ),
                    Text(
                      " ${this.news.description}",
                      style: TextStyle(
                        color: Colors.black45,
                        fontSize: 16,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
