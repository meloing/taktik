import 'package:http/http.dart' as http;
import 'package:cloud_firestore/cloud_firestore.dart';

class UserOnlineRequests {
  CollectionReference users = FirebaseFirestore.instance.collection('users');
  CollectionReference subjects = FirebaseFirestore.instance.collection('subjects');

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
        .then((value) => true)
        .catchError((error) => false);
  }

  Future addPremium(String uid, String premium, String premiumFinish) async {
    return users
          .doc(uid)
          .update({
            "premium": premium,
            "premiumFinish": premiumFinish
          })
        .then((value) => print("User Added"))
        .catchError((error) => print("Failed to add user: $error"));
  }

  Future getUserById(String uid) async{
    QuerySnapshot querySnapshot = await users
        .where('uid', isEqualTo: uid)
        .get();
    final allData = querySnapshot.docs.map(
            (doc){
          Map value = doc.data() as Map;
          value['docId'] = doc.id;
          return value;
        }
    ).toList();

    return allData;
  }

  Future getUserByPseudo(String pseudo) async{
    QuerySnapshot querySnapshot = await users
        .where('pseudo', isEqualTo: pseudo)
        .get();
    final allData = querySnapshot.docs.map(
            (doc){
          Map value = doc.data() as Map;
          value['docId'] = doc.id;
          return value;
        }
    ).toList();

    return allData;
  }

  Future getSubjects() async{
    QuerySnapshot querySnapshot = await subjects
        .orderBy("subjectNumber")
        .get();
    final allData = querySnapshot.docs.map(
            (doc){
          Map value = doc.data() as Map;
          value['subjectId'] = doc.id;
          return value;
        }
    ).toList();

    return allData;
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

  Future sendReferral(String pseudo) async{
    Uri url = Uri.parse('https://www.archetechnology.com/totale-reussite/'
                        'manage-referral.php?pseudo=$pseudo');
    await http.get(url);
  }

  Future getPoints(String pseudo) async{
    var url = Uri.parse('https://www.archetechnology.com/totale-reussite/'
                        'get-points.php?pseudo=$pseudo');
    http.Response response = await http.get(url);

    if(response.statusCode == 200) {
      return response.body.trim();
    }
    else{
      return "error";
    }
  }
}