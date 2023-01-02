import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class QuizOnlineRequests{
  CollectionReference quizz = FirebaseFirestore.instance.collection('quizz');

  Future getQuizz(String level, String subject) async{
    QuerySnapshot querySnapshot = await quizz
        .where('quizzLevel', isEqualTo: level)
        .where('quizzSubject', isEqualTo: subject)
        .limit(20)
        .get();
    final allData = querySnapshot.docs.map(
            (doc){
          Map value = doc.data() as Map;
          value['quizzId'] = doc.id;
          return value;
        }
    ).toList();

    return allData;
  }

  Future getQuizzByCourseId(String courseId) async{
    QuerySnapshot querySnapshot = await quizz
        .where('quizzCourseId', isEqualTo: courseId)
        .limit(20)
        .get();
    final allData = querySnapshot.docs.map(
            (doc){
          Map value = doc.data() as Map;
          value['quizzId'] = doc.id;
          return value;
        }
    ).toList();

    return allData;
  }

}

class QuizOfflineRequests {

  late Future<Database> database;

  Future createDatabase() async {
    database = openDatabase(join(await getDatabasesPath(), 'totaleReussite.db'));
  }

  Future<void> createQuizzTable() async{
    await createDatabase();
    Database db = await database;
    await db.execute(
        "CREATE TABLE IF NOT EXISTS quizz ("
            "quizzIdAi INTEGER PRIMARY KEY, "
            "quizzAdd INTEGER,"
            "quizzConsigne TEXT,"
            "quizzCourseId TEXT,"
            "quizzDate TEXT,"
            "quizzGoodResponse TEXT,"
            "quizzLevel TEXT,"
            "quizzMinus INTEGER,"
            "quizzQuestions TEXT,"
            "quizzResponses TEXT,"
            "quizzSecond INTEGER,"
            "quizzSubTitle TEXT,"
            "quizzSubject TEXT,"
            "quizzTitle TEXT"
            ")"
    );
  }

  Future<void> addQuizz(int add, String consigne, String courseId,
      String date, String goodResponse, String level, int minus,
      String questions, String responses, int second, String subTitle,
      String subject, String title) async {

    await createDatabase();
    final Database db = await database;

    await db.insert(
      'quizz',
      {
        "quizzAdd": add,
        "quizzDate": date,
        "quizzLevel": level,
        "quizzMinus": minus,
        "quizzTitle": title,
        "quizzSecond": second,
        "quizzSubject": subject,
        "quizzConsigne": consigne,
        "quizzCourseId": courseId,
        "quizzSubTitle": subTitle,
        "quizzQuestions": questions,
        "quizzResponses": responses,
        "quizzGoodResponse": goodResponse
      },
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  Future<List> getQuizzByCourseId(String courseId) async {
    await createDatabase();
    final Database db = await database;
    final List<Map<String, dynamic>> maps = await db.query(
        "quizz",
        where: "quizzCourseId = ?",
        whereArgs: [courseId]
    );
    return List.generate(maps.length, (i) {
      return {
        "quizzAdd": maps[i]["quizzAdd"],
        "quizzDate": maps[i]["quizzDate"],
        "quizzTitle": maps[i]["quizzTitle"],
        "quizzLevel": maps[i]["quizzLevel"],
        "quizzMinus": maps[i]["quizzMinus"],
        "quizzSecond": maps[i]["quizzSecond"],
        "quizzSubject": maps[i]["quizzSubject"],
        "quizzConsigne": maps[i]["quizzConsigne"],
        "quizzCourseId": maps[i]["quizzCourseId"],
        "quizzSubTitle": maps[i]["quizzSubTitle"],
        "quizzQuestions": maps[i]["quizzQuestions"],
        "quizzResponses": maps[i]["quizzResponses"],
        "quizzGoodResponse": maps[i]["quizzGoodResponse"]
      };
    });
  }

  Future<List> getAllQuiz() async {
    await createDatabase();
    final Database db = await database;
    final List<Map<String, dynamic>> maps = await db.query("quizz");
    return List.generate(maps.length, (i) {
      return {
        "quizzAdd": maps[i]["quizzAdd"],
        "quizzDate": maps[i]["quizzDate"],
        "quizzTitle": maps[i]["quizzTitle"],
        "quizzLevel": maps[i]["quizzLevel"],
        "quizzMinus": maps[i]["quizzMinus"],
        "quizzSecond": maps[i]["quizzSecond"],
        "quizzSubject": maps[i]["quizzSubject"],
        "quizzConsigne": maps[i]["quizzConsigne"],
        "quizzCourseId": maps[i]["quizzCourseId"],
        "quizzSubTitle": maps[i]["quizzSubTitle"],
        "quizzQuestions": maps[i]["quizzQuestions"],
        "quizzResponses": maps[i]["quizzResponses"],
        "quizzGoodResponse": maps[i]["quizzGoodResponse"]
      };
    });
  }

}