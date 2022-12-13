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
          children: [
            Expanded(
                child: SingleChildScrollView(
                    padding: const EdgeInsets.all(10),
                    child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const SizedBox(height: 20),
                          Text(
                              'Etape 3',
                              style: GoogleFonts.quicksand(
                                  textStyle: const TextStyle(
                                      fontSize: 30,
                                      color: Colors.blue,
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
                          Wrap(
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
                          ),
                          const SizedBox(height: 20)
                        ]
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
                              Colors.blue
                          ),
                          shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                              RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(5)
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

                        /*
                            await ManageDatabase().addUser(uid, name, level, pseudo,
                                number, country, civility, birthday, firstName,
                                establishment);
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => const NavScreen()
                                )
                            );

                     */
                      },
                      child: const Text(
                          "Valider",
                          style: TextStyle(
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