import 'package:daily_coding_challenges/concepts-detailed.dart';
import 'package:daily_coding_challenges/crud.dart';
import 'package:daily_coding_challenges/widgets/app-bar.dart';
import 'package:firebase_admob/firebase_admob.dart';
import 'package:flutter/material.dart';
import 'shared/admob.dart';
import 'widgets/share-widget.dart';

class CodingConcepts extends StatefulWidget {
  @override
  _CodingConceptsState createState() => _CodingConceptsState();
}

class _CodingConceptsState extends State<CodingConcepts> {
  CrudMethods crudObj = new CrudMethods();
  var posts;

  @override
  void initState() {
    super.initState();
    crudObj.getConcepts().then((results) {
      setState(() {
        posts = results;
      });
    });
  }

  Future<void> _onRefresh() async {
    crudObj.getConcepts().then((results) {
      setState(() {
        posts = results;
      });
    });
  }

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
      appBar: appBar("Coding Concepts"),
      body: RefreshIndicator(onRefresh: _onRefresh, child: _dataList()),
    );
  }

  Widget _dataList() {
    if (posts != null) {
      return StreamBuilder(
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
            return Scrollbar(
              child: ListView.builder(
                  itemCount: snapshot.data.documents.length,
                  itemBuilder: (context, i) {
                    var title = snapshot.data.documents[i].data['title'];
                    var description =
                        snapshot.data.documents[i].data['description'];
                    var example = snapshot.data.documents[i].data['example'];
                    var lang = snapshot.data.documents[i].data['lang'];
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
                          "Concept available in $lang",
                          style: new TextStyle(
                            fontSize: 16.0,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        onTap: () {
                          Navigator.of(context).push(MaterialPageRoute(
                              builder: (context) => ConceptsDetail(
                                    title: title,
                                    description: description,
                                    example: example,
                                    lang: lang,
                                  )));
                        },
                      ),
                    );
                  }),
            );
          });
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
