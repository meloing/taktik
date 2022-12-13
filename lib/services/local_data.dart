import 'dart:core';
import 'package:shared_preferences/shared_preferences.dart';

class LocalData {
  static SharedPreferences? localStorage;

  Future init() async{
    localStorage ??= await SharedPreferences.getInstance();
  }

  void setUid(String uid) async{
    localStorage!.setString('uid', uid);
  }

  void setLevel(String level) async{
    localStorage!.setString('level', level);
  }

  void setAvatar(String avatar) async{
    localStorage!.setString('avatar', avatar);
  }

  void setFirstName(String firstName) async{
    localStorage!.setString('firstName', firstName);
  }

  void setLastName(String lastName) async{
    localStorage!.setString('lastName', lastName);
  }

  void setPseudo(String pseudo) async{
    localStorage!.setString('pseudo', pseudo);
  }

  void setNumber(String number) async{
    localStorage!.setString('number', number);
  }

  void setBirthday(String birthday) async{
    localStorage!.setString('birthday', birthday);
  }

  void setEstablishment(String establishment) async{
    localStorage!.setString('establishment', establishment);
  }

  void setGender(String gender) async{
    localStorage!.setString('gender', gender);
  }

  void setCountry(String country) async{
    localStorage!.setString('country', country);
  }

  String getUid() {
    return localStorage!.getString('uid') ?? '';
  }

  String getFirstName() {
    return localStorage!.getString('firstName') ?? '';
  }

  String getPseudo(){
    return localStorage!.getString('pseudo') ?? '';
  }

  String getLastName(){
    return localStorage!.getString('lastName') ?? '';
  }

  String getGender(){
    return localStorage!.getString('gender') ?? '';
  }

  String getCountry(){
    return localStorage!.getString('country') ?? '';
  }

  String getEstablishment(){
    return localStorage!.getString('establishment') ?? '';
  }

  String getNumber(){
    return localStorage!.getString('number') ?? '';
  }

  String getBirthday(){
    return localStorage!.getString('birthday') ?? '';
  }

  String getLevel(){
    return localStorage!.getString('level') ?? '';
  }

  String getAvatar(){
    return localStorage!.getString('avatar') ?? '';
  }

  void setLoginInfo(Map user) async{
    localStorage!.setString('uid', user["uid"]);
    localStorage!.setString('level', user["level"]);
    localStorage!.setString('avatar', user["avatar"]);
    localStorage!.setString('pseudo', user["pseudo"]);
    localStorage!.setString('number', user["number"]);
    localStorage!.setString('gender', user["gender"]);
    localStorage!.setString('country', user["country"]);
    localStorage!.setString('birthday', user["birthday"]);
    localStorage!.setString('lastName', user["lastName"]);
    localStorage!.setString('lastName', user["lastName"]);
    localStorage!.setString('firstName', user["firstName"]);
    localStorage!.setString('establishment', user["establishment"]);
  }

  String convert(value){
    /*
      Convertir les valeurs pour eviter que les accents créent des problémes
      dans la partie header
    */

    return Uri.encodeComponent(value.toString());
  }

  bool isConnected(){
    if(getUid().isNotEmpty && getFirstName().isNotEmpty && getPseudo().isNotEmpty &&
       getLastName().isNotEmpty && getGender().isNotEmpty && getCountry().isNotEmpty &&
       getEstablishment().isNotEmpty && getNumber().isNotEmpty && getBirthday().isNotEmpty &&
       getLevel().isNotEmpty && getAvatar().isNotEmpty){
      return true;
    }
    else{
      return false;
    }
  }
}
