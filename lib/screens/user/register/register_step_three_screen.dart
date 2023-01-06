import 'package:flutter/material.dart';
import '../../../services/local_data.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:totale_reussite/screens/user/register/register_step_four_screen.dart';

class RegisterStepThreeScreen extends StatefulWidget {
  const RegisterStepThreeScreen({super.key});

  @override
  State<RegisterStepThreeScreen> createState() => RegisterStepThreeScreenState();
}

class RegisterStepThreeScreenState extends State<RegisterStepThreeScreen> {
  String choose = "";
  List avatars = ["1", "2", "3", "4", "5", "6", "7", "8", "9", "10", "11", "12"];

  @override
  initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    double width = MediaQuery. of(context). size. width ;
    double w = (width-60)/3;

    return Scaffold(
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
                          Text(
                              'Etape 3',
                              style: GoogleFonts.quicksand(
                                  textStyle: const TextStyle(
                                      fontSize: 30,
                                      color: Color(0xff0b65c2),
                                      fontWeight: FontWeight.bold
                                  )
                              )
                          ),
                          Text(
                              'Veuillez choisir votre avatar',
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
                                spacing: 10,
                                children: avatars.map(
                                        (e) => GestureDetector(
                                        onTap: (){
                                          setState(() {
                                            choose = e;
                                          });
                                        },
                                        child: SizedBox(
                                            width: w,
                                            height: 120,
                                            child: Center(
                                                child: CircleAvatar(
                                                    radius: 50,
                                                    backgroundColor: choose == e ? Colors.blue : Colors.white,
                                                    child: Padding(
                                                        padding: EdgeInsets.all(choose == e ? 3 : 0),
                                                        child: ClipRRect(
                                                            borderRadius: BorderRadius.circular(100),
                                                            child: Image.asset('assets/images/avatar-$e.png')
                                                        )
                                                    )
                                                )
                                            )
                                        )
                                    )
                                ).toList()
                            )
                          ),
                          const SizedBox(height: 20)
                        ]
                    )
                )
            ),
            Padding(
                padding: const EdgeInsets.all(10),
                child: SizedBox(
                  height: 56,
                  width: double.infinity,
                  child: TextButton(
                      style: ButtonStyle(
                          backgroundColor: MaterialStateProperty.all<Color>(
                              const Color(0xff0b65c2)
                          ),
                          shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                              RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(10)
                              )
                          )
                      ),
                      onPressed: ()async{
                        if(choose.isNotEmpty){
                          LocalData().setAvatar(choose);
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => const RegisterStepFourScreen()
                              )
                          );
                        }
                      },
                      child: Text(
                          "Valider",
                          style: GoogleFonts.rubik(
                              color: Colors.white,
                              fontWeight: FontWeight.bold
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