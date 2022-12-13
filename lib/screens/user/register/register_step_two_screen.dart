import 'package:flutter/material.dart';
import '../../../services/local_data.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:totale_reussite/screens/user/register/register_step_three_screen.dart';

class RegisterStepTwoScreen extends StatefulWidget {
  const RegisterStepTwoScreen({super.key});

  @override
  State<RegisterStepTwoScreen> createState() => RegisterStepTwoScreenState();
}

class RegisterStepTwoScreenState extends State<RegisterStepTwoScreen> {
  String level = "";
  List levels = ["CP1", "CP2", "CE1", "CE2", "CM1", "CM2", "6EME", "5EME",
                 "4EME", "3EME", "2NDE", "1ERE", "TLE", "CAFOP", "ENA",
                 "INFAS", "POLICE", "GENDARMERIE", "INFPA"];

  @override
  initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    double width = MediaQuery. of(context).size.width;
    double containerWidth = (width/2)-15;

    return Scaffold(
        body: Column(
          children: [
            Expanded(
                child: SingleChildScrollView(
                    padding: const EdgeInsets.all(10),
                    child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const SizedBox(height: 20),
                          Text(
                              'Etape 2',
                              style: GoogleFonts.quicksand(
                                  textStyle: const TextStyle(
                                      fontSize: 30,
                                      color: Colors.blue,
                                      fontWeight: FontWeight.bold
                                  )
                              )
                          ),
                          Text(
                              'Choisissez votre niveau',
                              style: GoogleFonts.rubik(
                                  textStyle: const TextStyle(
                                      fontSize: 16,
                                      color: Colors.grey
                                  )
                              )
                          ),
                          const SizedBox(height: 20),
                          Wrap(
                              spacing: 5,
                              children: levels.map(
                                      (e) => GestureDetector(
                                        onTap: (){
                                          setState(() {
                                            level = e.toLowerCase();
                                          });
                                        },
                                        child: Container(
                                            height: 100,
                                            width: containerWidth,
                                            padding: const EdgeInsets.symmetric(
                                                vertical: 15,
                                                horizontal: 10
                                            ),
                                            margin: const EdgeInsets.only(bottom: 15),
                                            decoration: BoxDecoration(
                                                color: level == e.toLowerCase() ? Colors.orange : Colors.white,
                                                border: Border.all(
                                                    color: Colors.grey[200]!
                                                ),
                                                borderRadius: BorderRadius.circular(5)
                                            ),
                                            child: Center(
                                                child: Text(
                                                    e,
                                                    textAlign: TextAlign.center,
                                                    style: GoogleFonts.rubik(
                                                        textStyle: TextStyle(
                                                            fontSize: 18,
                                                            fontWeight: FontWeight.w500,
                                                            color: level == e.toLowerCase() ? Colors.white : Colors.black
                                                        )
                                                    )
                                                )
                                            )
                                        )
                                      )
                              ).toList()
                          )
                        ]
                    )
                )
            ),
            Padding(
                padding: const EdgeInsets.all(15),
                child: SizedBox(
                    height: 50,
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
                          if(level.isNotEmpty){
                            LocalData().setLevel(level);
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => const RegisterStepThreeScreen()
                                )
                            );
                          }
                        },
                        child: Text(
                            "Etape suivante",
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
    );
  }
}