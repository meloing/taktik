import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:totale_reussite/services/utilities.dart';

import 'local_data.dart';

class ArticlesOnlineRequests {
  CollectionReference articles = FirebaseFirestore.instance.collection('articles');
  Future getArticles(String lastDate) async{
    QuerySnapshot querySnapshot = await articles
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

class ArticlesOfflineRequests{

  late Future<Database> database;

  Future createDatabase() async {
    database = openDatabase(join(await getDatabasesPath(), 'totaleReussite.db'));
  }

  Future<void> createArticleTable() async{
    await createDatabase();
    Database db = await database;
    await db.execute(
      "CREATE TABLE IF NOT EXISTS articles ("
          "idAi INTEGER PRIMARY KEY, "
          "id TEXT,"
          "title TEXT,"
          "description TEXT,"
          "date TEXT"
          ")",
    );
  }

  Future<void> addArticle(String id, String title, String description,
                          String date) async {
    await createDatabase();
    final Database db = await database;

    await db.insert(
      'articles',
      {
        "id": id,
        "title": title,
        "description": description,
        "date": date
      },
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  Future<void> updateArticle(String id, String title, String description,
                             String date) async {

    await createDatabase();
    final Database db = await database;

    await db.update(
      'articles',
      {
        "id": id,
        "date": date,
        "title": title,
        "description": description
      },
      where: "id = ?",
      whereArgs: [id],
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  Future<List> getLocalArticles(int offset, int limit, String text) async {
    await createDatabase();
    final Database db = await database;
    final List<Map<String, dynamic>> maps = await db.query(
        "articles",
        where: "title LIKE ?",
        whereArgs: ["%$text%"],
        offset: offset,
        limit: limit
    );

    return List.generate(maps.length, (i) {
      return {
        "id": maps[i]["id"],
        "date": maps[i]["date"],
        "title": maps[i]["title"],
        "description": maps[i]["description"]
      };
    });
  }

  Future<List> getArticleById(String productId) async {
    await createDatabase();
    final Database db = await database;
    final List<Map<String, dynamic>> maps = await db.query(
        "articles",
        where: "id = ?",
        whereArgs: [productId]
    );
    return List.generate(maps.length, (i) {
      return {
        "id": maps[i]["id"]
      };
    });
  }

  Future<List> getLastArticleDate() async {
    await createDatabase();
    final Database db = await database;
    final List<Map<String, dynamic>> maps = await db.query(
        "articles",
        orderBy: "idAi DESC",
        limit: 1
    );
    return List.generate(maps.length, (i) {
      return {
        "date": maps[i]["date"]
      };
    });
  }

  Future getArticles(int offset, int limit, String text) async{
    late List values;
    String lastDate = "";

    List val = await getLastArticleDate();
    if(val.isNotEmpty){
      lastDate = val[0]["date"];
    }

    values = await getLocalArticles(offset, limit, text);
    if(values.isEmpty && text.isEmpty){
      values = await ArticlesOnlineRequests().getArticles(lastDate);
      await addOrUpdateArticle(values);
    }

    return values;
  }

  Future addOrUpdateArticle(List values) async{
    for(Map value in values){
      List article = await ArticlesOfflineRequests().getArticleById(value["id"]);
      if(article.isEmpty){
        await ArticlesOfflineRequests().addArticle(
            value["id"],
            value["title"],
            value["description"],
            value["date"]
        );
      }
      else{
        await ArticlesOfflineRequests().updateArticle(
            value["id"],
            value["title"],
            value["description"],
            value["date"]
        );
      }
    }
  }

  Future<List>synchronizeOnlineOffline()async{
    List values = [];
    String lastDate = "";

    List val = await getLastArticleDate();
    if(val.isNotEmpty){
      lastDate = val[0]["date"];
    }

    String remoteLastArticleDate = await Utilities().remoteConfigValue("lastArticleDate");
    if(remoteLastArticleDate != lastDate){
      values = await ArticlesOnlineRequests().getArticles(lastDate);
      await addOrUpdateArticle(values);
    }

    return values;
  }
}