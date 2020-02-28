import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:daily_coding_challenges/pages/articles-page.dart';
import 'package:daily_coding_challenges/pages/coding-concepts.dart';
import 'package:daily_coding_challenges/widgets/share-widget.dart';
import 'package:daily_coding_challenges/pages/signin-page.dart';
import 'package:daily_coding_challenges/pages/solution-page.dart';
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:url_launcher/url_launcher.dart';
import 'crud.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:firebase_admob/firebase_admob.dart';
import 'shared/admob.dart';

class HomePage extends StatefulWidget {
  final userName;
  final userEmail;
  final userPhoto;
  HomePage({this.userName, this.userEmail, this.userPhoto});
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  CrudMethods crudObj = new CrudMethods();
  GoogleSignIn _googleSignIn = GoogleSignIn(scopes: ['email']);
  final FirebaseMessaging _fcm = FirebaseMessaging();
  final Firestore _db = Firestore.instance;
  var posts;
  Icon searchIcon = new Icon(Icons.search);
  _launchRateUs() async {
    const url =
        'https://play.google.com/store/apps/details?id=com.vktech.daily_coding_challenges';
    if (await canLaunch(url)) {
      await launch(url);
    } else {
      throw 'Could not launch $url';
    }
  }

  _logout() async {
    _googleSignIn.signOut();
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setString('username', null);
    setState(() {
      IsLogged.name = '';
      IsLogged.isloggedin = false;
    });

    Navigator.of(context)
        .pushReplacement(MaterialPageRoute(builder: (context) => SignIn()));
  }

  Future<void> _onRefresh() async {
    crudObj.getData().then((results) {
      setState(() {
        posts = results;
      });
    });
  }

  _saveDeviceToken() async {
    String fcmToken = await _fcm.getToken();
    if (fcmToken != null) {
      var tokens = _db.collection('tokens').document(fcmToken);

      await tokens.setData({
        'token': fcmToken,
        'createdAt': FieldValue.serverTimestamp(),
        'platform': Platform.operatingSystem
      });
    }
  }

  @override
  void initState() {
    super.initState();
    crudObj.getData().then((results) {
      setState(() {
        posts = results;
      });
    });
    _saveDeviceToken();
    _fcm.configure(
      onMessage: (Map<String, dynamic> message) async {
        print("onMessage: $message");
        showDialog(
          context: context,
          builder: (context) => AlertDialog(
            content: ListTile(
              title: Text(message['notification']['title']),
              subtitle: Text(message['notification']['body']),
            ),
            actions: <Widget>[
              FlatButton(
                child: Text('OK'),
                onPressed: () => Navigator.of(context).pop(),
              ),
            ],
          ),
        );
      },
      onLaunch: (Map<String, dynamic> message) async {
        print("onLaunch: $message");
      },
      onResume: (Map<String, dynamic> message) async {
        print("onResume: $message");
      },
    );
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
      appBar: AppBar(
        actions: <Widget>[
          // InkWell(
          //   child: IconButton(
          //     onPressed: () {},
          //     icon: searchIcon,
          // //   ),
          // ),
          InkWell(
            child: IconButton(
              onPressed: () {
                share();
              },
              icon: Icon(Icons.share),
            ),
          )
        ],
        title: Text("Daily Coding Challenges"),
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
      drawer: Drawer(
        child: Column(
          children: <Widget>[
            UserAccountsDrawerHeader(
              currentAccountPicture: Container(
                decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    image: DecorationImage(
                        image: NetworkImage(widget.userPhoto != null
                            ? widget.userPhoto
                            : "https://image.flaticon.com/icons/png/512/2419/2419224.png"))),
              ),
              accountEmail: Text("${widget.userEmail}"),
              accountName: Text("${widget.userName}".toUpperCase()),
            ),
            Card(
              margin: EdgeInsets.all(8.0),
              color: Colors.white,
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8.0)),
              child: new ListTile(
                title: Text(
                  "Hi " +
                      widget.userName.toString().split(" ")[0] +
                      " 😃,\nWe are glad that you downloaded our app. And we are happy to inform you that we are striving hard in helping tech enthusiasts with the content in our own small way.",
                  style: new TextStyle(
                      fontSize: 13.0,
                      color: Colors.black),
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: new Divider(color: Colors.white70,),
            ),
            new ListTile(
              onTap: () {
                Navigator.pop(context);
                Navigator.of(context).push(
                    MaterialPageRoute(builder: (context) => CodingConcepts()));
              },
              leading: Icon(Icons.bubble_chart),
              title: Text(
                "Coding Concepts",
                style: TextStyle(fontSize: 16.0),
              ),
            ),
            new ListTile(
              onTap: () {
                Navigator.pop(context);
                Navigator.of(context).push(
                    MaterialPageRoute(builder: (context) => ArticlesPage()));
              },
              leading: Icon(Icons.library_books),
              title: Text(
                "Articles",
                style: TextStyle(fontSize: 16.0),
              ),
            ),
            new ListTile(
              onTap: () {
                Navigator.pop(context);
                _launchRateUs();
              },
              leading: Icon(Icons.rate_review),
              title: Text(
                "Rate Us",
                style: TextStyle(fontSize: 16.0),
              ),
            ),
            new ListTile(
              onTap: () {
                Navigator.pop(context);
                share();
              },
              leading: Icon(Icons.share),
              title: Text(
                "Share",
                style: TextStyle(fontSize: 16.0),
              ),
            ),
            new ListTile(
              onTap: () {
                _logout();
              },
              leading: Icon(Icons.power_settings_new),
              title: Text("Logout", style: TextStyle(fontSize: 16.0)),
            )
          ],
        ),
      ),
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
            var length = snapshot.data.documents.length;

            return Scrollbar(
              child: ListView.builder(
                  itemCount: snapshot.data.documents.length,
                  itemBuilder: (context, i) {
                    var title =
                        snapshot.data.documents[length - i - 1].data['title'];
                    var question = snapshot
                        .data.documents[length - i - 1].data['question'];
                    var solution = snapshot
                        .data.documents[length - i - 1].data['solution'];
                    var soltype =
                        snapshot.data.documents[length - i - 1].data['soltype'];
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
