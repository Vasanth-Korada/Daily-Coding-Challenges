import 'package:daily_coding_challenges/pages/coding-concepts.dart';
import 'package:daily_coding_challenges/widgets/app-bar.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../crud.dart';
import '../shared/check-internet-connection.dart';

class ConceptsCategories extends StatefulWidget {
  @override
  _ConceptsCategoriesState createState() => _ConceptsCategoriesState();
}

class _ConceptsCategoriesState extends State<ConceptsCategories> {
  CrudMethods crudObj = new CrudMethods();
  var categories;
  DocumentSnapshot imageurl;

  getImagesUrls() {
    Firestore.instance
        .collection("Assets")
        .document("imageurls")
        .snapshots()
        .forEach((url) {
      imageurl = url;
    });
  }

  @override
  void initState() {
    checkInternetConnectivity(context).then((val) {
      val == true ? ShowDialog(context) : print("Connected");
    });
    getImagesUrls();
    crudObj.getConceptsCategories().then((results) {
      setState(() {
        categories = results;
      });
    });

    super.initState();
  }

  Future<void> _onRefresh() async {
    crudObj.getConceptsCategories().then((results) {
      setState(() {
        getImagesUrls();
        categories = results;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: appBar("Choose a Language"),
      body: RefreshIndicator(onRefresh: _onRefresh, child: _categoriesList()),
    );
  }

  Widget _categoriesList() {
    if (categories != null) {
      return StreamBuilder(
          stream: categories,
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
                  itemCount: snapshot.data['names'].length,
                  itemBuilder: (context, i) {
                    var conceptType = snapshot.data.data['names'];
                    return GestureDetector(
                      onTap: () {
                        debugPrint(conceptType[i]);
                        Navigator.of(context).push(MaterialPageRoute(
                            builder: (context) => CodingConcepts(
                                  conceptType: conceptType[i],
                                  appbarTitle: conceptType[i],
                                )));
                      },
                      child: Card(
                        margin: EdgeInsets.all(8.0),
                        color: Colors.white24,
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8.0)),
                        child: Column(
                          children: <Widget>[
                            imageurl[conceptType[i]] != ""
                                ? Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: Image.network(
                                      imageurl[conceptType[i]],
                                      fit: BoxFit.fitWidth,
                                    ),
                                  )
                                : LinearProgressIndicator(
                                    backgroundColor: Color(0xFF5AFF15),
                                  ),
                            new ListTile(
                              title: Text(
                                conceptType[i].toString().toUpperCase(),
                                textAlign: TextAlign.center,
                                style: new TextStyle(
                                    fontSize: 18.0,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.greenAccent),
                              ),
                            ),
                          ],
                        ),
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
