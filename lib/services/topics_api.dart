import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:totale_reussite/services/utilities.dart';

import 'local_data.dart';

class TopicOnlineRequests {
  CollectionReference topics = FirebaseFirestore.instance.collection('topics');
  Future getTopics(String level, String lastDate) async{
    QuerySnapshot querySnapshot = await topics
                                        .where('level', isEqualTo: level)
                                        .where('date', isGreaterThan: lastDate)
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

class TopicOfflineRequests {

  late Future<Database> database;

  Future createDatabase() async {
    database = openDatabase(join(await getDatabasesPath(), 'totaleReussite.db'));
  }

  Future<void> createTopicsTable() async{
    await createDatabase();
    Database db = await database;
    // await db.execute("DROP TABLE IF EXISTS topics");
    await db.execute(
        "CREATE TABLE IF NOT EXISTS topics ("
            "idAi INTEGER PRIMARY KEY, "
            "id TEXT,"
            "level TEXT,"
            "subject TEXT,"
            "title TEXT,"
            "description TEXT,"
            "type TEXT,"
            "correction TEXT,"
            "exercice TEXT,"
            "date TEXT"
            ")"
    );
  }

  Future<void> addTopic(String level, String subject, String title,
                        String description, String date, String id,
                        String correction, String type, String exercice) async {
    await createDatabase();
    final Database db = await database;

    await db.insert(
      'topics',
      {
        "id": id,
        "date": date,
        "type": type,
        "level": level,
        "title": title,
        "subject": subject,
        "exercice": exercice,
        "correction": correction,
        "description": description
      },
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  Future<void> updateTopic(String level, String subject, String title,
                           String description, String date, String id,
                           String correction, String type, String exercice) async {
    await createDatabase();
    final Database db = await database;

    await db.update(
      'topics',
      {
        "id": id,
        "date": date,
        "type": type,
        "level": level,
        "title": title,
        "subject": subject,
        "exercice": exercice,
        "correction": correction,
        "description": description
      },
      where: "id = ?",
      whereArgs: [id],
      conflictAlgorithm: ConflictAlgorithm.replace
    );
  }

  Future<List> getLocalTopics(String level, int offset) async {
    await createDatabase();
    final Database db = await database;
    final List<Map<String, dynamic>> maps = await db.query(
        "topics",
        where: "level = ?",
        whereArgs: [level],
        offset: offset,
        limit: 20
    );
    return List.generate(maps.length, (i) {
      return {
        "id": maps[i]["id"],
        "type": maps[i]["type"],
        "date": maps[i]["date"],
        "level": maps[i]["level"],
        "title": maps[i]["title"],
        "subject": maps[i]["subject"],
        "exercice": maps[i]["exercice"],
        "correction": maps[i]["correction"],
        "description": maps[i]["description"]
      };
    });
  }

  Future<List> getLastTopicDate() async {
    await createDatabase();
    final Database db = await database;
    final List<Map<String, dynamic>> maps = await db.query(
        "topics",
        orderBy: "idAi ASC",
        limit: 1
    );
    return List.generate(maps.length, (i) {
      return {
        "date": maps[i]["date"]
      };
    });
  }

  Future<List> getTopicById(String id) async {
    await createDatabase();
    final Database db = await database;
    final List<Map<String, dynamic>> maps = await db.query(
        "topics",
        where: "id = ?",
        whereArgs: [id]
    );
    return List.generate(maps.length, (i) {
      return {
        "id": maps[i]["id"]
      };
    });
  }

  Future addOrUpdateTopic(List values) async{
    // add or update course in local database

    for(Map value in values){
      List course = await TopicOfflineRequests().getTopicById(value["id"]);
      if(course.isEmpty){
        await TopicOfflineRequests().addTopic(
            value["level"],
            value["subject"],
            value["title"],
            value["description"],
            value["date"],
            value["id"],
            value["correction"],
            value["type"],
            value["exercise"]
        );
      }
      else{
        await TopicOfflineRequests().updateTopic(
            value["level"],
            value["subject"],
            value["title"],
            value["description"],
            value["date"],
            value["id"],
            value["correction"],
            value["type"],
            value["exercise"]
        );
      }
    }
  }

  Future getTopics(String level, int offset) async{
    late List values;
    String lastDate = "";

    List val = await getLastTopicDate();
    if(val.isNotEmpty){
      lastDate = val[0]["date"];
    }

    values = await getLocalTopics(level, offset);
    if(values.isEmpty){
      values = await TopicOnlineRequests().getTopics(level, lastDate);
      await addOrUpdateTopic(values);
    }

    // Mise à jour des informations
    DateTime today = DateTime.now();
    bool haveConnection = await Utilities().haveConnection();
    DateTime lastManageDate = DateTime.parse(LocalData().getTopicLastManageDate());
    if(today.difference(lastManageDate).inDays >= 3 && haveConnection){
      List updateValues = await TopicOnlineRequests().getTopics(level, lastDate);
      await addOrUpdateTopic(updateValues);
      LocalData().setTopicLastManageDate(today.toString());
    }

    return values;
  }
}