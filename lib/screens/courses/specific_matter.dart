import '../../services/user_api.dart';
import 'package:flutter/material.dart';
import 'package:social_share/social_share.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:totale_reussite/services/local_data.dart';
import 'package:totale_reussite/services/utilities.dart';
import 'package:totale_reussite/services/course_api.dart';
import 'package:totale_reussite/screens/other/premium_screen.dart';
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
  int offset = 0;
  String level = "";
  List courses = [];
  String subject = "";
  bool seeMore = false;
  bool visible = false;
  bool launchPoints = true;
  late StateSetter _setState;
  bool launchGetTopics = true;
  bool launchGetCourses = true;
  String points = LocalData().getPoints();
  final ScrollController _controller = ScrollController();

  Future getCourses() async{
    List values = await CourseOfflineRequests().getCourses(level, subject, offset);
    setState(() {
      if(offset == 0){
        courses.clear();
      }

      if(values.length == 20){
        seeMore = true;
      }
      else{
        seeMore = false;
      }

      courses.addAll(values);
      launchGetCourses = false;
    });
  }

  Future getPoints() async{
    if(points == "0"){
      setState(() { launchPoints = true; });
      String pseudo = LocalData().getPseudo();
      String value = await UserOnlineRequests().getPoints(pseudo);
      _setState(() {
        points = value.isEmpty ? "0" : value;
      });
    }

    setState((){
      launchPoints = false;
    });
  }

  Future unlockCourse(int index) async{
    await CourseOfflineRequests().unlockCourse(courses[index]["courseId"]);
    setState(() {
      courses[index]["type"] = "unlock";
      points = (int.parse(points) - 1).toString();
    });
    LocalData().setPoint(points);

    if(!mounted) return ;
    Navigator.pop(context);
  }

  void modal(int index){
    showDialog(
        context: context,
        barrierDismissible: false,
        builder: (context){
          return StatefulBuilder(
              builder: (context, setState){
                _setState = setState;
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
                        child:
                        Column(
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
                                            child: ClipRRect(
                                                borderRadius: BorderRadius.circular(100),
                                                child: Image.asset(
                                                    "assets/images/unlocked.png",
                                                    width: 100,
                                                    height: 100,
                                                    fit: BoxFit.fill
                                                )
                                            )
                                        ),
                                        Positioned(
                                            top: -2,
                                            right: 0,
                                            child: IconButton(
                                                icon: const Icon(
                                                    Icons.clear_rounded
                                                ),
                                                onPressed: (){
                                                  Navigator.pop(context);
                                                }
                                            )
                                        )
                                      ]
                                  )
                              ),
                              launchPoints ?
                              Padding(
                                  padding: const EdgeInsets.symmetric(vertical: 20),
                                  child: Column(
                                      children: [
                                        const CircularProgressIndicator(
                                            color: Color(0xff0b65c2)
                                        ),
                                        const SizedBox(height: 10),
                                        Text(
                                            "Veuillez patienter",
                                            style: GoogleFonts.rubik()
                                        )
                                      ]
                                  )
                              ) :
                              Column(
                                  children: [
                                    Padding(
                                        padding: const EdgeInsets.all(10),
                                        child: Column(
                                            crossAxisAlignment: CrossAxisAlignment.center,
                                            children: [
                                              Text(
                                                  '$points points',
                                                  style: GoogleFonts.quicksand(
                                                      textStyle: const TextStyle(
                                                          fontSize: 28,
                                                          color: Color(0xff0e1b42),
                                                          fontWeight: FontWeight.bold
                                                      )
                                                  )
                                              ),
                                              const SizedBox(height: 10),
                                              points == "0" ?
                                              Text(
                                                  'Ce cours est gratuit, pour le debloquer, veuillez inviter'
                                                      ' au moins une personne à télécharger l\'application. '
                                                      'Les membres premium ont accés au cours sans être obligé d\'inviter.',
                                                  textAlign: TextAlign.justify,
                                                  style: GoogleFonts.rubik(
                                                      textStyle: const TextStyle(
                                                          fontSize: 16,
                                                          color: Color(0xff0e1b42)
                                                      )
                                                  )
                                              ) :
                                              Text(
                                                  'Vous pouvez debloquer ce cours en cliquant sur '
                                                      'le bouton "Je débloque ce cours" ci-dessous.',
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
                                    const Divider(height: 15),
                                    Padding(
                                        padding: const EdgeInsets.all(10),
                                        child: points == "0" ?
                                        Row(
                                            children: [
                                              Expanded(
                                                  child: SizedBox(
                                                      height: 56,
                                                      width: double.infinity,
                                                      child: TextButton(
                                                          style: ButtonStyle(
                                                              backgroundColor: MaterialStateProperty.all<Color>(Colors.orange),
                                                              shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                                                                  RoundedRectangleBorder(
                                                                      borderRadius: BorderRadius.circular(10)
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
                                                              "Devenir premium",
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
                                                              "J'invite mes amis",
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
                                        ):
                                        SizedBox(
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
                                                onPressed: (){
                                                  unlockCourse(index);
                                                },
                                                child: Text(
                                                    "Je débloque ce cours",
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
                            ]
                        )
                    )
                );
              }
          );
        });
  }

  @override
  initState() {
    super.initState();
    level = widget.level;
    subject = widget.subject;
    getCourses();
    _controller.addListener(() {
      if(_controller.position.pixels == _controller.position.maxScrollExtent){
        if(seeMore){
          offset += 20;
          getCourses();
        }
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: const Color(0xffebe6e0),
        appBar: AppBar(
            iconTheme: const IconThemeData(
                color: Color(0xff0b65c2)
            ),
            elevation: 1,
            centerTitle: true,
            title:  Text(
                "COURS DE $subject".toUpperCase(),
                style: GoogleFonts.quicksand(
                    textStyle: const TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 18,
                        color: Color(0xff0b65c2)
                    )
                )
            )
        ),
        body: Column(
          children: [
            Expanded(
              child: SingleChildScrollView(
                  controller: _controller,
                  child: Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Container(
                            margin: const EdgeInsets.symmetric(
                                horizontal: 7,
                                vertical: 5
                            ),
                            height: 44,
                            child: TextField(
                                // controller: searchController,
                                decoration: InputDecoration(
                                    filled: true,
                                    fillColor: Colors.transparent,
                                    prefixIcon: const Icon(Icons.search_rounded),
                                    border: const OutlineInputBorder(
                                        borderSide: BorderSide(color: Colors.transparent)
                                    ),
                                    labelText: "Recherche un cours",
                                    labelStyle: GoogleFonts.rubik(
                                        fontSize: 13
                                    )
                                ),
                                onChanged: (value){
                                  setState(() {

                                  });
                                }
                            )
                        ),
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
                          children: [
                            Column(
                                children: List<Widget>.generate(
                                    courses.length,
                                        (int index) => Container(
                                        margin: const EdgeInsets.only(bottom: 3),
                                        decoration: BoxDecoration(
                                            color: courses[index]["courseIsFinished"] == 'yes' ? Colors.green[200] : Colors.white
                                        ),
                                        child: ListTile(
                                            onTap: (){
                                              if(courses[index]['type'] == "lock"){
                                                if(Utilities().isPremium()){
                                                  Navigator.of(context).push(
                                                      MaterialPageRoute(
                                                          builder: (context) => SpecificCourseScreen(
                                                              course: courses[index]
                                                          )
                                                      )
                                                  );
                                                }
                                                else{
                                                  getPoints();
                                                  modal(index);
                                                }
                                              }
                                              else{
                                                Navigator.of(context).push(
                                                    MaterialPageRoute(
                                                        builder: (context) => SpecificCourseScreen(
                                                            course: courses[index]
                                                        )
                                                    )
                                                );
                                              }
                                            },
                                            title: Text(
                                                courses[index]['courseTitle'].trim()[0].toUpperCase() + courses[index]['courseTitle'].trim().substring(1).toLowerCase(),
                                                textAlign: TextAlign.justify,
                                                style: GoogleFonts.rubik(
                                                    textStyle: const TextStyle(
                                                        fontSize: 17,
                                                        color: Colors.black
                                                    )
                                                )
                                            ),
                                            trailing: Icon(
                                              courses[index]['type'] == "lock" ? Icons.lock : Icons.lock_open_rounded,
                                              size: 16,
                                            )
                                        )
                                    )
                                )
                            ),
                            const SizedBox(height: 10),
                            Visibility(
                                visible: seeMore,
                                child: const SizedBox(
                                    width: 30,
                                    height: 30,
                                    child: CircularProgressIndicator(
                                        color: Color(0xff0b65c2)
                                    )
                                )
                            ),
                            const SizedBox(height: 10)
                          ]
                        )
                      ]
                  )
              )
            ),
            Container(
                color: Colors.white,
                padding: const EdgeInsets.symmetric(
                    vertical: 3,
                    horizontal: 10
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
                      SizedBox(
                          height: 45,
                          width: 130,
                          child: TextButton(
                              style: ButtonStyle(
                                  backgroundColor: MaterialStateProperty.all<Color>(const Color(0xff0b65c2)),
                                  shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                                      RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(10),
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
                      )
                    ]
                )
            )
          ]
        )
    );
  }
}