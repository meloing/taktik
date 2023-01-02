import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';
import 'package:http/http.dart' as http;
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:totale_reussite/services/utilities.dart';

class ProductOnlineRequests {
  CollectionReference products = FirebaseFirestore.instance.collection('products');

  Future getProducts(String lastDate) async{
    QuerySnapshot querySnapshot = await products
        .where('productDate', isGreaterThan: lastDate)
        .limit(100)
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

  Future getProductById(String productId) async{
    var docSnapshot = await products.doc(productId).get();
    if(docSnapshot.exists){
      Map<String, dynamic>? data = docSnapshot.data() as Map<String, dynamic>?;
      return data;
    }
  }
}

class ProductOfflineRequests {

  late Future<Database> database;

  Future createDatabase() async {
    database = openDatabase(join(await getDatabasesPath(), 'totaleReussite.db'));
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

  Future<List> getLocalProducts(String text, int offset) async {
    await createDatabase();
    final Database db = await database;
    final List<Map<String, dynamic>> maps = await db.query(
        "products",
        where: "productPlus LIKE ?",
        whereArgs: ["%$text%"],
        offset: offset,
        limit: 20
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
        where: "productBuyKey IS NOT NULL AND productExpireDate > ?",
        whereArgs: [DateTime.now().toString()],
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

  Future addOrUpdateProduct(List values) async{
    for(Map value in values){
      List competition = await ProductOfflineRequests().getProductById(value["productId"]);
      if(competition.isEmpty){
        await ProductOfflineRequests().addProduct(
            value["productId"],
            value["productName"],
            value["productDescription"],
            value["productPicture"],
            value["productPlus"],
            value["productPrice"],
            value["productSubjects"],
            value["productDate"]
        );
      }
      else{
        await ProductOfflineRequests().updateProduct(
            value["productId"],
            value["productName"],
            value["productDescription"],
            value["productPicture"],
            value["productPlus"],
            value["productPrice"],
            value["productSubjects"],
            value["productDate"]
        );
      }
    }
  }

  Future getProducts(String text, int offset) async{
    late List values;
    String lastDate = "";

    List val = await ProductOfflineRequests().getLastProductDate();
    if(val.isNotEmpty){
      lastDate = val[0]["productDate"];
    }

    values = await getLocalProducts(text, offset);
    if(values.isEmpty){
      values = await ProductOnlineRequests().getProducts(lastDate);
      await addOrUpdateProduct(values);
    }

    return values;
  }

  Future<List>synchronizeOnlineOffline()async{
    List values = [];
    String lastDate = "";

    List val = await getLastProductDate();
    if(val.isNotEmpty){
      lastDate = val[0]["productDate"];
    }

    String remoteLastProductDate = await Utilities().remoteConfigValue("lastProductDate");
    if(remoteLastProductDate != lastDate){
      values = await ProductOnlineRequests().getProducts(lastDate);
      await addOrUpdateProduct(values);
    }

    return values;
  }
}