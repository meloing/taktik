import '../../services/api.dart';
import '../other/premium_screen.dart';
import 'package:flutter/material.dart';
import '../../services/local_data.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:totale_reussite/services/utilities.dart';
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
    values = await LocalDatabase().getSubjects(name);

    if(values.isEmpty){
      bdLocation = "server";
      values = await ManageDatabase().getSubjectByName(name);
      await LocalDatabase().addSubject(
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
        backgroundColor: Colors.grey[200]!.withOpacity(0.1),
        body: Column(
          children: [
            Expanded(
              child: SingleChildScrollView(
                  padding: const EdgeInsets.all(10),
                  child: Column(
                      children: [
                        Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Expanded(
                                  child: Container(
                                      height: 100,
                                      decoration: BoxDecoration(
                                          color: Colors.white,
                                          borderRadius: BorderRadius.circular(12),
                                          border: Border.all(
                                              color: Colors.grey[200]!
                                          )
                                      ),
                                      child: Column(
                                          mainAxisAlignment: MainAxisAlignment.center,
                                          crossAxisAlignment: CrossAxisAlignment.center,
                                          children: [
                                            Text(
                                                "20 / 40",
                                                style: GoogleFonts.quicksand(
                                                    textStyle: const TextStyle(
                                                        fontSize: 20,
                                                        color: Colors.black,
                                                        fontWeight: FontWeight.bold
                                                    )
                                                )
                                            ),
                                            const SizedBox(height: 10),
                                            Text(
                                                "Cours terminés",
                                                style: GoogleFonts.rubik(
                                                    textStyle: const TextStyle(
                                                        fontSize: 14,
                                                        color: Colors.blue
                                                    )
                                                )
                                            )
                                          ]
                                      )
                                  )
                              ),
                              const SizedBox(width: 5),
                              Expanded(
                                  child: Container(
                                      height: 100,
                                      decoration: BoxDecoration(
                                          color: Colors.white,
                                          borderRadius: BorderRadius.circular(12),
                                          border: Border.all(
                                              color: Colors.grey[200]!
                                          )
                                      ),
                                      child: Column(
                                          mainAxisAlignment: MainAxisAlignment.center,
                                          crossAxisAlignment: CrossAxisAlignment.center,
                                          children: [
                                            Text(
                                                "15 / 20",
                                                style: GoogleFonts.quicksand(
                                                    textStyle: const TextStyle(
                                                        fontSize: 20,
                                                        color: Colors.black,
                                                        fontWeight: FontWeight.bold
                                                    )
                                                )
                                            ),
                                            const SizedBox(height: 10),
                                            Text(
                                                "Moyenne générale",
                                                style: GoogleFonts.rubik(
                                                    textStyle: const TextStyle(
                                                        fontSize: 14,
                                                        color: Colors.blue
                                                    )
                                                )
                                            )
                                          ]
                                      )
                                  )
                              )
                            ]
                        ),
                        const SizedBox(height: 15),
                        Column(
                            children: subjects.keys.map(
                                    (key) => GestureDetector(
                                    child: Container(
                                        padding: const EdgeInsets.all(10),
                                        margin: const EdgeInsets.only(bottom: 5),
                                        decoration: BoxDecoration(
                                            color: Colors.white,
                                            borderRadius: BorderRadius.circular(5),
                                            border: Border.all(
                                                color: Colors.grey[200]!
                                            )
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
                                                        "20 cours . 30 exercices . 20 quiz",
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
                      ]
                  )
              )
            )
          ]
        )
    );
  }
}