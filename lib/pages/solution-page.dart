import 'package:daily_coding_challenges/widgets/app-bar.dart';
import 'package:firebase_admob/firebase_admob.dart';
import 'package:flutter/material.dart';
import 'package:daily_coding_challenges/shared/admob.dart';
import 'package:daily_coding_challenges/shared/check-internet-connection.dart';

class SolutionPage extends StatefulWidget {
  final title;
  final question;
  final solution;
  final soltype;
  SolutionPage({this.title, this.question, this.solution, this.soltype});
  @override
  _SolutionPageState createState() => _SolutionPageState();
}

class _SolutionPageState extends State<SolutionPage> {
  @override
  void initState() {
    checkInternetConnectivity(context).then((val) {
      val == true ? ShowDialog(context) : print("Connected");
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    FirebaseAdMob.instance
        .initialize(appId: "ca-app-pub-8559543128044506/5082641766")
        .then((response) {
      myBanner
        ..load()
        ..show();
    });
    return Scaffold(
        appBar: appBar(
          "${widget.title}",
          shareTitle: "Question:\n" + widget.question,
          shareSubject:
              "\n---------------------------------------------\nSolution in ${widget.soltype}:\n" +
                  widget.solution,
        ),
        body: ListView(
          children: <Widget>[
            ExpansionTile(
              title: Text(
                "${widget.title}",
                style: TextStyle(fontSize: 24.0),
              ),
              children: <Widget>[
                Padding(
                  padding: const EdgeInsets.all(12.0),
                  child: Text(
                    "${widget.question}",
                    style: Theme.of(context).textTheme.body1,
                  ),
                ),
              ],
            ),
            ExpansionTile(
              title: Text(
                "Solution",
                style: TextStyle(fontSize: 24.0),
              ),
              children: <Widget>[
                Padding(
                  padding: const EdgeInsets.all(12.0),
                  child: Text(
                    "${widget.solution}",
                    style: Theme.of(context).textTheme.body1,
                  ),
                )
              ],
            ),
          ],
        ));
  }
}
