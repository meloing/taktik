import 'package:flutter/material.dart';
import '../../../services/user_api.dart';
import '../../../services/local_data.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:totale_reussite/screens/other/nav_screen.dart';

class RegisterStepFourScreen extends StatefulWidget {
  const RegisterStepFourScreen({
    super.key
  });

  @override
  State<RegisterStepFourScreen> createState() => RegisterStepFourScreenState();
}

class RegisterStepFourScreenState extends State<RegisterStepFourScreen> {
  String uid = "";
  String level = "";
  String avatar = "";
  String pseudo = "";
  String number = "";
  String gender = "";
  bool launch = false;
  String country = "";
  String lastName = "";
  String birthday = "";
  String firstName = "";
  String establishment = "";

  Future register() async {
    setState(() { launch = true; });
    String referral = LocalData().getReferralCode();

    await UserOnlineRequests().addUser(
        uid, firstName, level, pseudo, number, country,
        birthday, lastName, establishment, avatar, gender
    );
    await UserOnlineRequests().sendReferral(referral);

    if(!mounted) return;
    Navigator.pushReplacement(
        context,
        MaterialPageRoute(
            builder: (context) => const NavScreen()
        )
    );

    setState(() { launch = false; });
  }

  @override
  initState() {
    super.initState();
    uid = LocalData().getUid();
    level = LocalData().getLevel();
    avatar = LocalData().getAvatar();
    pseudo = LocalData().getPseudo();
    number = LocalData().getNumber();
    gender = LocalData().getGender();
    country = LocalData().getCountry();
    lastName = LocalData().getLastName();
    birthday = LocalData().getBirthday();
    firstName = LocalData().getFirstName();
    establishment = LocalData().getEstablishment();
  }

  @override
  Widget build(BuildContext context) {

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
                            'Dernière étape',
                            style: GoogleFonts.quicksand(
                                textStyle: const TextStyle(
                                    fontSize: 30,
                                    color: Color(0xff0b65c2),
                                    fontWeight: FontWeight.bold
                                )
                            )
                        ),
                        Text(
                            'Veuillez vérifier vos informations',
                            style: GoogleFonts.rubik(
                                textStyle: const TextStyle(
                                    fontSize: 16,
                                    color: Colors.grey
                                )
                            )
                        ),
                        const SizedBox(height: 20),
                        Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              TextField(
                                  enabled: false,
                                  style: GoogleFonts.rubik(),
                                  controller: TextEditingController(text: pseudo),
                                  decoration: InputDecoration(
                                    labelText: "Pseudo",
                                    border: const OutlineInputBorder(),
                                    labelStyle: GoogleFonts.rubik(
                                        textStyle: const TextStyle(
                                            fontSize: 13,
                                            color: Colors.grey
                                        )
                                    )
                                )
                              ),
                              const SizedBox(height: 10),
                              TextField(
                                  enabled: false,
                                  style: GoogleFonts.rubik(),
                                  controller: TextEditingController(text: firstName),
                                  decoration: InputDecoration(
                                      labelText: "Nom",
                                      border: const OutlineInputBorder(),
                                      labelStyle: GoogleFonts.rubik(
                                          textStyle: const TextStyle(
                                              fontSize: 13,
                                              color: Colors.grey
                                          )
                                      )
                                  )
                              ),
                              const SizedBox(height: 10),
                              TextField(
                                  enabled: false,
                                  style: GoogleFonts.rubik(),
                                  controller: TextEditingController(text: lastName),
                                  decoration: InputDecoration(
                                      labelText: "Prénoms",
                                      border: const OutlineInputBorder(),
                                      labelStyle: GoogleFonts.rubik(
                                          textStyle: const TextStyle(
                                              fontSize: 13,
                                              color: Colors.grey
                                          )
                                      )
                                  )
                              ),
                              const SizedBox(height: 10),
                              TextField(
                                  enabled: false,
                                  style: GoogleFonts.rubik(),
                                  controller: TextEditingController(text: number),
                                  decoration: InputDecoration(
                                      labelText: "Numéro",
                                      border: const OutlineInputBorder(),
                                      labelStyle: GoogleFonts.rubik(
                                          textStyle: const TextStyle(
                                              fontSize: 13,
                                              color: Colors.grey
                                          )
                                      )
                                  )
                              ),
                              const SizedBox(height: 10),
                              TextField(
                                  enabled: false,
                                  style: GoogleFonts.rubik(),
                                  controller: TextEditingController(text: country),
                                  decoration: InputDecoration(
                                      labelText: "Pays",
                                      border: const OutlineInputBorder(),
                                      labelStyle: GoogleFonts.rubik(
                                          textStyle: const TextStyle(
                                              fontSize: 13,
                                              color: Colors.grey
                                          )
                                      )
                                  )
                              ),
                              const SizedBox(height: 10),
                              TextField(
                                  enabled: false,
                                  style: GoogleFonts.rubik(),
                                  controller: TextEditingController(text: birthday),
                                  decoration: InputDecoration(
                                      labelText: "Date de naissance",
                                      border: const OutlineInputBorder(),
                                      labelStyle: GoogleFonts.rubik(
                                          textStyle: const TextStyle(
                                              fontSize: 13,
                                              color: Colors.grey
                                          )
                                      )
                                  )
                              ),
                              const SizedBox(height: 10),
                              TextField(
                                  enabled: false,
                                  style: GoogleFonts.rubik(),
                                  controller: TextEditingController(text: establishment),
                                  decoration: InputDecoration(
                                      labelText: "Etablissement",
                                      border: const OutlineInputBorder(),
                                      labelStyle: GoogleFonts.rubik(
                                          textStyle: const TextStyle(
                                              fontSize: 13,
                                              color: Colors.grey
                                          )
                                      )
                                  )
                              ),
                              const SizedBox(height: 10),
                              TextField(
                                  enabled: false,
                                  style: GoogleFonts.rubik(),
                                  controller: TextEditingController(text: level),
                                  decoration: InputDecoration(
                                      labelText: "Niveau",
                                      border: const OutlineInputBorder(),
                                      labelStyle: GoogleFonts.rubik(
                                          textStyle: const TextStyle(
                                              fontSize: 13,
                                              color: Colors.grey
                                          )
                                      )
                                  )
                              ),
                              const SizedBox(height: 10),
                              TextField(
                                  enabled: false,
                                  style: GoogleFonts.rubik(),
                                  controller: TextEditingController(text: gender),
                                  decoration: InputDecoration(
                                      labelText: "Genre",
                                      border: const OutlineInputBorder(),
                                      labelStyle: GoogleFonts.rubik(
                                          textStyle: const TextStyle(
                                              fontSize: 13,
                                              color: Colors.grey
                                          )
                                      )
                                  )
                              ),
                              const SizedBox(height: 15),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  Text(
                                      "Avatar",
                                      style: GoogleFonts.rubik(
                                          textStyle: const TextStyle(
                                              fontSize: 13,
                                              color: Colors.grey
                                          )
                                      )
                                  ),
                                  ClipRRect(
                                      borderRadius: BorderRadius.circular(100),
                                      child: Image.asset(
                                          'assets/images/avatar-$avatar.png',
                                          width: 75
                                      )
                                  )
                                ]
                              )
                            ]
                        )
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
                                    borderRadius: BorderRadius.circular(5)
                                )
                            )
                        ),
                        onPressed: !launch ? register : null,
                        child: !launch ?
                        Text(
                          "Valider",
                          style: GoogleFonts.rubik(
                              color: Colors.white,
                              fontWeight: FontWeight.bold
                          )
                        ) :
                        const SizedBox(
                          width: 30,
                          height: 30,
                          child: CircularProgressIndicator(
                            color: Colors.white
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