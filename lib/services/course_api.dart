import 'local_data.dart';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:totale_reussite/services/utilities.dart';

class CourseOnlineRequests {
  CollectionReference levels = FirebaseFirestore.instance.collection('levels');
  CollectionReference courses = FirebaseFirestore.instance.collection('courses');
  CollectionReference subjects = FirebaseFirestore.instance.collection('subjects');
  CollectionReference products = FirebaseFirestore.instance.collection('products');

  Future getLevels() async{
    QuerySnapshot querySnapshot = await levels.get();
    final allData = querySnapshot.docs.map((doc) => doc.data()).toList();

    return allData;
  }

  Future getSubjectByName(String name) async{
    QuerySnapshot querySnapshot = await subjects
        .where('subjectName', isEqualTo: name)
        .get();
    final allData = querySnapshot.docs.map((doc) => doc.data()).toList();

    return allData;
  }

  Future getCourses(String level, String subject, String lastDate) async{
    QuerySnapshot querySnapshot = await courses
        .where('courseLevel', isEqualTo: level)
        .where('courseSubject', isEqualTo: subject)
        .where('courseDate', isGreaterThan: lastDate)
        .get();
    final allData = querySnapshot.docs.map(
            (doc){
          Map value = doc.data() as Map;
          value['courseId'] = doc.id;
          return value;
        }
    ).toList();

    return allData;
  }
}

class CourseOfflineRequests {

  late Future<Database> database;

  Future createDatabase() async {
    database =
        openDatabase(join(await getDatabasesPath(), 'totaleReussite.db'));
  }

  Future<void> createSubjectsTable() async {
    await createDatabase();
    Database db = await database;
    await db.execute(
      "CREATE TABLE IF NOT EXISTS subjects ("
          "subjectIdAi INTEGER PRIMARY KEY, "
          "subjectName TEXT,"
          "subjectValues TEXT"
          ")",
    );
  }

  Future<void> createCoursesTable() async {
    await createDatabase();
    Database db = await database;
    // await db.execute("DROP TABLE IF EXISTS courses");
    await db.execute(
        "CREATE TABLE IF NOT EXISTS courses ("
            "courseIdAi INTEGER PRIMARY KEY, "
            "courseId TEXT,"
            "courseLevel TEXT,"
            "courseSubject TEXT,"
            "courseTitle TEXT,"
            "courseDescription TEXT,"
            "courseDate TEXT,"
            "courseExercises TEXT,"
            "type TEXT,"
            "courseIsFinished TEXT DEFAULT 'no'"
            ")"
    );
  }

  Future<void> addSubject(String subjectName, String subjectValues) async {
    await createDatabase();
    final Database db = await database;

    await db.insert(
      'subjects',
      {
        "subjectName": subjectName,
        "subjectValues": subjectValues
      },
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  Future<void> updateCourseIsFinished(String courseId) async {
    await createDatabase();
    final Database db = await database;

    await db.update(
      'courses',
      {
        "courseIsFinished": "yes"
      },
      where: "courseId = ?",
      whereArgs: [courseId],
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  Future<void> addCourse(String courseLevel, String courseSubject, String courseTitle,
                         String courseDescription, String courseDate, String courseId,
                         String courseExercises, String type) async {
    await createDatabase();
    final Database db = await database;

    await db.insert(
      'courses',
      {
        "type": type,
        "courseId": courseId,
        "courseDate": courseDate,
        "courseLevel": courseLevel,
        "courseTitle": courseTitle,
        "courseSubject": courseSubject,
        "courseExercises": courseExercises,
        "courseDescription": courseDescription
      },
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  Future<void> updateCourse(String courseLevel, String courseSubject,
                            String courseTitle, String courseDescription, String courseDate,
                            String courseId, String courseExercises, String type) async {
    await createDatabase();
    final Database db = await database;

    await db.update(
      'courses',
      {
        "type": type,
        "courseId": courseId,
        "courseDate": courseDate,
        "courseLevel": courseLevel,
        "courseTitle": courseTitle,
        "courseSubject": courseSubject,
        "courseExercises": courseExercises,
        "courseDescription": courseDescription
      },
      where: "courseId = ?",
      whereArgs: [courseId],
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  Future<List> getSubjects(String subjectName) async {
    await createDatabase();
    final Database db = await database;
    final List<Map<String, dynamic>> maps = await db.query(
        "subjects",
        where: "subjectName = ?",
        whereArgs: [subjectName]
    );

    return List.generate(maps.length, (i) {
      return {
        "subjectName": maps[i]["subjectName"],
        "subjectValues": maps[i]["subjectValues"]
      };
    });
  }

  Future<int> getNumberFinishedCourse() async {
    await createDatabase();
    final Database db = await database;
    final List<Map<String, dynamic>> maps = await db.rawQuery(
        "SELECT COUNT(*) as total "
            "FROM courses "
            "WHERE courseIsFinished = 'yes'"
    );

    return maps[0]["total"];
  }

  Future<int> getNumberCourse() async {
    await createDatabase();
    final Database db = await database;
    final List<Map<String, dynamic>> maps = await db.rawQuery(
        "SELECT COUNT(*) as total "
            "FROM courses "
    );

    return maps[0]["total"];
  }

  Future<List> getLocalCourses(String level, String subject, int offset) async {
    await createDatabase();
    final Database db = await database;
    final List<Map<String, dynamic>> maps = await db.query(
        "courses",
        where: "courseLevel = ? AND courseSubject = ?",
        whereArgs: [level, subject],
        offset: offset,
        limit: 20
    );
    return List.generate(maps.length, (i) {
      return {
        "type": maps[i]["type"],
        "courseId": maps[i]["courseId"],
        "courseDate": maps[i]["courseDate"],
        "courseLevel": maps[i]["courseLevel"],
        "courseTitle": maps[i]["courseTitle"],
        "courseNumber": maps[i]["courseNumber"],
        "courseSubject": maps[i]["courseSubject"],
        "courseExercises": maps[i]["courseExercises"],
        "courseIsFinished": maps[i]["courseIsFinished"],
        "courseDescription": maps[i]["courseDescription"]
      };
    });
  }

  Future<List> getCourseById(String courseId) async {
    await createDatabase();
    final Database db = await database;
    final List<Map<String, dynamic>> maps = await db.query(
        "courses",
        where: "courseId = ?",
        whereArgs: [courseId]
    );
    return List.generate(maps.length, (i) {
      return {
        "courseId": maps[i]["courseId"]
      };
    });
  }

  Future<List> getLastCourseDate(String level, String subject) async {
    await createDatabase();
    final Database db = await database;
    final List<Map<String, dynamic>> maps = await db.query(
        "courses",
        where: "courseLevel = ? AND courseSubject = ?",
        orderBy: "courseIdAi ASC",
        limit: 1,
        whereArgs: [level, subject]
    );
    return List.generate(maps.length, (i) {
      return {
        "courseDate": maps[i]["courseDate"]
      };
    });
  }

  Future addOrUpdateCourse(List values) async{
    // add or update course in local database

    for(Map value in values){
      List course = await CourseOfflineRequests().getCourseById(value["courseId"]);
      if(course.isEmpty){
        await CourseOfflineRequests().addCourse(
          value["courseLevel"],
          value["courseSubject"],
          value["courseTitle"],
          value["courseDescription"],
          value["courseDate"],
          value["courseId"],
          value["courseExercises"],
          value["type"].toString(),
        );
      }
      else{
        await CourseOfflineRequests().updateCourse(
          value["courseLevel"],
          value["courseSubject"],
          value["courseTitle"],
          value["courseDescription"],
          value["courseDate"],
          value["courseId"],
          value["courseExercises"],
          value["type"],
        );
      }
    }
  }

  Future getCourses(String level, String subject, int offset) async{
    late List values;
    String lastDate = "";

    List val = await getLastCourseDate(level, subject);
    if(val.isNotEmpty){
      lastDate = val[0]["courseDate"];
    }

    values = await getLocalCourses(level, subject, offset);
    if(values.isEmpty){
      values = await CourseOnlineRequests().getCourses(level, subject, lastDate);
      await addOrUpdateCourse(values);
    }

    // Mise à jour des informations
    DateTime today = DateTime.now();
    bool haveConnection = await Utilities().haveConnection();
    DateTime lastManageDate = DateTime.parse(LocalData().getCourseLastManageDate());
    // today.difference(lastManageDate).inDays >= 2 &&
    if(haveConnection){
      List updateValues = await CourseOnlineRequests().getCourses(level, subject, lastDate);
      await addOrUpdateCourse(updateValues);
      LocalData().setCourseLastManageDate(today.toString());
    }

    return values;
  }

  Future<void> unlockCourse(String courseId) async {
    await createDatabase();
    final Database db = await database;

    await db.update(
      'courses',
      {
        "type": "unlock"
      },
      where: "courseId = ?",
      whereArgs: [courseId],
      conflictAlgorithm: ConflictAlgorithm.replace
    );
  }
}