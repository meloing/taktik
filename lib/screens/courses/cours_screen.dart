import 'package:flutter/material.dart';
import '../../services/local_data.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:totale_reussite/services/utilities.dart';
import 'package:totale_reussite/services/course_api.dart';
import 'package:totale_reussite/screens/courses/specific_matter.dart';

class CoursesScreen extends StatefulWidget {
  const CoursesScreen({super.key});

  @override
  State<CoursesScreen> createState() => CoursesScreenState();
}

class CoursesScreenState extends State<CoursesScreen> {
  Map subjects = {};

  Future getSubject() async{
    late List values;
    String bdLocation = "local";
    String name = LocalData().getLevel();
    values = await CourseOfflineRequests().getSubjects(name);

    if(values.isEmpty){
      bdLocation = "server";
      values = await CourseOnlineRequests().getSubjectByName(name);
      await CourseOfflineRequests().addSubject(
          values[0]["subjectName"],
          Utilities().mapToText(values[0]["subjectValues"])
      );
    }

    setState(() {
      if(bdLocation == "server"){
        subjects = values[0]["subjectValues"];
      }
      else{
        subjects = Utilities().textToMap(values[0]["subjectValues"]);
      }
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
        backgroundColor: const Color(0xffebe6e0),
        body: SingleChildScrollView(
          padding: const EdgeInsets.only(top: 3),
            child: Column(
                children: subjects.keys.map(
                        (key) => GestureDetector(
                        child: Container(
                            padding: const EdgeInsets.all(10),
                            margin: const EdgeInsets.only(bottom: 3),
                            decoration: const BoxDecoration(
                                color: Colors.white
                            ),
                            child: Row(
                                mainAxisAlignment: MainAxisAlignment.start,
                                children: [
                                  Image.asset(
                                      "assets/images/$key.png",
                                      width: 40,
                                      height: 40
                                  ),
                                  const SizedBox(width: 10),
                                  Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                            subjects[key],
                                            textAlign: TextAlign.center,
                                            style: GoogleFonts.quicksand(
                                                textStyle: const TextStyle(
                                                    fontSize: 18,
                                                    color: Colors.black,
                                                    fontWeight: FontWeight.bold
                                                )
                                            )
                                        ),
                                        const SizedBox(height: 5),
                                        Text(
                                            "20 cours . 30 exercices",
                                            style: GoogleFonts.rubik(
                                                color: Colors.grey
                                            )
                                        )
                                      ]
                                  )
                                ]
                            )
                        ),
                        onTap: (){
                          Navigator.of(context).push(
                              MaterialPageRoute(
                                  builder: (context) => SpecificMatterScreen(
                                      subject: key,
                                      level: LocalData().getLevel()
                                  )
                              )
                          );
                        }
                    )
                ).toList()
            )
        )
    );
  }
}