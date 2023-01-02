import 'home_screen.dart';
import '../user/profil_screen.dart';
import '../courses/cours_screen.dart';
import 'package:flutter/material.dart';
import '../../services/course_api.dart';
import '../../services/local_data.dart';
import '../product/products_screen.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:totale_reussite/screens/topics/topics_screen.dart';

class NavScreen extends StatefulWidget {
  const NavScreen({super.key});

  @override
  State<NavScreen> createState() => NavScreenState();
}

class NavScreenState extends State<NavScreen> with TickerProviderStateMixin{
  int index = 0;
  String number = " ";
  List<Widget> screens = const[
    HomeScreen(),
    CoursesScreen(),
    ProductsScreen(),
    TopicsScreen()
  ];

  Future percentageSuccess() async{
    int numberCourse = await CourseOfflineRequests().getNumberCourse();
    int numberFinished = await CourseOfflineRequests().getNumberFinishedCourse();

    setState(() {
      if(numberCourse == 0 || numberFinished == 0){
        number = "0";
      }
      else{
        number = ((numberFinished/numberCourse)*100).round().toString();
      }
    });
  }

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
                                      'Reussite',
                                      style: GoogleFonts.rubik(
                                          textStyle: const TextStyle(
                                              fontSize: 28,
                                              color: Color(0xff0b65c2),
                                              fontWeight: FontWeight.bold
                                          )
                                      )
                                  ),
                                  Text(
                                      "$number %",
                                      style: GoogleFonts.rubik(
                                          textStyle: const TextStyle(
                                              fontSize: 30,
                                              color: Color(0xff0b65c2),
                                              fontWeight: FontWeight.bold
                                          )
                                      )
                                  ),
                                  const SizedBox(height: 10),
                                  Text(
                                      'Votre pourcentage de reussite est déterminé '
                                          'par le nombre de cours terminés. A chaque fois'
                                          'que vous finissez un cours n\'oublié pas de '
                                          'marquer ce cours comme terminé pour augmenter '
                                          'votre pourcentage de reussite.',
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
          );
        });
  }

  @override
  void initState() {
    super.initState();
    percentageSuccess();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: const Color(0xffebe6e0),
        body: Column(
        children: [
          Container(
              padding: const EdgeInsets.all(10),
              decoration: const BoxDecoration(
                  color: Colors.white
              ),
              child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const SizedBox(height: 10),
                    Row(
                        children: [
                          Expanded(
                              child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                        "Bonjour",
                                        style: GoogleFonts.rubik(
                                            textStyle: const TextStyle(
                                                fontSize: 13,
                                                color: Color(0xff0b65c2)
                                            )
                                        )
                                    ),
                                    Text(
                                        "${LocalData().getFirstName()} ${LocalData().getLastName()}",
                                        style: GoogleFonts.rubik(
                                            textStyle: const TextStyle(
                                                fontSize: 18,
                                                color: Color(0xff0b65c2),
                                                fontWeight: FontWeight.w500
                                            )
                                        )
                                    )
                                  ]
                              )
                          ),
                          TextButton(
                              onPressed: (){
                                Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) => const ProfileScreen()
                                    )
                                );
                              },
                              child: ClipRRect(
                                  borderRadius: BorderRadius.circular(100),
                                  child: Image.asset(
                                      'assets/images/avatar-${LocalData().getAvatar()}.png',
                                      width: 50,
                                      height: 50
                                  )
                              )
                          )
                        ]
                    ),
                    const SizedBox(height: 5),
                    Text(
                        "Reussite",
                        style: GoogleFonts.rubik(
                            textStyle: const TextStyle(
                                fontSize: 10,
                                color: Color(0xff0b65c2),
                                fontWeight: FontWeight.w500
                            )
                        )
                    ),
                    const SizedBox(height: 5),
                    GestureDetector(
                      onTap: modal,
                      child: Text(
                          "$number %",
                          style: GoogleFonts.rubik(
                              textStyle: const TextStyle(
                                  fontSize: 22,
                                  color: Color(0xff0b65c2),
                                  fontWeight: FontWeight.w600
                              )
                          )
                      )
                    )
                  ]
              )
          ),
          Expanded(
              child: IndexedStack(
                  index: index,
                  children: screens
              )
          ),
          Container(
              padding: const EdgeInsets.symmetric(
                horizontal: 5
              ),
              decoration: BoxDecoration(
                  color: Colors.white,
                  boxShadow: [
                    BoxShadow(
                        color: const Color(0xff646464).withOpacity(0.224),
                        spreadRadius: 0,
                        blurRadius: 5,
                        offset: const Offset(5, 1)
                    )
                  ]
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  TextButton(
                      onPressed: (){
                        setState(() {
                          index = 0;
                        });
                      },
                      child: Column(
                          children: [
                            Icon(
                              Icons.home_rounded,
                              color: index == 0 ? const Color(0xff0b65c2) : const Color(0xff888888)
                            ),
                            Text(
                                "Home",
                                style: GoogleFonts.rubik(
                                    color: index == 0 ? const Color(0xff0b65c2) : const Color(0xff888888)
                                )
                            )
                          ]
                      )
                  ),
                  TextButton(
                      onPressed: (){
                        setState(() {
                          index = 1;
                        });
                      },
                      child: Column(
                          children: [
                            Icon(
                              Icons.lightbulb_rounded,
                              color: index == 1 ? const Color(0xff0b65c2) : const Color(0xff888888)
                            ),
                            Text(
                                "Bosser",
                                style: GoogleFonts.rubik(
                                    color: index == 1 ? const Color(0xff0b65c2) : const Color(0xff888888)
                                )
                            )
                          ]
                      )
                  ),
                  TextButton(
                      onPressed: (){
                        setState(() {
                          index = 2;
                        });
                      },
                      child: Column(
                          children: [
                            Icon(
                              Icons.copy_rounded,
                              color: index == 2 ? const Color(0xff0b65c2) : const Color(0xff888888)
                            ),
                            Text(
                                "Anales",
                                style: GoogleFonts.rubik(
                                    color: index == 2 ? const Color(0xff0b65c2) : const Color(0xff888888)
                                )
                            )
                          ]
                      )
                  ),
                  TextButton(
                      onPressed: (){
                        setState(() {
                          index = 3;
                        });
                      },
                      child: Column(
                          children: [
                            Icon(
                              Icons.keyboard_command_key_rounded,
                              color: index == 3 ? const Color(0xff0b65c2) : const Color(0xff888888)
                            ),
                            Text(
                                "Sujets",
                                style: GoogleFonts.rubik(
                                    color: index == 3 ? const Color(0xff0b65c2) : const Color(0xff888888)
                                )
                            )
                          ]
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
