import 'package:flutter/material.dart';
import '../../services/utilities.dart';
import 'package:social_share/social_share.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:totale_reussite/services/course_api.dart';

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

  void modal(){
    showDialog(
        context: context,
        barrierDismissible: false,
        builder: (context){
          return Dialog(
              shape: const RoundedRectangleBorder(
                  borderRadius: BorderRadius.all(Radius.circular(12))
              ),
              elevation: 0,
              backgroundColor: Colors.transparent,
              insetPadding: const EdgeInsets.all(10),
              child: Container(
                  decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(12)
                  ),
                  child: Column(
                      mainAxisSize: MainAxisSize.min,
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Container(
                            constraints: BoxConstraints.loose(const Size.fromHeight(60)),
                            child: Stack(
                                alignment: Alignment.topCenter,
                                clipBehavior: Clip.none,
                                children: [
                                  Positioned(
                                      top: -50,
                                      child: Image.asset(
                                          "assets/images/success.png",
                                          width: 100,
                                          height: 100,
                                          fit: BoxFit.fill
                                      )
                                  )
                                ]
                            )
                        ),
                        Padding(
                            padding: const EdgeInsets.all(10),
                            child: Column(
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
                                  Text(
                                      'Félicitations !!!',
                                      style: GoogleFonts.rubik(
                                          textStyle: const TextStyle(
                                              fontSize: 28,
                                              color: Color(0xff0b65c2),
                                              fontWeight: FontWeight.bold
                                          )
                                      )
                                  ),
                                  const SizedBox(height: 10),
                                  Text(
                                      'Chaque fois que vous finissez un cours vous augmenter '
                                          'votre probabilité de réussite, continuez ainsi et vous '
                                          'serez parmi les meilleurs cette année. '
                                          'Partager ce cours pour aider d\'autres personnes.',
                                      textAlign: TextAlign.justify,
                                      style: GoogleFonts.rubik(
                                          textStyle: const TextStyle(
                                              fontSize: 16,
                                              color: Color(0xff0e1b42)
                                          )
                                      )
                                  )
                                ]
                            )
                        ),
                        Padding(
                            padding: const EdgeInsets.all(10),
                            child:  Row(
                              children: [
                                Expanded(
                                  child: SizedBox(
                                      height: 56,
                                      width: double.infinity,
                                      child: TextButton(
                                          style: ButtonStyle(
                                              backgroundColor: MaterialStateProperty.all<Color>(const Color(0xff0b65c2)),
                                              shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                                                  RoundedRectangleBorder(
                                                    borderRadius: BorderRadius.circular(10),
                                                  )
                                              )
                                          ),
                                          onPressed: ()async{
                                            String linkMessage = await Utilities().createDynamicLink();
                                            String text = "Télécharge  l'application TakTik en cliquant sur ce lien: "
                                                "$linkMessage";
                                            SocialShare.shareOptions(text).then((data) {});
                                          },
                                          child: Text(
                                              "Partager ce cours",
                                              style: GoogleFonts.rubik(
                                                  fontSize: 16,
                                                  color: Colors.white,
                                                  fontWeight: FontWeight.w500
                                              )
                                          )
                                      )
                                  )
                                ),
                                const SizedBox(width: 10),
                                Expanded(
                                  child: SizedBox(
                                      height: 56,
                                      width: double.infinity,
                                      child: TextButton(
                                          style: ButtonStyle(
                                              backgroundColor: MaterialStateProperty.all<Color>(Colors.black),
                                              shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                                                  RoundedRectangleBorder(
                                                    borderRadius: BorderRadius.circular(10),
                                                  )
                                              )
                                          ),
                                          onPressed: (){
                                            Navigator.pop(context);
                                          },
                                          child: Text(
                                              "Fermer",
                                              style: GoogleFonts.rubik(
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
                        )
                      ]
                  )
              )
          );
        });
  }

  Future updateCourseIsFinished() async {
    await CourseOfflineRequests().updateCourseIsFinished(course["courseId"]);
    modal();
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
                        backgroundColor: const Color(0xff0b65c2),
                        bottom: TabBar(
                          indicatorColor: Colors.orange,
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
                                  const Color(0xff0b65c2)
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