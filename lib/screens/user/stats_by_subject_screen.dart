import 'package:totale_reussite/services/course_api.dart';

import '../../services/api.dart';
import 'package:flutter/material.dart';
import '../../services/utilities.dart';
import '../../services/local_data.dart';
import 'package:google_fonts/google_fonts.dart';

class StatsByScreen extends StatefulWidget {
  const StatsByScreen({
    super.key
  });

  @override
  State<StatsByScreen> createState() => StatsByScreenState();
}

class StatsByScreenState extends State<StatsByScreen> {
  Map subjects = {};
  bool launchGetSubject = true;

  Future getSubject() async{
    String level = LocalData().getLevel();
    List values = await CourseOfflineRequests().getSubjects(level);
    Map temp = Utilities().textToMap(values[0]["subjectValues"]);
    Map tempRes = {};
    for(String key in temp.keys){
      int numberCourse = await CourseOfflineRequests().getNumberCourse();
      int numberCourseFinished = await CourseOfflineRequests().getNumberFinishedCourse();

      tempRes[key] = {
        "name" : temp[key],
        "numberCourse": numberCourse,
        "numberCourseFinished": numberCourseFinished
      };
    }

    setState(() {
      subjects = tempRes;
      launchGetSubject = false;
    });
  }

  @override
  initState() {
    super.initState();
    getSubject();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          elevation: 0,
          centerTitle: true,
          title: Text(
              "Statistiques par matières",
              style: GoogleFonts.rubik(
                fontWeight: FontWeight.w500
              )
          )
        ),
        body: launchGetSubject ?
        const Center(
          child: CircularProgressIndicator(),
        ) :
        SingleChildScrollView(
          child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Column(
                    children: subjects.keys.map(
                            (key) => Card(
                                child: Padding(
                                    padding: const EdgeInsets.all(10),
                                    child: Column(
                                        crossAxisAlignment: CrossAxisAlignment.start,
                                        children: [
                                          Text(
                                              "COURS DE ${subjects[key]["name"].toUpperCase()}",
                                              style: GoogleFonts.rubik(
                                                  color: Colors.blue,
                                                  fontWeight: FontWeight.bold
                                              )
                                          ),
                                          const SizedBox(height: 25),
                                          Row(
                                              children: [
                                                Expanded(
                                                    child: Column(
                                                        children: [
                                                          Text(
                                                              subjects[key]["numberCourse"].toString(),
                                                              style: GoogleFonts.rubik(
                                                                  fontWeight: FontWeight.w500
                                                              )
                                                          ),
                                                          Text(
                                                              "Total",
                                                              style: GoogleFonts.rubik()
                                                          )
                                                        ]
                                                    )
                                                ),
                                                Expanded(
                                                    child: Column(
                                                        children: [
                                                          Text(
                                                              subjects[key]["numberCourseFinished"].toString(),
                                                              style: GoogleFonts.rubik(
                                                                  fontWeight: FontWeight.w500
                                                              )
                                                          ),
                                                          Text(
                                                              "Terminés",
                                                              style: GoogleFonts.rubik()
                                                          )
                                                        ]
                                                    )
                                                ),
                                                Expanded(
                                                    child: Column(
                                                        children: [
                                                          Text(
                                                              (subjects[key]["numberCourse"]-subjects[key]["numberCourseFinished"]).toString() ,
                                                              style: GoogleFonts.rubik(
                                                                  fontWeight: FontWeight.w500
                                                              )
                                                          ),
                                                          Text(
                                                              "Restants",
                                                              style: GoogleFonts.rubik()
                                                          )
                                                        ]
                                                    )
                                                )
                                              ]
                                          )
                                        ]
                                    )
                                )
                            )
                    ).toList()
                )
              ]
          )
        )
    );
  }
}