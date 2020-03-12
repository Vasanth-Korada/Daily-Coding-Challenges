import 'package:daily_coding_challenges/widgets/app-bar.dart';
import 'package:firebase_admob/firebase_admob.dart';
import 'package:flutter/material.dart';
import 'package:daily_coding_challenges/shared/admob.dart';
import 'package:daily_coding_challenges/shared/check-internet-connection.dart';

class ArticlesDetail extends StatefulWidget {
  final title;
  final description;
  final shortdesc;
  final dateposted;

  ArticlesDetail(
      {this.title, this.description, this.dateposted, this.shortdesc});
  @override
  _ArticlesDetailState createState() => _ArticlesDetailState();
}

class _ArticlesDetailState extends State<ArticlesDetail> {
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
        appBar: appBar("${widget.title}",shareTitle: "Article:\n\n" + widget.title,
          shareSubject:
              "\n---------------------------------------------\n"+
                  widget.shortdesc+ "\n\nTo read more ...",),
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
                    "${widget.shortdesc}",
                    style: Theme.of(context).textTheme.body1,
                  ),
                )
              ],
            ),
            ExpansionTile(
              title: Text(
                "Read Full Article",
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
            )
          ],
        ));
  }
}
