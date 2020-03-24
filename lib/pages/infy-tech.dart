import 'dart:async';
import 'dart:convert';

import 'package:daily_coding_challenges/widgets/app-bar.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:webview_flutter/webview_flutter.dart';

class INFYTECH extends StatefulWidget {
  @override
  _INFYTECHState createState() => _INFYTECHState();
}

class _INFYTECHState extends State<INFYTECH> {
  final Completer<WebViewController> _controller =
      Completer<WebViewController>();
  static String api = "AIzaSyDjMRwQ874KEy7lvG7W5zDYtVn2znWtso8";
  static String channelID = "UCuxkk3TD7cfPR08JEWVyXZA";
  var resultyt = [];
  var finalURL =
      "https://www.googleapis.com/youtube/v3/search?key=$api&channelId=$channelID&part=snippet,id&order=date";
  getVideos() async {
    await http.get(finalURL).then((response) {
      var data = jsonDecode(response.body);
      var items = data["items"] as List;
    });
  }

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: appBar("INFY TECH VIDEOS"),
    );
  }
}
