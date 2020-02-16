import 'package:daily_coding_challenges/widgets/share-widget.dart';
import 'package:firebase_admob/firebase_admob.dart';
import 'package:flutter/material.dart';

import 'shared/admob.dart';

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
  Widget build(BuildContext context) {
    FirebaseAdMob.instance
        .initialize(appId: "ca-app-pub-8559543128044506~6027702558")
        .then((response) {
      myBanner
        ..load()
        ..show();
    });
    return Scaffold(
        appBar: AppBar(
          actions: <Widget>[
            IconButton(
              onPressed: () {
                share();
              },
              icon: Icon(Icons.share),
            )
          ],
          title: Text("${widget.title}"),
          centerTitle: true,
          flexibleSpace: Container(
            decoration: BoxDecoration(
                gradient: LinearGradient(
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                    colors: [
                  Color(0xFF5AFF15),
                  Color(0xFF00B712),
                ])),
          ),
        ),
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

