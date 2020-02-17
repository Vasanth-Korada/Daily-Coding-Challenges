import 'package:daily_coding_challenges/widgets/share-widget.dart';
import 'package:flutter/material.dart';

Widget appBar(String title) {
  return AppBar(
    actions: <Widget>[
      IconButton(
        onPressed: () {
          share();
        },
        icon: Icon(Icons.share),
      )
    ],
    title: Text(title),
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
  );
}
