import 'dart:io';
import 'dart:math';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';
import 'package:http/http.dart' as http;
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';

class ManageDatabase {
  FirebaseFirestore firestore = FirebaseFirestore.instance;
  CollectionReference quizz = FirebaseFirestore.instance.collection('quizz');
  CollectionReference users = FirebaseFirestore.instance.collection('users');
  CollectionReference posts = FirebaseFirestore.instance.collection('posts');
  CollectionReference clubs = FirebaseFirestore.instance.collection('clubs');
  CollectionReference levels = FirebaseFirestore.instance.collection('levels');
  CollectionReference courses = FirebaseFirestore.instance.collection('courses');
  CollectionReference subjects = FirebaseFirestore.instance.collection('subjects');
  CollectionReference comments = FirebaseFirestore.instance.collection('comments');
  CollectionReference products = FirebaseFirestore.instance.collection('products');
  CollectionReference clubMembers = FirebaseFirestore.instance.collection('clubMembers');
  CollectionReference competition = FirebaseFirestore.instance.collection('competition');

  Future addUser(String uid, String firstName, String level, String pseudo,
                 String number, String country, String birthday, String lastName,
                 String establishment, String avatar, String gender) async {
    return users
        .add({
          "uid": uid,
          "level": level,
          "pseudo": pseudo,
          "gender": gender,
          "avatar": avatar,
          "number": number,
          "country": country,
          "lastName": lastName,
          "birthday": birthday,
          "firstName": firstName,
          "establishment": establishment
        })
        .then((value) => print("User Added"))
        .catchError((error) => print("Failed to add user: $error"));
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

  Future getLevels() async{
    QuerySnapshot querySnapshot = await levels.get();
    final allData = querySnapshot.docs.map((doc) => doc.data()).toList();

    return allData;
  }

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

  Future getUserById(String uid) async{
    QuerySnapshot querySnapshot = await users
        .where('uid', isEqualTo: uid)
        .get();
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

  Future getProducts(String lastDate) async{
    QuerySnapshot querySnapshot = await products
        .where('productDate', isGreaterThan: lastDate)
        .limit(20)
        .get();
    final allData = querySnapshot.docs.map(
            (doc){
              Map value = doc.data() as Map;
              value['productId'] = doc.id;
              return value;
            }
    ).toList();

    return allData;
  }

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

  Future deletePost(String documentId) async{
    await posts.doc(documentId).delete();

    return true;
  }

  Future deleteComment(String documentId) async{
    await comments.doc(documentId).delete();
    return true;
  }

  Future addCommand(String firestoreId, String key) async{
    String url = 'https://www.archetechnology.com/totale-reussite/add-command.php';
    Map<String, String> headers = {
      "Content-Type": "multipart/form-data",
    };

    var request = http.MultipartRequest("POST", Uri.parse(url));
    request.headers.addAll(headers);

    request.fields["key"] = key;
    request.fields["firestoreId"] = firestoreId;

    var response = await request.send();
    if(response.statusCode == 200){
      final respStr = await http.Response.fromStream(response);
      return respStr.body;
    }
    else {
      return "error";
    }
  }
}

class LocalDatabase {

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

  Future<void> createSubjectsTable() async{
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

  Future<void> createCoursesTable() async{
    await createDatabase();
    Database db = await database;
    // await db.execute("DROP TABLE IF EXISTS courses");
    await db.execute(
      "CREATE TABLE IF NOT EXISTS courses ("
          "courseIdAi INTEGER PRIMARY KEY, "
          "courseId TEXT,"
          "courseLevel TEXT,"
          "courseNumber TEXT,"
          "courseSubject TEXT,"
          "courseTitle TEXT,"
          "courseDescription TEXT,"
          "courseDate TEXT,"
          "courseExercises TEXT,"
          "courseIsFinished TEXT DEFAULT 'no'"
          ")"
    );
  }

  Future<void> createTopicsTable() async{
    await createDatabase();
    Database db = await database;
    await db.execute(
        "CREATE TABLE IF NOT EXISTS topics ("
            "topicIdAi INTEGER PRIMARY KEY, "
            "topicId TEXT,"
            "topicLevel TEXT,"
            "topicSubject TEXT,"
            "topicTitle TEXT,"
            "topicDescription TEXT,"
            "topicDate TEXT"
            ")"
    );
  }

  Future<void> createProductsTable() async{
    await createDatabase();
    Database db = await database;
    // await db.execute("DROP TABLE IF EXISTS products");
    await db.execute(
        "CREATE TABLE IF NOT EXISTS products ("
            "productIdAi INTEGER PRIMARY KEY, "
            "productId TEXT,"
            "productName TEXT,"
            "productDescription TEXT,"
            "productPicture TEXT,"
            "productPlus TEXT,"
            "productPrice TEXT,"
            "productSubjects TEXT,"
            "productDate TEXT,"
            "productExpireDate TEXT NULL,"
            "productBuyKey TEXT NULL"
            ")"
    );
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

  Future<void> addProduct(String productId, String productName, String productDescription,
                          String productPicture, String productPlus, String productPrice,
                          String productSubjects, String productDate) async {
    await createDatabase();
    final Database db = await database;

    await db.insert(
      'products',
      {
        "productId": productId,
        "productName": productName,
        "productDate": productDate,
        "productPlus": productPlus,
        "productPrice": productPrice,
        "productPicture": productPicture,
        "productSubjects": productSubjects,
        "productDescription": productDescription
      },
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  Future<void> updateProduct(String productId, String productName, String productDescription,
                             String productPicture, String productPlus, String productPrice,
                             String productSubjects, String productDate) async {
    await createDatabase();
    final Database db = await database;

    await db.update(
      'products',
      {
        "productId": productId,
        "productName": productName,
        "productDate": productDate,
        "productPlus": productPlus,
        "productPrice": productPrice,
        "productPicture": productPicture,
        "productSubjects": productSubjects,
        "productDescription": productDescription
      },
      where: "productId = ?",
      whereArgs: [productId],
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  Future<void> updateProductKey(String date, String key, String productId) async {
    await createDatabase();
    final Database db = await database;

    await db.update(
      'products',
      {
        "productExpireDate": date,
        "productBuyKey": key
      },
      where: "productId = ?",
      whereArgs: [productId],
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  Future<void> addTopic(String topicLevel, String topicSubject, String topicTitle,
                        String topicDescription, String topicDate, String topicId) async {
    await createDatabase();
    final Database db = await database;

    await db.insert(
      'topics',
      {
        "topicId": topicId,
        "topicDate": topicDate,
        "topicLevel": topicLevel,
        "topicTitle": topicTitle,
        "topicSubject": topicSubject,
        "topicDescription": topicDescription
      },
      conflictAlgorithm: ConflictAlgorithm.replace,
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

  Future<void> addCourse(String courseLevel, String courseNumber, String courseSubject,
                         String courseTitle, String courseDescription, String courseDate,
                         String courseId, String courseExercises) async {
    await createDatabase();
    final Database db = await database;

    await db.insert(
      'courses',
      {
        "courseId": courseId,
        "courseDate": courseDate,
        "courseLevel": courseLevel,
        "courseTitle": courseTitle,
        "courseNumber": courseNumber,
        "courseSubject": courseSubject,
        "courseExercises": courseExercises,
        "courseDescription": courseDescription
      },
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  Future<void> updateCourse(String courseLevel, String courseNumber, String courseSubject,
                            String courseTitle, String courseDescription, String courseDate,
                            String courseId, String courseExercises) async {
    await createDatabase();
    final Database db = await database;

    await db.update(
      'courses',
      {
        "courseId": courseId,
        "courseDate": courseDate,
        "courseLevel": courseLevel,
        "courseTitle": courseTitle,
        "courseNumber": courseNumber,
        "courseSubject": courseSubject,
        "courseExercises": courseExercises,
        "courseDescription": courseDescription
      },
      where: "courseId = ?",
      whereArgs: [courseId],
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
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

  Future<List> getCompetition(String text) async {
    await createDatabase();
    final Database db = await database;
    final List<Map<String, dynamic>> maps = await db.query(
        "competition",
        where: "competitionName LIKE ?",
        whereArgs: ["%$text%"]
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
        orderBy: "competitionIdAi ASC",
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

  Future<List> getProducts(String text) async {
    await createDatabase();
    final Database db = await database;
    final List<Map<String, dynamic>> maps = await db.query(
        "products",
        where: "productPlus LIKE ?",
        whereArgs: ["%$text%"]
    );
    return List.generate(maps.length, (i) {
      return {
        "productId": maps[i]["productId"],
        "productDate": maps[i]["productDate"],
        "productName": maps[i]["productName"],
        "productPlus": maps[i]["productPlus"],
        "productPrice": maps[i]["productPrice"],
        "productPicture": maps[i]["productPicture"],
        "productSubjects": maps[i]["productSubjects"],
        "productDescription": maps[i]["productDescription"]
      };
    });
  }

  Future<List> getMyProducts() async {
    await createDatabase();
    final Database db = await database;
    final List<Map<String, dynamic>> maps = await db.query(
        "products",
        where: "productBuyKey IS NOT NULL"
    );
    return List.generate(maps.length, (i) {
      return {
        "productId": maps[i]["productId"],
        "productDate": maps[i]["productDate"],
        "productName": maps[i]["productName"],
        "productPlus": maps[i]["productPlus"],
        "productPrice": maps[i]["productPrice"],
        "productPicture": maps[i]["productPicture"],
        "productSubjects": maps[i]["productSubjects"],
        "productDescription": maps[i]["productDescription"],
        "productExpireDate" : maps[i]["productExpireDate"],
        "productBuyKey" : maps[i]["productBuyKey"]
      };
    });
  }

  Future<List> getProductById(String productId) async {
    await createDatabase();
    final Database db = await database;
    final List<Map<String, dynamic>> maps = await db.query(
        "products",
        where: "productId = ?",
        whereArgs: [productId]
    );
    return List.generate(maps.length, (i) {
      return {
        "productId": maps[i]["productId"]
      };
    });
  }

  Future<List> getLastProductDate() async {
    await createDatabase();
    final Database db = await database;
    final List<Map<String, dynamic>> maps = await db.query(
        "products",
        orderBy: "productIdAi DESC",
        limit: 1
    );
    return List.generate(maps.length, (i) {
      return {
        "productDate": maps[i]["productDate"]
      };
    });
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

  Future<int> getNumberFinishedCourse(String subjectName) async {
    await createDatabase();
    final Database db = await database;
    final List<Map<String, dynamic>> maps = await db.rawQuery(
            "SELECT COUNT(*) as total "
            "FROM courses "
            "WHERE courseSubject = '$subjectName' AND courseIsFinished = 'yes'"
    );

    return maps[0]["total"];
  }

  Future<int> getNumberCourse(String subjectName) async {
    await createDatabase();
    final Database db = await database;
    final List<Map<String, dynamic>> maps = await db.rawQuery(
        "SELECT COUNT(*) as total "
            "FROM courses "
            "WHERE courseSubject = '$subjectName'"
    );

    return maps[0]["total"];
  }

  Future<List> getTopics(String level, String subject) async {
    await createDatabase();
    final Database db = await database;
    final List<Map<String, dynamic>> maps = await db.query(
        "topics",
        where: "topicLevel = ? AND topicSubject = ?",
        whereArgs: [level, subject]
    );
    return List.generate(maps.length, (i) {
      return {
        "topicId": maps[i]["topicId"],
        "topicDate": maps[i]["topicDate"],
        "topicLevel": maps[i]["topicLevel"],
        "topicTitle": maps[i]["topicTitle"],
        "topicSubject": maps[i]["topicSubject"],
        "topicDescription": maps[i]["topicDescription"]
      };
    });
  }

  Future<List> getCourses(String level, String subject) async {
    await createDatabase();
    final Database db = await database;
    final List<Map<String, dynamic>> maps = await db.query(
        "courses",
        where: "courseLevel = ? AND courseSubject = ?",
        whereArgs: [level, subject]
    );
    return List.generate(maps.length, (i) {
      return {
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

  Future<void> createAllTable() async{
    await createClubsTable();
    await createQuizzTable();
    await createTopicsTable();
    await createCoursesTable();
    await createSubjectsTable();
    await createProductsTable();
    await createCompetitionTable();
  }

  Future sendCode(String email, String code) async{
    String url = 'http://app.huch.tech/send-code';
    Map<String, String> headers = {
      "Content-Type": "multipart/form-data",
      "cookie": ""
    };

    var request = http.MultipartRequest("POST", Uri.parse(url));
    request.headers.addAll(headers);
    request.fields["code"] = code;
    request.fields["email"] = email;

    var response = await request.send();

    if(response.statusCode == 200){
      final respStr = await http.Response.fromStream(response);
      return respStr.body.trim();
    }
    else {
      return "error";
    }
  }
}