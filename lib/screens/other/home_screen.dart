import '../../services/api.dart';
import 'package:flutter/material.dart';
import '../article/article_screen.dart';
import 'package:google_fonts/google_fonts.dart';

import '../article/specific_article_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => HomeScreenState();
}

class HomeScreenState extends State<HomeScreen> {
  List articles = [
    {
      "title": "Comment reussir son examen",
      "description": "Une description ici"
    },
    {
      "title": "Comment reussir son année scolaire",
      "description": "Une description de l'article dans cette partie"
    }
    ];
  List pointsMethods = [
    {
      "date": "2022-11-16 00:49:35",
      "title": "Droites perpendiculaires",
      "description": "Comment demontrer que deux droites sont perpendiculaires"
    },
    {
      "date": "2022-11-16 00:49:35",
      "title": "Droites parallèles",
      "description": "Comment montrer que deux droites sont parallèles"
    },
    {
      "date": "2022-11-16 00:49:35",
      "title": "Equilibrer une équation",
      "description": "Dans ce point méthode on vous montre comment créé un graphique."
    },
    {
      "date": "2022-11-16 00:49:35",
      "title": "Créer un graphique",
      "description": "Dans ce point méthode on vous montre comment créé un graphique."
    },
    {
      "date": "2022-11-16 00:49:35",
      "title": "Développement et réduction",
      "description": "Dans ce point méthode on vous montre comment créé un graphique."
    }
  ];
  bool launchGetClubs = true;

  String returnDay(String date){
    DateTime newDate = DateTime.parse(date);
    List weekdayName = ["Mon", "Tue", "Wed", "Thu", "Fri", "Sat", "Sun"];
    return weekdayName[newDate.weekday-1];
  }

  Future addOrUpdateClub(List values) async{
    // add or update course in local database

    for(Map value in values){
      List club = await LocalDatabase().getClubById(value["clubId"]);
      if(club.isEmpty){
        await LocalDatabase().addClub(
            value["clubId"],
            value["clubName"],
            value["clubDescription"],
            value["clubIcon"],
            value["clubDate"]
        );
      }
      else{
        await LocalDatabase().updateClub(
            value["clubId"],
            value["clubName"],
            value["clubDescription"],
            value["clubIcon"],
            value["clubDate"]
        );
      }
    }
  }

  @override
  initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: const Color(0xfff2f2f2),
        body: SingleChildScrollView(
          padding: const EdgeInsets.all(10),
          child: Column(
             crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Text(
                    "Nos Articles",
                    style: GoogleFonts.quicksand(
                        textStyle: const TextStyle(
                            fontSize: 16,
                            color: Color(0xff0e1b42),
                            fontWeight: FontWeight.bold
                        )
                    )
                ),
                const SizedBox(height: 5),
                Container(
                    height: 150,
                    color: const Color(0xfff2f2f2),
                    child: ListView(
                        scrollDirection: Axis.horizontal,
                        children: articles.map(
                                (e) => Container(
                                width: 300,
                                padding: const EdgeInsets.all(10),
                                margin: const EdgeInsets.only(right: 5),
                                decoration: BoxDecoration(
                                    color: Colors.white,
                                    borderRadius: BorderRadius.circular(10)
                                ),
                                child: Row(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      SizedBox(
                                          height: 119,
                                          width: 90,
                                          child: Padding(
                                            padding: const EdgeInsets.only(top: 6),
                                            child: ClipRRect(
                                                borderRadius: BorderRadius.circular(10),
                                                child: Image.network(
                                                    'https://app.huch.tech/pictures/',
                                                    height: 119,
                                                    width: 100,
                                                    fit: BoxFit.fill
                                                )
                                            )
                                        )
                                      ),
                                      const SizedBox(width: 10),
                                      Expanded(
                                          child: Column(
                                              crossAxisAlignment: CrossAxisAlignment.start,
                                              children: [
                                                const SizedBox(height: 3),
                                                Text(
                                                    e["title"],
                                                    style: GoogleFonts.rubik(
                                                        textStyle: const TextStyle(
                                                            fontSize: 14,
                                                            color: Color(0xff6f7faf),
                                                            fontWeight: FontWeight.bold
                                                        )
                                                    )
                                                ),
                                                const SizedBox(height: 5),
                                                SizedBox(
                                                    height: 40,
                                                    child: Text(
                                                        e["description"],
                                                        // textAlign: TextAlign.justify,
                                                        style: GoogleFonts.rubik(
                                                            textStyle: const TextStyle(
                                                                fontSize: 16,
                                                                color: Color(0xff0e1b42)
                                                            )
                                                        )
                                                    )
                                                ),
                                                Align(
                                                    alignment: Alignment.centerRight,
                                                    child: TextButton(
                                                        onPressed: (){
                                                          Navigator.push(
                                                              context,
                                                              MaterialPageRoute(
                                                                  builder: (context) => const SpecificArticleScreen()
                                                              )
                                                          );
                                                        },
                                                        child: Text(
                                                            "> Lire l'article",
                                                            style: GoogleFonts.quicksand(
                                                                textStyle: const TextStyle(
                                                                    fontSize: 15,
                                                                    color: Colors.black,
                                                                    fontWeight: FontWeight.bold
                                                                )
                                                            )
                                                        )
                                                    )
                                                )
                                              ]
                                          )
                                      )
                                    ]
                                )
                            )
                        ).toList()
                    )
                ),
                const SizedBox(height: 15),
                Container(
                    height: 138,
                    width: double.infinity,
                    padding: const EdgeInsets.symmetric(
                        horizontal: 10,
                        vertical: 30
                    ),
                    decoration: const BoxDecoration(
                        gradient: LinearGradient(
                            colors: [
                              Color(0xff57c0f6),
                              Color(0xff18242b)
                            ],
                            begin: FractionalOffset(0.5, 0),
                            end: FractionalOffset(0.5, 1),
                            stops: [0.0, 1.0],
                            tileMode: TileMode.clamp
                        ),
                        borderRadius: BorderRadius.only(
                            topLeft: Radius.circular(10),
                            topRight: Radius.circular(10)
                        )
                    ),
                    child: Center(
                        child: Text(
                            "Debloquer des cours!",
                            textAlign: TextAlign.center,
                            style: GoogleFonts.quicksand(
                                fontSize: 30,
                                color: Colors.white,
                                fontWeight: FontWeight.bold
                            )
                        )
                    )
                ),
                Container(
                    width: double.infinity,
                    decoration: const BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.only(
                            bottomLeft: Radius.circular(10),
                            bottomRight: Radius.circular(10)
                        )
                    ),
                    padding: const EdgeInsets.symmetric(
                        vertical: 10,
                        horizontal: 20
                    ),
                    child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                              "Share and invite your friends!",
                              style: GoogleFonts.rubik(
                                  fontSize: 15,
                                  fontWeight: FontWeight.bold
                              )
                          ),
                          const SizedBox(height: 5),
                          Text("Invite friends to register on our app. For every user you invite, "
                              "you can earn up 5HPS and 2HPS for your referred.",
                              style: GoogleFonts.rubik(
                                  fontSize: 14
                              )
                          ),
                          const SizedBox(height: 5),
                          SizedBox(
                              width: 110,
                              child: TextButton(
                                  style: ButtonStyle(
                                      backgroundColor: MaterialStateProperty.all<Color>(const Color(0xff178DC9)),
                                      shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                                          RoundedRectangleBorder(
                                            borderRadius: BorderRadius.circular(5),
                                          )
                                      )
                                  ),
                                  onPressed: ()async{

                                  },
                                  child: Text(
                                      "Invite Now",
                                      style: GoogleFonts.rubik(
                                          textStyle: const TextStyle(
                                              fontSize: 15,
                                              color: Colors.white,
                                              fontWeight: FontWeight.w500
                                          )
                                      )
                                  )
                              )
                          )
                        ]
                    )
                ),
                const SizedBox(height: 15),
                Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                          "Points méthodes",
                          style: GoogleFonts.quicksand(
                              textStyle: const TextStyle(
                                  fontSize: 16,
                                  color: Color(0xff0e1b42),
                                  fontWeight: FontWeight.w500
                              )
                          )
                      ),
                      TextButton(
                          onPressed: (){

                          },
                          child: const Text("Tout voir")
                      )
                    ]
                ),
                Column(
                    children: pointsMethods.map(
                            (e) => Container(
                                margin: const EdgeInsets.only(bottom: 7),
                                decoration: BoxDecoration(
                                    color: Colors.white,
                                    borderRadius: BorderRadius.circular(10)
                                ),
                                child: ListTile(
                                    leading: Column(
                                        mainAxisAlignment: MainAxisAlignment.center,
                                        crossAxisAlignment: CrossAxisAlignment.center,
                                        children: [
                                          Text(
                                              returnDay(e["date"].split(" ")[0]),
                                              textAlign: TextAlign.center,
                                              style: GoogleFonts.rubik(
                                                  fontSize: 12,
                                                  color: const Color(0xff6F7FAF)
                                              )
                                          ),
                                          Text(
                                              e["date"].split(" ")[0].split("-")[2],
                                              textAlign: TextAlign.center,
                                              style: GoogleFonts.rubik(
                                                  fontSize: 16,
                                                  fontWeight: FontWeight.w500,
                                                  color: const Color(0xff0E1B42)
                                              )
                                          )
                                        ]
                                    ),
                                    title: Text(
                                        e["title"],
                                        overflow: TextOverflow.ellipsis,
                                        style: GoogleFonts.quicksand(
                                          fontWeight: FontWeight.bold
                                      )
                                    ),
                                    subtitle: Text(
                                      e["description"],
                                      textAlign: TextAlign.justify,
                                      overflow: TextOverflow.ellipsis,
                                      style: GoogleFonts.quicksand(),
                                    ),
                                    trailing: const Icon(
                                      Icons.arrow_forward_ios_rounded,
                                      size: 16,
                                    )
                                )
                            )
                    ).toList()
                ),
                const SizedBox(height: 15),
                Container(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 10,
                        vertical: 30
                    ),
                    decoration: const BoxDecoration(
                        gradient: LinearGradient(
                            colors: [
                              Color(0xffff951a),
                              Color(0xffffd79d)
                            ],
                            begin: FractionalOffset(0.5, - 0.8),
                            end: FractionalOffset(0.5, 1),
                            stops: [0.0, 1.0],
                            tileMode: TileMode.clamp
                        ),
                        borderRadius: BorderRadius.only(
                            topLeft: Radius.circular(10),
                            topRight: Radius.circular(10)
                        )
                    ),
                    child: Row(
                        children: [
                          Expanded(
                              child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                        "Devenir premium",
                                        style: GoogleFonts.rubik(
                                            fontSize: 27,
                                            fontWeight: FontWeight.bold
                                        )
                                    ),
                                    Text(
                                        "pour avoir accès aux cours en illimité!",
                                        style: GoogleFonts.rubik(
                                            fontSize: 13
                                        )
                                    )
                                  ]
                              )
                          ),
                          SizedBox(
                              height: 42,
                              width: 104,
                              child: TextButton(
                                  style: ButtonStyle(
                                      backgroundColor: MaterialStateProperty.all<Color>(Colors.black),
                                      shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                                          RoundedRectangleBorder(
                                            borderRadius: BorderRadius.circular(10),
                                          )
                                      )
                                  ),
                                  onPressed: ()async{

                                  },
                                  child: Text(
                                      "S'abonner",
                                      style: GoogleFonts.rubik(
                                          textStyle: const TextStyle(
                                              fontSize: 16,
                                              color: Colors.white,
                                              fontWeight: FontWeight.w500
                                          )
                                      )
                                  )
                              )
                          )
                        ]
                    )
                ),
              ]
          )
        )
    );
  }
}