import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:totale_reussite/services/utilities.dart';

class PointMethodOnlineRequests {
  CollectionReference pointsMethods = FirebaseFirestore.instance.collection('pointsMethods');
  Future getPointMethods(String lastDate, int limit) async{
    QuerySnapshot querySnapshot = await pointsMethods
        .where('date', isGreaterThan: lastDate)
        .limit(limit)
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

class PointMethodOfflineRequests{

  late Future<Database> database;

  Future createDatabase() async {
    database = openDatabase(join(await getDatabasesPath(), 'totaleReussite.db'));
  }

  Future<void> createPointMethodsTable() async{
    await createDatabase();
    Database db = await database;
    // await db.execute("DROP TABLE IF EXISTS pointMethods");
    await db.execute(
      "CREATE TABLE IF NOT EXISTS pointMethods ("
          "idAi INTEGER PRIMARY KEY, "
          "id TEXT,"
          "title TEXT,"
          "subject TEXT,"
          "subtitle TEXT,"
          "description TEXT,"
          "date TEXT"
          ")",
    );
  }

  Future<void> addPointMethods(String id, String title, String description,
                               String date, String subject, String subtitle) async {
    await createDatabase();
    final Database db = await database;

    await db.insert(
      'pointMethods',
      {
        "id": id,
        "title": title,
        "subject": subject,
        "subtitle": subtitle,
        "description": description,
        "date": date
      },
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  Future<void> updatePointMethods(String id, String title, String description,
                                  String date, String subject, String subtitle) async {

    await createDatabase();
    final Database db = await database;

    await db.update(
      'pointMethods',
      {
        "id": id,
        "title": title,
        "subject": subject,
        "subtitle": subtitle,
        "description": description,
        "date": date
      },
      where: "id = ?",
      whereArgs: [id],
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  Future<List> getLocalPointMethods(int offset, int limit) async {
    await createDatabase();
    final Database db = await database;
    final List<Map<String, dynamic>> maps = await db.query(
        "pointMethods",
        offset: offset,
        limit: limit
    );

    return List.generate(maps.length, (i) {
      return {
        "id": maps[i]["id"],
        "date": maps[i]["date"],
        "title": maps[i]["title"],
        "subject": maps[i]["subject"],
        "subtitle": maps[i]["subtitle"],
        "description": maps[i]["description"]
      };
    });
  }

  Future<List> getPointMethodsById(String id) async {
    await createDatabase();
    final Database db = await database;
    final List<Map<String, dynamic>> maps = await db.query(
        "pointMethods",
        where: "id = ?",
        whereArgs: [id]
    );
    return List.generate(maps.length, (i) {
      return {
        "id": maps[i]["id"]
      };
    });
  }

  Future<List> getLastPointMethodsDate() async {
    await createDatabase();
    final Database db = await database;
    final List<Map<String, dynamic>> maps = await db.query(
        "pointMethods",
        orderBy: "idAi DESC",
        limit: 1
    );
    return List.generate(maps.length, (i) {
      return {
        "date": maps[i]["date"]
      };
    });
  }

  Future getPointMethods(int offset, int limit) async{
    late List values;
    String lastDate = "";

    List val = await getLastPointMethodsDate();
    if(val.isNotEmpty){
      lastDate = val[0]["date"];
    }

    values = await getLocalPointMethods(offset, limit);
    if(values.isEmpty){
      values = await PointMethodOnlineRequests().getPointMethods(lastDate, 10);
      await addOrUpdatePointMethod(values);
    }

    return values;
  }

  Future addOrUpdatePointMethod(List values) async{
    for(Map value in values){
      List method = await getPointMethodsById(value["id"]);
      if(method.isEmpty){
        await addPointMethods(
            value["id"],
            value["title"],
            value["description"],
            value["date"],
            value["subject"],
            value["subtitle"]
        );
      }
      else{
        await updatePointMethods(
            value["id"],
            value["title"],
            value["description"],
            value["date"],
            value["subject"],
            value["subtitle"]
        );
      }
    }
  }

  Future<List>synchronizeOnlineOffline()async{
    List values = [];
    String lastDate = "";

    List val = await getLastPointMethodsDate();
    if(val.isNotEmpty){
      lastDate = val[0]["date"];
    }

    String remoteLastPointMethodDate = await Utilities().remoteConfigValue("lastPointMethodDate");
    if(remoteLastPointMethodDate != lastDate){
      values = await PointMethodOnlineRequests().getPointMethods(lastDate, 100) ;
      await addOrUpdatePointMethod(values);
    }

    return values;
  }
}