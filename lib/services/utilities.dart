import 'dart:io';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:totale_reussite/services/local_data.dart';
import 'package:flutter_parsed_text/flutter_parsed_text.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:firebase_dynamic_links/firebase_dynamic_links.dart';
import 'package:firebase_remote_config/firebase_remote_config.dart';

class MarkDown{
  Widget body(course){
    List courses = course.split("|||");
    return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: courses.asMap().entries.map(
              (item) => Container(
              width: double.infinity,
              margin: const EdgeInsets.all(10),
              child: body2(item.value)
          )
        ).toList()
    );
  }

  Widget body2(course){
    List courses = course.split("||");
    return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: courses.asMap().entries.map(
              (item) => design(item.value)
        ).toList()
    );
  }

  Widget design(text){
    text = text.trim();
    if(text.startsWith('[border]')){
      return Container(
        width: double.infinity,
        margin: const EdgeInsets.symmetric(vertical: 10),
        padding: const EdgeInsets.symmetric(vertical: 10),
        decoration: BoxDecoration(
            color: Colors.grey,
            borderRadius: BorderRadius.circular(5)
        ),
        child: Center(
          child: Text(
              text.replaceAll("[border]", "").toUpperCase(),
              textAlign: TextAlign.center,
              style: GoogleFonts.quicksand(
                  fontSize: 16,
                  color: Colors.white,
                  fontWeight: FontWeight.bold
              )
          )
        )
      );
    }
    else if(text.startsWith('[bggrey]')){
      String t = text.replaceAll("[bggrey]", "");
      return Container(
          width: double.infinity,
          margin: const EdgeInsets.symmetric(vertical: 20),
          child: Text(
              t.toUpperCase(),
              textAlign: TextAlign.justify,
              style: GoogleFonts.quicksand(
                  textStyle: const TextStyle(
                      fontSize: 15,
                      color: Color(0xff0b65c2),
                      fontWeight: FontWeight.bold
                  )
              )
          )
      );
    }
    else if(text.startsWith('[bord]')){
      String t = text.replaceAll("[bord]", "").replaceAll("[/bord]", "");
      return Container(
          width: double.infinity,
          margin: const EdgeInsets.symmetric(vertical: 10),
          padding: const EdgeInsets.all(10),
          decoration: BoxDecoration(
              border: Border.all(
                  color: const Color(0xfff29200)
              )
          ),
          child: textDesign(t)
      );
    }
    else if(text.startsWith('[li]')){
      String t = text.replaceAll("[li]", "");
      return Row(
          children: [
            const Icon(
                Icons.play_arrow,
                color: Color(0xfff29200)
            ),
            Expanded(child: textDesign(t))
          ]
      );
    }
    else if(text.startsWith('[bu]')){
      String t = text.replaceAll("[bu]", "");
      return Padding(
          padding: const EdgeInsets.only(top: 10, left: 0),
          child: Text(
              t,
              style: GoogleFonts.quicksand(
                  textStyle: const TextStyle(
                      fontSize: 20,
                      color: Colors.black,
                      fontWeight: FontWeight.bold,
                      decoration: TextDecoration.underline
                  )
              )
          )
      );
    }
    else if(text.startsWith('[img]')){
      String adr = text.replaceAll("[img]", "");

      return InteractiveViewer(
          panEnabled: true,
          minScale: 1,
          maxScale: 3,
          child: Center(
            child: CachedNetworkImage(
              imageUrl: "https://archetechnology.com/totale-reussite/coursesRessources/$adr",
              placeholder: (context, url) => const Padding(
                  padding: EdgeInsets.all(35),
                  child: CircularProgressIndicator()
              ),
              errorWidget: (context, url, error) => const Padding(
                padding: EdgeInsets.all(35),
                child: Icon(Icons.error)
              )
            )
          )
      );
    }
    else {
      return Padding(
          padding: const EdgeInsets.symmetric(vertical: 5),
          child: textDesign(text)
      );
    }
  }

  Widget textDesign(String text){
    return ParsedText(
        text: text,
        regexOptions: const RegexOptions(
            multiLine : true,
            caseSensitive : false,
            unicode : false,
            dotAll : false
        ),
        alignment: TextAlign.justify,
        style: GoogleFonts.rubik(
          textStyle : const TextStyle(
              fontSize: 17,
              color: Colors.black
          )
        ),
        parse: <MatchText>[
          MatchText(
            pattern: r"\[b\]([^\]|^\[]+)\[/b\]",
            style: GoogleFonts.quicksand(
              textStyle: const TextStyle(
                  color: Colors.black,
                  fontWeight: FontWeight.bold
              )
            ),
            renderText: ({required pattern, required str}) {
              RegExp customRegExp = RegExp(r"\[b\]([^\]|^\[]+)\[/b\]");
              Match match = customRegExp.firstMatch(str)!;
              return {'display': match[1]!};
            },
            onTap: (url) {}
          ),
          MatchText(
              type: ParsedType.URL,
              style: const TextStyle(
                color: Colors.blue
              )
          )
        ]
    );
  }
}

class Utilities{

  String mapToText(Map values){
    String result = "";
    result = values.keys.map((key) => "$key|${values[key]}").toList().join("||");
    return result;
  }

  Map textToMap(String value){
    Map result = {};
    List values = value.split("||");
    for(String v in values){
      List t = v.split("|");
      result[t[0]] = t[1];
    }

    return result;
  }

  bool isPremium(){
    if(LocalData().getPremiumFinish().isEmpty){
      return false;
    }
    else{
      DateTime finishDate = DateTime.parse(LocalData().getPremiumFinish());
      DateTime todayDate = DateTime.now();
      if(finishDate.isBefore(todayDate)){
        return false;
      }
      else{
        return true;
      }
    }

  }

  Future<bool> haveConnection()async{
    try {
      final result = await InternetAddress.lookup('example.com');
      if(result.isNotEmpty && result[0].rawAddress.isNotEmpty) {
        return true;
      } else{
        return false;
      }
    } on SocketException catch (_) {
      return false;
    }
  }

  Future<String> createDynamicLink() async {
    String pseudo = LocalData().getPseudo();
    final DynamicLinkParameters parameters = DynamicLinkParameters(
        uriPrefix: 'https://archetechnology.page.link/',
        link: Uri.parse('https://archetechnology.page.link/$pseudo'),
        androidParameters: const AndroidParameters(
          packageName: 'com.archetechnology.totale_reussite',
          minimumVersion: 0,
        ),
        iosParameters: const IOSParameters(
            bundleId: 'com.archetechnology.totale_reussite',
            minimumVersion: '0'
        )
    );

    final ShortDynamicLink shortLink = await FirebaseDynamicLinks.instance.buildShortLink(parameters);
    return shortLink.shortUrl.toString();
  }

  Future<String> remoteConfigValue(String part) async{
    final remoteConfig = FirebaseRemoteConfig.instance;
    await remoteConfig.setConfigSettings(
        RemoteConfigSettings(
            fetchTimeout: const Duration(minutes: 1),
            minimumFetchInterval: const Duration(minutes: 1)
        )
    );
    await remoteConfig.setDefaults(const {
      "appVersion": "0.5.5",
      "lastProductDate": "",
      "lastArticleDate": "",
      "lastPointMethodDate": "",
      "lastCompetitionDate": ""
    });

    try{
      await remoteConfig.fetchAndActivate();
    }
    catch (_) {}

    if(part == "appVersion"){
      String appVersion = remoteConfig.getString("appVersion");
      return appVersion;
    }
    else if(part == "lastArticleDate"){
      String lastArticleDate = remoteConfig.getString("lastArticleDate");
      return lastArticleDate;
    }
    else if(part == "lastPointMethodDate"){
      String lastPointMethodDate = remoteConfig.getString("lastPointMethodDate");
      return lastPointMethodDate;
    }
    else if(part == "lastCompetitionDate"){
      String lastCompetitionDate = remoteConfig.getString("lastCompetitionDate");
      return lastCompetitionDate;
    }
    else{
      String lastProductDate = remoteConfig.getString("lastProductDate");
      return lastProductDate;
    }
  }
}