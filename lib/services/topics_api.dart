import 'dart:io';
import 'dart:math';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';
import 'package:http/http.dart' as http;
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';

class OnlineRequests {
  CollectionReference topics = FirebaseFirestore.instance.collection('topics');
  Future getTopics(String level) async{
    QuerySnapshot querySnapshot = await topics
                                        .where('level', isEqualTo: level)
                                        .get();
    final allData = querySnapshot.docs.map(
            (doc){
          Map value = doc.data() as Map;
          value['id'] = doc.id;
          return value;
        }
    ).toList();

    return allData;
  }
}