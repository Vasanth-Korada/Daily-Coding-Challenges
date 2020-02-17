import 'package:daily_coding_challenges/widgets/app-bar.dart';
import 'package:flutter/material.dart';

class CodingQuiz extends StatefulWidget {
  @override
  _CodingQuizState createState() => _CodingQuizState();
}

class _CodingQuizState extends State<CodingQuiz> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: appBar("Coding Quiz"),
    );
  }
}
