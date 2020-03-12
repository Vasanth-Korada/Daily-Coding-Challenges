import 'package:daily_coding_challenges/widgets/app-bar.dart';
import 'package:firebase_admob/firebase_admob.dart';
import 'package:flutter/material.dart';
import 'package:daily_coding_challenges/shared/admob.dart';
import 'package:daily_coding_challenges/shared/check-internet-connection.dart';

class ConceptsDetail extends StatefulWidget {
  final title;
  final description;
  final example;
  final lang;
  ConceptsDetail({this.title, this.description, this.example, this.lang});
  @override
  _ConceptsDetailState createState() => _ConceptsDetailState();
}

class _ConceptsDetailState extends State<ConceptsDetail> {
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
        appBar: appBar("${widget.title}",shareTitle: "Concept in ${widget.lang}:\n\n" + "Name:"+widget.title+"\n\n"+widget.description,
          shareSubject:
              "\n---------------------------------------------\nExample:\n" +
                  widget.example,),
        body: ListView(
          children: <Widget>[
            ExpansionTile(
              title: Text(
                "${widget.title} in ${widget.lang}",
                style: TextStyle(fontSize: 24.0),
              ),
              children: <Widget>[
                Padding(
                  padding: const EdgeInsets.all(12.0),
                  child: Text(
                    "${widget.description}",
                    style: Theme.of(context).textTheme.body1,
                  ),
                )
              ],
            ),
            ExpansionTile(
              title: Text(
                "Example",
                style: TextStyle(fontSize: 24.0),
              ),
              children: <Widget>[
                Padding(
                  padding: const EdgeInsets.all(12.0),
                  child: Text(
                    "${widget.example}",
                    style: Theme.of(context).textTheme.body1,
                  ),
                )
              ],
            )
          ],
        ));
  }
}
