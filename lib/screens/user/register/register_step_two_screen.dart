import 'package:flutter/material.dart';
import '../../../services/user_api.dart';
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
  List<Map<String, dynamic>> levels = [];

  Future getSubjects() async {
    List subjects = await UserOnlineRequests().getSubjects();
    setState(() {
      for(Map<String, dynamic> subject in subjects){
        levels.add(
          {
            "subjectName": subject["subjectName"],
            "subjectCompletName": subject["subjectCompletName"],
          }
        );
      }
    });
  }

  @override
  initState() {
    super.initState();
    getSubjects();
  }

  @override
  Widget build(BuildContext context) {
    double width = MediaQuery. of(context).size.width;
    double containerWidth = (width/2)-18;

    return Scaffold(
        backgroundColor: Colors.white,
        body: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 30),
            IconButton(
                onPressed: (){
                  Navigator.pop(context);
                },
                icon: const Icon(
                    Icons.arrow_back_ios_new_rounded,
                    color: Color(0xff0b65c2)
                )
            ),
            Expanded(
                child: SingleChildScrollView(
                    padding: const EdgeInsets.all(15),
                    child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const SizedBox(height: 10),
                          Text(
                              'Etape 2',
                              style: GoogleFonts.quicksand(
                                  textStyle: const TextStyle(
                                      fontSize: 30,
                                      color: Color(0xff0b65c2),
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
                          Center(
                            child: Wrap(
                                spacing: 5,
                                children: levels.map(
                                        (e) => GestureDetector(
                                        onTap: (){
                                          setState(() {
                                            level = e["subjectName"].toLowerCase();
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
                                                color: level == e["subjectName"].toLowerCase() ? Colors.orange : Colors.white,
                                                border: Border.all(
                                                    color: Colors.grey[200]!
                                                ),
                                                borderRadius: BorderRadius.circular(5)
                                            ),
                                            child: Center(
                                                child: Text(
                                                    e["subjectCompletName"],
                                                    textAlign: TextAlign.center,
                                                    style: GoogleFonts.rubik(
                                                        textStyle: TextStyle(
                                                            fontSize: 18,
                                                            fontWeight: FontWeight.w500,
                                                            color: level == e["subjectName"].toLowerCase() ? Colors.white : Colors.black
                                                        )
                                                    )
                                                )
                                            )
                                        )
                                    )
                                ).toList()
                            )
                          )
                        ]
                    )
                )
            ),
            Padding(
                padding: const EdgeInsets.all(15),
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