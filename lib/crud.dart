import 'package:cloud_firestore/cloud_firestore.dart';
import 'dart:async';

class CrudMethods {
  Future<void> addData(data) async {
    Firestore.instance.runTransaction((Transaction crudTransaction) async {
      CollectionReference reference =
          Firestore.instance.collection('Posts');
      reference.add(data);
    });
  }

  Future<void> addToken(data) async {
    Firestore.instance.runTransaction((Transaction crudTransaction) async {
      CollectionReference reference =
          Firestore.instance.collection('pushtokens');
      reference.add(data);
    });
  }

  getData() async {
    return Firestore.instance.collection('Posts').snapshots();
  }
  getConcepts() async {
    return Firestore.instance.collection('Concepts').snapshots();
  }

}
