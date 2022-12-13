import '../../services/api.dart';
import 'package:flutter/material.dart';
import '../../services/utilities.dart';
import 'package:google_fonts/google_fonts.dart';

class SpecificCourseScreen extends StatefulWidget {
  const SpecificCourseScreen({
    super.key,
    required this.course
  });

  final Map course;

  @override
  State<SpecificCourseScreen> createState() => SpecificCourseScreenState();
}

class SpecificCourseScreenState extends State<SpecificCourseScreen> {
  Map course = {};
  String path = "";

  Future updateCourseIsFinished() async {
    await LocalDatabase().updateCourseIsFinished(course["courseId"]);
  }

  @override
  initState() {
    super.initState();
    course = widget.course;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Expanded(
                  child: DefaultTabController(
                    length: 3,
                    child: Scaffold(
                      appBar: AppBar(
                        elevation: 0,
                        centerTitle: true,
                        title: Center(
                          child: Text(
                              course["courseTitle"],
                              style: GoogleFonts.quicksand(
                                  textStyle: const TextStyle(
                                      fontSize: 16,
                                      color: Colors.white,
                                      fontWeight: FontWeight.bold
                                  )
                              )
                            )
                        ),
                        actions: [
                          IconButton(
                              onPressed: (){},
                              icon: const Icon(
                                Icons.share_rounded
                              )
                          )
                        ],
                        backgroundColor: Colors.blue,
                        bottom: TabBar(
                          labelColor: Colors.white,
                          tabs: [
                            Tab(
                                child: Text(
                                    "COURS",
                                    style: GoogleFonts.quicksand(
                                      fontWeight: FontWeight.bold
                                    )
                                )
                            ),
                            Tab(
                                child: Text(
                                    "EXERCICES",
                                    style: GoogleFonts.quicksand(
                                        fontWeight: FontWeight.bold
                                    )
                                )
                            ),
                            Tab(
                                child: Text(
                                    "CORRIGES",
                                    style: GoogleFonts.quicksand(
                                        fontWeight: FontWeight.bold
                                    )
                                )
                            )
                          ]
                        )
                      ),
                      backgroundColor: Colors.white,
                        body: TabBarView(
                          children: [
                            SingleChildScrollView(
                                child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      MarkDown().body(course["courseDescription"]),
                                      const SizedBox(height: 5)
                                    ]
                                )
                            ),
                            SingleChildScrollView(
                                child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      MarkDown().body(course["courseExercises"]),
                                      const SizedBox(height: 5)
                                    ]
                                )
                            ),
                            const SingleChildScrollView(
                              child: Text("")
                            )
                          ]
                        )
                    )
                  )
              ),
              Padding(
                  padding: const EdgeInsets.all(10),
                  child: SizedBox(
                      height: 50,
                      width: double.infinity,
                      child: TextButton(
                          style: ButtonStyle(
                              backgroundColor: MaterialStateProperty.all<Color>(
                                  Colors.orange
                              ),
                              shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                                  RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(5)
                                  )
                              )
                          ),
                          onPressed: updateCourseIsFinished,
                          child: Text(
                            "J'ai terminé ce cours",
                            style: GoogleFonts.quicksand(
                                textStyle: const TextStyle(
                                    color: Colors.white,
                                    fontWeight: FontWeight.bold
                                )
                            )
                          )
                      )
                  )
              )
            ]
        )
    );
  }
}