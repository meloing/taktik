import 'dart:io';
import 'dart:math';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';
import 'package:http/http.dart' as http;
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';

class ClubOnlineRequests {
  CollectionReference posts = FirebaseFirestore.instance.collection('posts');
  CollectionReference clubs = FirebaseFirestore.instance.collection('clubs');
  CollectionReference comments = FirebaseFirestore.instance.collection('comments');
  CollectionReference clubMembers = FirebaseFirestore.instance.collection('clubMembers');

  Future getClubs(String lastDate) async{
    QuerySnapshot querySnapshot = await clubs
        .where('clubDate', isGreaterThan: lastDate)
        .get();
    final allData = querySnapshot.docs.map(
            (doc) {
          Map value = doc.data() as Map;
          value['clubId'] = doc.id;
          return value;
        }
    ).toList();

    return allData;
  }

  Future addClubMember(String clubMemberUid, String clubMemberClubId, String clubMemberDate) async {
        return clubMembers
            .add({
          'clubMemberUid': clubMemberUid,
          'clubMemberClubId': clubMemberClubId,
          'clubMemberDate': clubMemberDate
        })
        .then((value) => print("User Added"))
        .catchError((error) => print("Failed to add user: $error"));
  }

  Future getPosts(String clubId) async{
    QuerySnapshot querySnapshot = await posts
        .where('clubId', isEqualTo: clubId)
        .limit(10)
        .get();
    final allData = querySnapshot.docs.map(
            (doc) {
          Map value = doc.data() as Map;
          value['postId'] = doc.id;
          return value;
        }
    ).toList();

    return allData;
  }

  Future getComments(String postId) async{
    QuerySnapshot querySnapshot = await comments
        .where('postId', isEqualTo: postId)
        .limit(10)
        .get();
    final allData = querySnapshot.docs.map(
            (doc) {
          Map value = doc.data() as Map;
          value['commentId'] = doc.id;
          return value;
        }
    ).toList();

    return allData;
  }

  Future addPost(String clubId, String avatar, String pseudo, String description,
      String date, String uid, List imagesAddress) async {
    List images = [];
    if(imagesAddress.isNotEmpty){
      for(var file in imagesAddress){
        final firebaseStorage = FirebaseStorage.instance.ref()
            .child("postImages/${Random().nextInt(999)}.jpg");
        String fileUrl = await (await firebaseStorage.putFile(file).whenComplete(() => null)).ref.getDownloadURL();
        images.add(fileUrl);
      }
    }

    return posts
        .add({
      'uid': uid,
      'date': date,
      'avatar': avatar,
      'pseudo': pseudo,
      "clubId": clubId,
      "images": images,
      'description': description
    })
        .then((value) => print("User Added"))
        .catchError((error) => print("Failed to add user: $error"));
  }

  Future addComment(String postId, String description, String date,
      String uid, String avatar, String pseudo, String imagePath) async {
    String fileUrl = "";
    if(imagePath.isNotEmpty){
      final firebaseStorage = FirebaseStorage.instance.ref()
          .child("postImages/${Random().nextInt(999)}.jpg");
      fileUrl = await (await firebaseStorage.putFile(File(imagePath)).whenComplete(() => null)).ref.getDownloadURL();
    }

    return comments.add({
      'uid': uid,
      'date': date,
      'postId': postId,
      'avatar': avatar,
      'pseudo': pseudo,
      'image': fileUrl,
      'description': description
    })
        .then((value) => print("User Added"))
        .catchError((error) => print("Failed to add user: $error"));
  }

  Future deletePost(String documentId) async{
    await posts.doc(documentId).delete();

    return true;
  }

  Future deleteComment(String documentId) async{
    await comments.doc(documentId).delete();
    return true;
  }
}

class ClubOfflineRequests {

  late Future<Database> database;

  Future createDatabase() async {
    database = openDatabase(join(await getDatabasesPath(), 'totaleReussite.db'));
  }

  Future<void> createClubsTable() async{
    await createDatabase();
    Database db = await database;
    // await db.execute("DROP TABLE IF EXISTS clubs");
    await db.execute(
      "CREATE TABLE IF NOT EXISTS clubs ("
          "clubIdAi INTEGER PRIMARY KEY, "
          "clubId TEXT,"
          "clubName TEXT,"
          "clubDescription TEXT,"
          "clubIcon TEXT,"
          "clubDate TEXT,"
          "isMember TEXT"
          ")",
    );
  }

  Future<void> addClub(String clubId, String clubName, String clubDescription,
      String clubIcon, String clubDate, [isMember="no"]) async {
    await createDatabase();
    final Database db = await database;

    await db.insert(
      'clubs',
      {
        "clubId": clubId,
        "isMember": isMember,
        "clubName": clubName,
        "clubIcon": clubIcon,
        "clubDate": clubDate,
        "clubDescription": clubDescription
      },
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  Future<void> updateClub(String clubId, String clubName, String clubDescription,
      String clubIcon, String clubDate) async {
    await createDatabase();
    final Database db = await database;

    await db.update(
      'clubs',
      {
        "clubId": clubId,
        "clubName": clubName,
        "clubIcon": clubIcon,
        "clubDate": clubDate,
        "clubDescription": clubDescription
      },
      where: "clubId = ?",
      whereArgs: [clubId],
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  Future<void> updateClubIsMember(String isMember, String clubId) async {
    await createDatabase();
    final Database db = await database;

    await db.update(
      'clubs',
      {
        "isMember": isMember
      },
      where: "clubId = ?",
      whereArgs: [clubId],
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  Future<List> getClubs() async {
    await createDatabase();
    final Database db = await database;
    final List<Map<String, dynamic>> maps = await db.query("clubs");

    return List.generate(maps.length, (i) {
      return {
        "clubId": maps[i]["clubId"],
        "clubIcon": maps[i]["clubIcon"],
        "clubName": maps[i]["clubName"],
        "isMember": maps[i]["isMember"],
        "clubDescription": maps[i]["clubDescription"]
      };
    });
  }

  Future<List> getClubById(String clubId) async {
    await createDatabase();
    final Database db = await database;
    final List<Map<String, dynamic>> maps = await db.query(
        "clubs",
        where: "clubId = ?",
        whereArgs: [clubId]
    );
    return List.generate(maps.length, (i) {
      return {
        "clubId": maps[i]["clubId"]
      };
    });
  }

  Future<List> getLastClubDate() async {
    await createDatabase();
    final Database db = await database;
    final List<Map<String, dynamic>> maps = await db.query(
        "clubs",
        orderBy: "clubIdAi ASC",
        limit: 1
    );
    return List.generate(maps.length, (i) {
      return {
        "clubDate": maps[i]["clubDate"]
      };
    });
  }

  Future<List> getClubMemberId(String uid, String clubId) async {
    await createDatabase();
    final Database db = await database;
    final List<Map<String, dynamic>> maps = await db.query(
        "clubMembers",
        where: "clubMemberUid = ? AND clubMemberClubId = ?",
        whereArgs: [uid, clubId]
    );

    return List.generate(maps.length, (i) {
      return {
        "clubMemberClubId": maps[i]["clubMemberClubId"]
      };
    });
  }
}