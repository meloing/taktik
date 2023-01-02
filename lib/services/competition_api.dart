import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:totale_reussite/services/utilities.dart';

class CompetitionOnlineRequests{
  CollectionReference competition = FirebaseFirestore.instance.collection('competition');

  Future getCompetition(String lastDate) async{
    QuerySnapshot querySnapshot = await competition
        .where('competitionDate', isGreaterThan: lastDate)
        .limit(20)
        .get();
    final allData = querySnapshot.docs.map(
            (doc){
          Map value = doc.data() as Map;
          value['competitionId'] = doc.id;
          return value;
        }
    ).toList();

    return allData;
  }
}

class CompetitionOfflineRequests{
  late Future<Database> database;

  Future createDatabase() async {
    database = openDatabase(join(await getDatabasesPath(), 'totaleReussite.db'));
  }

  Future<void> createCompetitionTable() async{
    await createDatabase();
    Database db = await database;
    await db.execute(
        "CREATE TABLE IF NOT EXISTS competition ("
            "competitionIdAi INTEGER PRIMARY KEY, "
            "competitionId TEXT,"
            "competitionContacts TEXT,"
            "competitionCountry TEXT,"
            "competitionDate TEXT,"
            "competitionDescription TEXT,"
            "competitionLink TEXT,"
            "competitionName TEXT,"
            "competitionPicture TEXT"
            ")"
    );
  }

  Future<void> addCompetition(String competitionId, String competitionContacts,
                              String competitionCountry, String competitionDate,
                              String competitionDescription, String competitionLink,
                              String competitionName, String competitionPicture) async {

    await createDatabase();
    final Database db = await database;

    await db.insert(
      'competition',
      {
        "competitionId": competitionId,
        "competitionDate": competitionDate,
        "competitionLink": competitionLink,
        "competitionName": competitionName,
        "competitionPicture": competitionPicture,
        "competitionCountry": competitionCountry,
        "competitionContacts": competitionContacts,
        "competitionDescription": competitionDescription,
      },
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  Future<void> updateCompetition(String competitionId, String competitionContacts,
                                 String competitionCountry, String competitionDate,
                                 String competitionDescription, String competitionLink,
                                 String competitionName, String competitionPicture) async {

    await createDatabase();
    final Database db = await database;

    await db.update(
      'competition',
      {
        "competitionId": competitionId,
        "competitionDate": competitionDate,
        "competitionLink": competitionLink,
        "competitionName": competitionName,
        "competitionPicture": competitionPicture,
        "competitionCountry": competitionCountry,
        "competitionContacts": competitionContacts,
        "competitionDescription": competitionDescription,
      },
      where: "competitionId = ?",
      whereArgs: [competitionId],
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  Future<List> getLocalCompetition(String text, int offset) async {
    await createDatabase();
    final Database db = await database;
    final List<Map<String, dynamic>> maps = await db.query(
        "competition",
        where: "competitionName LIKE ?",
        whereArgs: ["%$text%"],
        offset: offset,
        limit: 20
    );
    return List.generate(maps.length, (i) {
      return {
        "competitionId": maps[i]["competitionId"],
        "competitionDate": maps[i]["competitionDate"],
        "competitionLink": maps[i]["competitionLink"],
        "competitionName": maps[i]["competitionName"],
        "competitionPicture": maps[i]["competitionPicture"],
        "competitionCountry": maps[i]["competitionCountry"],
        "competitionContacts": maps[i]["competitionContacts"],
        "competitionDescription": maps[i]["competitionDescription"]
      };
    });
  }

  Future<List> getLastCompetitionDate() async {
    await createDatabase();
    final Database db = await database;
    final List<Map<String, dynamic>> maps = await db.query(
      "competition",
      orderBy: "competitionIdAi DESC",
      limit: 1,
    );
    return List.generate(maps.length, (i) {
      return {
        "competitionDate": maps[i]["competitionDate"]
      };
    });
  }

  Future<List> getCompetitionById(String competitionId) async {
    await createDatabase();
    final Database db = await database;
    final List<Map<String, dynamic>> maps = await db.query(
        "competition",
        where: "competitionId = ?",
        whereArgs: [competitionId]
    );
    return List.generate(maps.length, (i) {
      return {
        "competitionId": maps[i]["competitionId"]
      };
    });
  }

  Future addOrUpdateCompetition(List values) async{
    for(Map value in values){
      List competition = await CompetitionOfflineRequests().getCompetitionById(value["competitionId"]);
      if(competition.isEmpty){
        await CompetitionOfflineRequests().addCompetition(
            value["competitionId"],
            value["competitionContacts"],
            value["competitionCountry"],
            value["competitionDate"],
            value["competitionDescription"],
            value["competitionLink"],
            value["competitionName"],
            value["competitionPicture"]
        );
      }
      else{
        await CompetitionOfflineRequests().updateCompetition(
            value["competitionId"],
            value["competitionContacts"],
            value["competitionCountry"],
            value["competitionDate"],
            value["competitionDescription"],
            value["competitionLink"],
            value["competitionName"],
            value["competitionPicture"]
        );
      }
    }
  }

  Future getCompetition(String text, int offset) async{
    late List values;
    String lastDate = "";

    List val = await getLastCompetitionDate();
    if(val.isNotEmpty){
      lastDate = val[0]["competitionDate"];
    }

    values = await getLocalCompetition(text, offset);
    if(values.isEmpty){
      values = await CompetitionOnlineRequests().getCompetition(lastDate);
      await addOrUpdateCompetition(values);
    }

    return values;
  }

  Future<List>synchronizeOnlineOffline()async{
    List values = [];
    String lastDate = "";

    List val = await getLastCompetitionDate();
    if(val.isNotEmpty){
      lastDate = val[0]["competitionDate"];
    }

    String remoteLastCompetitionDate = await Utilities().remoteConfigValue("lastCompetitionDate");
    if(remoteLastCompetitionDate != lastDate){
      values = await CompetitionOnlineRequests().getCompetition(lastDate);
      await addOrUpdateCompetition(values);
    }

    return values;
  }
}