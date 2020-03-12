import 'package:animated_text_kit/animated_text_kit.dart';
import 'package:daily_coding_challenges/home-page.dart';
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:modal_progress_hud/modal_progress_hud.dart';
import 'package:daily_coding_challenges/shared/check-internet-connection.dart';

class IsLogged {
  static bool isloggedin = false;
  static String name = '';
}

class SignIn extends StatefulWidget {
  @override
  _SignInState createState() => _SignInState();
}

class _SignInState extends State<SignIn> {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  GoogleSignIn _googleSignIn = GoogleSignIn(scopes: ['email']);
  FirebaseUser user;
  FirebaseUser currentUser;
  bool _loading = false;

  _login() async {
    try {
      final SharedPreferences prefs = await SharedPreferences.getInstance();
      final GoogleSignInAccount googleSignInAccount =
          await _googleSignIn.signIn();
      final GoogleSignInAuthentication googleSignInAuthentication =
          await googleSignInAccount.authentication;

      final AuthCredential credential = GoogleAuthProvider.getCredential(
        accessToken: googleSignInAuthentication.accessToken,
        idToken: googleSignInAuthentication.idToken,
      );

      final AuthResult authResult =
          await _auth.signInWithCredential(credential);
      user = authResult.user;
      currentUser = await _auth.currentUser();
      prefs.setString('username', _googleSignIn.currentUser.displayName);
      prefs.setString('useremail', _googleSignIn.currentUser.email);
      prefs.setString('userphoto', _googleSignIn.currentUser.photoUrl);
      setState(() {
        IsLogged.name = _googleSignIn.currentUser.displayName;
        IsLogged.isloggedin = true;
      });
      Navigator.of(context).pushReplacement(MaterialPageRoute(
          builder: (context) => HomePage(
                userName: _googleSignIn.currentUser.displayName,
                userEmail: _googleSignIn.currentUser.email,
                userPhoto: _googleSignIn.currentUser.photoUrl,
              )));
    } catch (err) {
      print(err);
    }
  }

  void autoLogIn() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    final String userId = prefs.getString('username');
    final String useremail = prefs.getString('useremail');
    final String userphoto = prefs.getString('userphoto');
    if (userId != null) {
      setState(() {
        IsLogged.isloggedin = true;
        IsLogged.name = userId;
        Navigator.of(context).pushReplacement(MaterialPageRoute(
            builder: (context) => HomePage(
                  userName: userId,
                  userEmail: useremail,
                  userPhoto: userphoto,
                )));
      });
      return;
    }
  }

  @override
  void initState() {
    autoLogIn();
    checkInternetConnectivity(context).then((val) {
      val == true ? ShowDialog(context) : print("Connected");
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: ModalProgressHUD(
        inAsyncCall: _loading,
        color: Colors.white70,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Container(
              height: 350.0,
              child: Center(
                child: Image.asset('assets/cloud.png'),
              ),
            ),
            SizedBox(
              height: 25.0,
            ),
            Center(
              child: TypewriterAnimatedTextKit(
                  speed: Duration(milliseconds: 200),
                  text: [
                    "Daily Coding Challenges",
                  ],
                  textStyle:
                      TextStyle(fontSize: 38.0, fontWeight: FontWeight.w800),
                  textAlign: TextAlign.center,
                  alignment:
                      AlignmentDirectional.topStart // or Alignment.topLeft
                  ),
            ),
            SizedBox(
              height: 20.0,
            ),
            _signInButton(),
          ],
        ),
      ),
    );
  }

  Widget _signInButton() {
    return OutlineButton(
      splashColor: Colors.grey,
      onPressed: () {
        setState(() {
          _loading = true;
        });
        _login();
      },
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(40)),
      highlightElevation: 0,
      borderSide: BorderSide(color: Colors.grey),
      child: Padding(
        padding: const EdgeInsets.fromLTRB(0, 10, 0, 10),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Image(image: AssetImage("assets/google_logo.png"), height: 35.0),
            Padding(
              padding: const EdgeInsets.only(left: 10),
              child: Text(
                'Sign in with Google',
                style: TextStyle(
                  fontSize: 20,
                  color: Colors.white,
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}
