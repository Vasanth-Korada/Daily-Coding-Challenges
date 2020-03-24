import 'package:daily_coding_challenges/crud.dart';
import 'package:daily_coding_challenges/pages/solution-page.dart';
import 'package:daily_coding_challenges/widgets/app-bar.dart';
import 'package:firebase_admob/firebase_admob.dart';
import 'package:flutter/material.dart';
import 'package:daily_coding_challenges/shared/admob.dart';
import 'package:daily_coding_challenges/shared/check-internet-connection.dart';

class CategorizedChallenges extends StatefulWidget {
  final challengeType;
  final appbarTitle;
  CategorizedChallenges({this.challengeType, this.appbarTitle});
  @override
  _CategorizedChallengesState createState() => _CategorizedChallengesState();
}

class _CategorizedChallengesState extends State<CategorizedChallenges> {
  CrudMethods crudObj = new CrudMethods();
  var posts;

  @override
  void initState() {
    checkInternetConnectivity(context).then((val) {
      val == true ? ShowDialog(context) : print("Connected");
    });
    crudObj.getData().then((results) {
      setState(() {
        posts = results;
      });
    });
    super.initState();
  }

  Future<void> _onRefresh() async {
    crudObj.getData().then((results) {
      setState(() {
        posts = results;
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
      appBar: appBar("${widget.appbarTitle}"),
      body: RefreshIndicator(onRefresh: _onRefresh, child: _dataList()),
    );
  }

  Widget _dataList() {
    if (posts != null) {
      return Column(
        children: <Widget>[
          Expanded(
            flex: 8,
            child: StreamBuilder(
                stream: posts,
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
                        shrinkWrap: true,
                        itemCount: snapshot.data.documents.length,
                        itemBuilder: (context, i) {
                          var title = snapshot
                              .data.documents[length - i - 1].data['title'];
                          var question = snapshot
                              .data.documents[length - i - 1].data['question'];
                          var solution = snapshot
                              .data.documents[length - i - 1].data['solution'];
                          var soltype = snapshot
                              .data.documents[length - i - 1].data['soltype'];
                          if (soltype == widget.challengeType) {
                            return Card(
                              margin: EdgeInsets.all(8.0),
                              color: Colors.white24,
                              shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(8.0)),
                              child: new ListTile(
                                title: Text(
                                  title.toString().toUpperCase(),
                                  style: new TextStyle(
                                      fontSize: 18.0,
                                      fontWeight: FontWeight.bold,
                                      color: Colors.greenAccent),
                                ),
                                subtitle: Text(
                                  "Solution available in $soltype",
                                  style: new TextStyle(
                                    fontSize: 16.0,
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                                onTap: () {
                                  Navigator.of(context).push(MaterialPageRoute(
                                      builder: (context) => SolutionPage(
                                            title: title,
                                            question: question,
                                            solution: solution,
                                            soltype: soltype,
                                          )));
                                },
                              ),
                            );
                          } else {
                            return Container();
                          }
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
