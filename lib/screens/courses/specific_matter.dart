import 'package:totale_reussite/screens/other/premium_screen.dart';

import '../../services/api.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:totale_reussite/screens/courses/specific_course_screen.dart';

class SpecificMatterScreen extends StatefulWidget {
  const SpecificMatterScreen({
    super.key,
    required this.level,
    required this.subject
  });

  final String level;
  final String subject;

  @override
  State<SpecificMatterScreen> createState() => SpecificMatterScreenState();
}

class SpecificMatterScreenState extends State<SpecificMatterScreen> {
  List topics = [];
  String level = "";
  List courses = [];
  String subject = "";
  bool visible = false;
  bool launchGetTopics = true;
  bool launchGetCourses = true;

  Future addOrUpdateCourse(List values) async{
    // add or update course in local database

    for(Map value in values){
      List course = await LocalDatabase().getCourseById(value["courseId"]);
      if(course.isEmpty){
        await LocalDatabase().addCourse(
            value["courseLevel"],
            value["courseNumber"],
            value["courseSubject"],
            value["courseTitle"],
            value["courseDescription"],
            value["courseDate"],
            value["courseId"],
            value["courseExercises"]
        );
      }
      else{
        await LocalDatabase().updateCourse(
            value["courseLevel"],
            value["courseNumber"],
            value["courseSubject"],
            value["courseTitle"],
            value["courseDescription"],
            value["courseDate"],
            value["courseId"],
            value["courseExercises"]
        );
      }
    }
  }

  Future getCourses() async{
    late List values;
    String lastDate = "";

    // Récupération de la dernière date de cours
    List val = await LocalDatabase().getLastCourseDate(level, subject);
    if(val.isNotEmpty){
      lastDate = val[0]["courseDate"];
    }

    values = await LocalDatabase().getCourses(level, subject);
    if(values.isEmpty){
      values = await ManageDatabase().getCourses(level, subject, lastDate);
      await addOrUpdateCourse(values);
    }

    setState(() {
      courses.addAll(values);
      launchGetCourses = false;
    });

    // Mise à jour des cours
    values = await ManageDatabase().getCourses(level, subject, lastDate);
    await addOrUpdateCourse(values);
  }

  void bottomSheet(){
    showModalBottomSheet<void>(
      elevation: 10,
      context: context,
        shape:const  RoundedRectangleBorder(
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(10),
            topRight: Radius.circular(10)
          )
        ),
      builder: (BuildContext context) {
        return Padding(
          padding: const EdgeInsets.all(5),
          child: Column(
              mainAxisSize: MainAxisSize.min,
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                const Icon(
                    Icons.keyboard_arrow_down_rounded,
                    size: 30
                ),
                const SizedBox(height: 10),
                Text(
                    'Debloquer ce cours',
                    style: GoogleFonts.quicksand(
                        textStyle: const TextStyle(
                            fontSize: 28,
                            color: Color(0xff0e1b42),
                            fontWeight: FontWeight.bold
                        )
                    )
                ),
                const SizedBox(height: 10),
                Text(
                    'Ce cours est gratuit, pour le debloquer, veuillez inviter'
                        ' au moins une personne à télécharger l\'application. '
                        'Veuillez cliquer sur le bouton ci-dessous pour commencer.',
                    textAlign: TextAlign.justify,
                    style: GoogleFonts.rubik(
                        textStyle: const TextStyle(
                            fontSize: 16,
                            color: Color(0xff0e1b42)
                        )
                    )
                ),
                const SizedBox(height: 15),
                SizedBox(
                    height: 56,
                    width: double.infinity,
                    child: TextButton(
                        style: ButtonStyle(
                            backgroundColor: MaterialStateProperty.all<Color>(Colors.blue),
                            shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                                RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(10),
                                )
                            )
                        ),
                        onPressed: (){

                        },
                        child: Text(
                            "J'invite mes amis",
                            style: GoogleFonts.rubik(
                                textStyle: const TextStyle(
                                    fontSize: 16,
                                    color: Colors.white,
                                    fontWeight: FontWeight.w500
                                )
                            )
                        )
                    )
                ),
                const SizedBox(height: 15),
                Container(
                    margin: const EdgeInsets.all(5),
                    padding: const EdgeInsets.all(5),
                    decoration: BoxDecoration(
                        color: Colors.white,
                        border: Border.all(
                            color: Colors.grey[200]!
                        ),
                        borderRadius: BorderRadius.circular(10)
                    ),
                    child: Row(
                        children: [
                          Expanded(
                              child: Text(
                                  "Les membres premium ont accés à tous les "
                                      "cours, sans être obligé d'inviter quelqu'un. Devenez vite "
                                      "prémium pour avoir un accès illimité.",
                                  textAlign: TextAlign.justify,
                                  style: GoogleFonts.rubik(
                                      color: Colors.black
                                  )
                              )
                          ),
                          const SizedBox(width: 5),
                          TextButton(
                              style: ButtonStyle(
                                  backgroundColor: MaterialStateProperty.all<Color>(const Color(0xffB0BAD7)),
                                  shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                                      RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(6),
                                      )
                                  )
                              ),
                              onPressed: (){},
                              child: Text(
                                  "S'abonner",
                                  style: GoogleFonts.rubik(
                                      color: Colors.white
                                  )
                              )
                          )
                        ]
                    )
                )
              ]
          )
        );
      }
    );
  }

  @override
  initState() {
    super.initState();
    level = widget.level;
    subject = widget.subject;
    getCourses();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: const Color(0xfff2f2f2),
        appBar: AppBar(
          elevation: 0,
          centerTitle: true,
          title:  Text(
              "COURS DE $subject".toUpperCase(),
              style: GoogleFonts.quicksand(
                  textStyle: const TextStyle(
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                      fontSize: 18
                  )
              )
          ),
          actions: [
            IconButton(
                onPressed: (){
                  bottomSheet();
                  setState(() {
                    if(visible){
                      visible = false;
                    }
                    else{
                      visible = true;
                    }
                  });
                },
                icon: const Icon(
                    Icons.search
                )
            )
          ]
        ),
        body: Column(
          children: [
            Expanded(
              child: SingleChildScrollView(
                  padding: const EdgeInsets.all(10),
                  child: Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        launchGetCourses ?
                        const Center(
                            child: CircularProgressIndicator()
                        ):
                        courses.isEmpty ?
                        Center(
                            child: Text(
                                "Aucun cours pour le moment revenez plus tard",
                                style: GoogleFonts.quicksand(
                                    textStyle: const TextStyle(
                                        fontWeight: FontWeight.bold
                                    )
                                )
                            )
                        ):
                        Column(
                            children: courses.map(
                                    (e) => Container(
                                            margin: const EdgeInsets.only(bottom: 7),
                                            decoration: BoxDecoration(
                                                color: e["courseIsFinished"] == 'yes' ? Colors.green[200] : Colors.white,
                                                borderRadius: BorderRadius.circular(10)
                                            ),
                                            child: ListTile(
                                              onTap: (){
                                                Navigator.of(context).push(
                                                    MaterialPageRoute(
                                                        builder: (context) => SpecificCourseScreen(
                                                            course: e
                                                        )
                                                    )
                                                );
                                              },
                                              title: Text(
                                                e['courseTitle'].trim()[0].toUpperCase() + e['courseTitle'].trim().substring(1).toLowerCase(),
                                                textAlign: TextAlign.justify,
                                                style: GoogleFonts.rubik(
                                                    textStyle: const TextStyle(
                                                        fontSize: 17,
                                                        color: Colors.black
                                                    )
                                                )
                                            ),
                                            trailing: const Icon(
                                              Icons.arrow_forward_ios_rounded,
                                              size: 16,
                                            )
                                    )
                                )
                            ).toList()
                        )
                      ]
                  )
              )
            ),
            Container(
                padding: const EdgeInsets.all(5),
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
                    )
                ),
                child: Row(
                    children: [
                      Expanded(
                          child: Text(
                              "Devient premium pour accéder à tous nos contenus en"
                                  " illimité. 🥳",
                              style: GoogleFonts.rubik(
                                  color: Colors.black
                              )
                          )
                      ),
                      TextButton(
                          style: ButtonStyle(
                              backgroundColor: MaterialStateProperty.all<Color>(Colors.black),
                              shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                                  RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(6),
                                  )
                              )
                          ),
                          onPressed: (){
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => const PremiumScreen()
                                )
                            );
                          },
                          child: Text(
                              "S'abonner",
                              style: GoogleFonts.rubik(
                                  color: Colors.white
                              )
                          )
                      )
                    ]
                )
            )
          ]
        )
    );
  }
}