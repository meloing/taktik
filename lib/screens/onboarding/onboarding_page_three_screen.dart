import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:totale_reussite/screens/user/login_screen.dart';


class OnBoardingPageThreeScreen extends StatefulWidget {
  const OnBoardingPageThreeScreen({super.key});

  @override
  State<OnBoardingPageThreeScreen> createState() => OnBoardingPageThreeScreenState();
}

class OnBoardingPageThreeScreenState extends State<OnBoardingPageThreeScreen> {

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Container(
            decoration: const BoxDecoration(
                color: Colors.white,
                image: DecorationImage(
                    image: AssetImage("assets/images/celebrating.jpg"),
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
                        end: FractionalOffset(0.0, 1),
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
                                "Atteindre vos objectifs",
                                style: GoogleFonts.rubik(
                                    fontSize: 25,
                                    color: Colors.white,
                                    fontWeight: FontWeight.bold
                                )
                            ),
                            const SizedBox(height: 30),
                            Text(
                                "Les cours, exercices, anciens sujets et corrigés, les points méthodes"
                                    " vous aident à atteindre vos objectifs fixés. Cliquez sur le bouton"
                                    " s'inscrire pour commencer.",
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
                                        builder: (context) => const LoginScreen()
                                    )
                                );
                              },
                              child: Text(
                                  "S'inscrire",
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
