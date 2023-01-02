import 'package:flutter/material.dart';
import 'onboarding_page_three_screen.dart';
import 'package:google_fonts/google_fonts.dart';

class OnBoardingPageTwoScreen extends StatefulWidget {
  const OnBoardingPageTwoScreen({super.key});

  @override
  State<OnBoardingPageTwoScreen> createState() => OnBoardingPageTwoScreenState();
}

class OnBoardingPageTwoScreenState extends State<OnBoardingPageTwoScreen> {

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Container(
            decoration: const BoxDecoration(
                color: Colors.white,
              image: DecorationImage(
                  image: AssetImage("assets/images/goal.jpg"),
                  fit: BoxFit.cover
              )
            ),
            child: Container(
                padding: const EdgeInsets.only(

                    left: 20,
                    right: 20,
                    bottom: 15
                ),
                decoration: const BoxDecoration(
                  gradient: LinearGradient(
                      colors: [
                        Colors.transparent,
                        Colors.black,
                      ],
                      begin: FractionalOffset(0.0, 0.0),
                      end: FractionalOffset(0.0, 0.7),
                      stops: [0,  1],
                      tileMode: TileMode.clamp
                  )
                ),
                child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Expanded(
                          child: SizedBox()
                      ),
                      Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Container(
                                width: double.infinity,
                                color: Colors.white,
                                child: Align(
                                    alignment: Alignment.centerLeft,
                                    child: Image.asset(
                                      "assets/images/taktik_logo.jpeg",
                                      width: 150,
                                      height: 50,
                                    )
                                )
                            ),
                            const SizedBox(height: 30),
                            Text(
                                "Les points méthodes",
                                style: GoogleFonts.rubik(
                                    fontSize: 25,
                                    color: Colors.white,
                                    fontWeight: FontWeight.bold
                                )
                            ),
                            const SizedBox(height: 30),
                            Text(
                                "Devenez meilleur grâce à nos points méthodes disponibles dans l'application."
                                    " Une liste de méthodes pour vous aider à résoudre rapidement les exercices.",
                                textAlign: TextAlign.justify,
                                style: GoogleFonts.rubik(
                                    color: Colors.white,
                                    fontSize: 16
                                )
                            ),
                            const SizedBox(height: 10),
                            Row(
                                children: [
                                  Expanded(
                                      child: Container(
                                          decoration: BoxDecoration(
                                              color: Colors.grey,
                                              borderRadius: BorderRadius.circular(5)
                                          ),
                                          height: 2
                                      )
                                  ),
                                  const SizedBox(width: 5),
                                  Expanded(
                                      child: Container(
                                          decoration: BoxDecoration(
                                              color: Colors.white,
                                              borderRadius: BorderRadius.circular(5)
                                          ),
                                          height: 2
                                      )
                                  ),
                                  const SizedBox(width: 5),
                                  Expanded(
                                      child: Container(
                                          decoration: BoxDecoration(
                                              color: Colors.grey,
                                              borderRadius: BorderRadius.circular(5)
                                          ),
                                          height: 2
                                      )
                                  )
                                ]
                            )
                          ]
                      ),
                      const SizedBox(height: 50),
                      SizedBox(
                          height: 56,
                          width: double.infinity,
                          child: TextButton(
                              style: ButtonStyle(
                                  backgroundColor: MaterialStateProperty.all<Color>(Colors.white),
                                  shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                                      RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(10),
                                      )
                                  )
                              ),
                              onPressed: (){
                                Navigator.of(context).push(
                                    MaterialPageRoute(
                                        builder: (context) => const OnBoardingPageThreeScreen()
                                    )
                                );
                              },
                              child: Text(
                                  "Next",
                                  style: GoogleFonts.rubik(
                                      textStyle: const TextStyle(
                                          fontSize: 16,
                                          color: Colors.black,
                                          fontWeight: FontWeight.w500
                                      )
                                  )
                              )
                          )
                      )
                    ]
                )
            )
        )
    );
  }
}
