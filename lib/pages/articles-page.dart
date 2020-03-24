import 'package:daily_coding_challenges/pages/articles-detail.dart';
import 'package:daily_coding_challenges/shared/check-internet-connection.dart';
import 'package:daily_coding_challenges/crud.dart';
import 'package:daily_coding_challenges/widgets/app-bar.dart';
import 'package:firebase_admob/firebase_admob.dart';
import 'package:flutter/material.dart';
import 'package:daily_coding_challenges/shared/admob.dart';

class ArticlesPage extends StatefulWidget {
  @override
  _ArticlesPageState createState() => _ArticlesPageState();
}

class _ArticlesPageState extends State<ArticlesPage> {
  CrudMethods crudObj = new CrudMethods();
  var articles;

  @override
  void initState() {
    checkInternetConnectivity(context).then((val) {
      val == true ? ShowDialog(context) : print("Connected");
    });
    crudObj.getArticles().then((results) {
      setState(() {
        articles = results;
      });
    });
    super.initState();
  }

  Future<void> _onRefresh() async {
    crudObj.getArticles().then((results) {
      setState(() {
        articles = results;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    FirebaseAdMob.instance
        .initialize(appId: "ca-app-pub-8559543128044506/5082641766")
        .then((response) {
      myBanner
        ..load()
        ..show();
    }).catchError((e) {
      print(e);
    });

    return Scaffold(
      appBar: appBar("Articles"),
      body: RefreshIndicator(onRefresh: _onRefresh, child: _dataList()),
    );
  }

  Widget _dataList() {
    if (articles != null) {
      return Column(
        children: <Widget>[
          Flexible(
            child: StreamBuilder(
                stream: articles,
                builder: (context, snapshot) {
                  if (snapshot.data == null)
                    return Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Center(
                          child: new LinearProgressIndicator(
                        backgroundColor: Color(0xFF5AFF15),
                      )),
                    );
                  var length = snapshot.data.documents.length;
                  return Scrollbar(
                    child: ListView.builder(
                        itemCount: snapshot.data.documents.length,
                        itemBuilder: (context, i) {
                          var title = snapshot
                              .data.documents[length - i - 1].data['title'];
                          var description = snapshot.data
                              .documents[length - i - 1].data['description'];
                          var dateposted = snapshot.data
                              .documents[length - i - 1].data['dateposted'];
                          var shortdesc = snapshot.data
                              .documents[length - i - 1].data['short_desc'];
                          var imageurl = snapshot
                              .data.documents[length - i - 1].data['imageurl'];
                          return GestureDetector(
                            onTap: () {
                              Navigator.of(context).push(MaterialPageRoute(
                                  builder: (context) => ArticlesDetail(
                                        title: title,
                                        description: description,
                                        dateposted: dateposted,
                                        shortdesc: shortdesc,
                                      )));
                            },
                            child: Card(
                              margin: EdgeInsets.all(8.0),
                              color: Colors.white24,
                              shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(8.0)),
                              child: Column(
                                children: <Widget>[
                                  new Container(
                                    child: Padding(
                                      padding: const EdgeInsets.all(8.0),
                                      child: imageurl != ""
                                          ? Image.network(
                                              imageurl,
                                              fit: BoxFit.contain,
                                            )
                                          : LinearProgressIndicator(
                                              backgroundColor:
                                                  Color(0xFF5AFF15),
                                            ),
                                    ),
                                  ),
                                  new ListTile(
                                    title: Text(
                                      title.toString().toUpperCase(),
                                      style: new TextStyle(
                                          fontSize: 18.0,
                                          fontWeight: FontWeight.bold,
                                          color: Colors.greenAccent),
                                    ),
                                    subtitle: Text(
                                      "Date Posted: $dateposted",
                                      style: new TextStyle(
                                        fontSize: 16.0,
                                        fontWeight: FontWeight.w600,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          );
                        }),
                  );
                }),
          ),
          new SizedBox(
            height: 60.0,
          ),
        ],
      );
    } else {
      return Padding(
        padding: const EdgeInsets.all(10.0),
        child: Center(
          child: LinearProgressIndicator(backgroundColor: Colors.green),
        ),
      );
    }
  }
}
