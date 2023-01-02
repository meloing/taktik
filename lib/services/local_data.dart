import 'dart:core';
import 'package:shared_preferences/shared_preferences.dart';

class LocalData {
  static SharedPreferences? localStorage;

  Future init() async{
    localStorage ??= await SharedPreferences.getInstance();
  }

  void setCourseLastManageDate(String courseLastManageDate) async{
    localStorage!.setString('courseLastManageDate', courseLastManageDate);
  }

  void setArticleLastManageDate(String articleLastManageDate) async{
    localStorage!.setString('articleLastManageDate', articleLastManageDate);
  }

  void setMethodLastManageDate(String methodLastManageDate) async{
    localStorage!.setString('methodLastManageDate', methodLastManageDate);
  }

  void setProductLastManageDate(String productLastManageDate) async{
    localStorage!.setString('productLastManageDate', productLastManageDate);
  }

  void setTopicLastManageDate(String topicLastManageDate) async{
    localStorage!.setString('topicLastManageDate', topicLastManageDate);
  }

  void setCompetitionLastManageDate(String competitionLastManageDate) async{
    localStorage!.setString('competitionLastManageDate', competitionLastManageDate);
  }

  void setReferralCode(String referralCode) async{
    localStorage!.setString('referralCode', referralCode);
  }

  void setPremium(String premium) async{
    localStorage!.setString('premium', premium);
  }

  void setPremiumFinish(String premiumFinish) async{
    localStorage!.setString('premiumFinish', premiumFinish);
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

  void setPoint(String points) async{
    localStorage!.setString('points', points);
  }

  String getPoints() {
    return localStorage!.getString('points') ?? '0';
  }

  String getAppLocalVersion() {
    return localStorage!.getString('appLocalVersion') ?? '0.5.5';
  }

  String getReferralCode() {
    return localStorage!.getString('referralCode') ?? '';
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

  String getPremium(){
    return localStorage!.getString('premium') ?? '';
  }

  String getPremiumFinish(){
    return localStorage!.getString('premiumFinish') ?? '';
  }

  String getCourseLastManageDate() {
    return localStorage!.getString('courseLastManageDate') ?? '2000-12-31 00:00:00';
  }

  String getArticleLastManageDate() {
    return localStorage!.getString('articleLastManageDate') ?? '2000-12-31 00:00:00';
  }

  String getMethodLastManageDate() {
    return localStorage!.getString('methodLastManageDate') ?? '2000-12-31 00:00:00';
  }

  String getProductLastManageDate() {
    return localStorage!.getString('productLastManageDate') ?? '2000-12-31 00:00:00';
  }

  String getTopicLastManageDate() {
    return localStorage!.getString('topicLastManageDate') ?? '2000-12-31 00:00:00';
  }

  String getCompetitionLastManageDate() {
    return localStorage!.getString('competitionLastManageDate') ?? '2000-12-31 00:00:00';
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
