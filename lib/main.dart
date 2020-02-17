import 'package:daily_coding_challenges/signin-page.dart';
import 'package:flutter/material.dart';
import 'home-page.dart';

void main() => runApp(MaterialApp(
      debugShowCheckedModeBanner: false,
      title: "Daily Coding Challenges",
      home: HomePage(),//SignIn()
      theme: ThemeData(
        fontFamily: 'Open Sans SemiBold',
        brightness: Brightness.dark,
        primaryColor: Color(0xFF1BA94C),
        accentColor: Color(0xFF1BA94C),
        textTheme: TextTheme(
          headline: TextStyle(fontSize: 72.0, fontWeight: FontWeight.bold),
          title: TextStyle(fontSize: 30.0, fontStyle: FontStyle.normal),
          body1: TextStyle(
            fontSize: 16.0,
          ),
        ),
      ),
    ));
