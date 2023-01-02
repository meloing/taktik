import 'package:flutter/material.dart';
import '../../services/local_data.dart';
import 'package:google_fonts/google_fonts.dart';

class UserInformationScreen extends StatefulWidget {
  const UserInformationScreen({
    super.key
  });

  @override
  State<UserInformationScreen> createState() => UserInformationScreenState();
}

class UserInformationScreenState extends State<UserInformationScreen> {
  String uid = "";
  String level = "";
  String avatar = "";
  String pseudo = "";
  String number = "";
  String gender = "";
  String country = "";
  String lastName = "";
  String birthday = "";
  String firstName = "";
  String establishment = "";

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
        appBar: AppBar(
            iconTheme: const IconThemeData(
                color: Color(0xff0b65c2)
            ),
            elevation: 0,
            centerTitle: true,
            title: Text(
              "Vos informations",
              style: GoogleFonts.quicksand(
                  color: const Color(0xff0b65c2),
                  fontWeight: FontWeight.bold
              )
          )
        ),
        backgroundColor: const Color(0xffebe6e0),
        body: SingleChildScrollView(
            padding: const EdgeInsets.all(10),
            child: Column(
                children: [
                  Container(
                      width: double.infinity,
                      padding: const EdgeInsets.all(10),
                      decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(5)
                      ),
                      child: Column(
                          children: [
                            ClipRRect(
                                borderRadius: BorderRadius.circular(100),
                                child: Image.asset(
                                    'assets/images/avatar-${LocalData().getAvatar()}.png',
                                    width: 70,
                                    height: 70
                                )
                            ),
                            const SizedBox(height: 15),
                            Text(
                                "${LocalData().getFirstName()} ${LocalData().getLastName()}",
                                style: GoogleFonts.rubik(
                                    fontSize: 16,
                                    fontWeight: FontWeight.bold
                                )
                            ),
                            const SizedBox(height: 5),
                            Text(
                                "@${LocalData().getPseudo()}",
                                style: GoogleFonts.rubik(
                                    fontSize: 14,
                                    color: Colors.grey
                                )
                            )
                          ]
                      )
                  ),
                  const SizedBox(height: 10),
                  Container(
                      padding: const EdgeInsets.only(
                          left: 10,
                          right: 10,
                          bottom: 10
                      ),
                      decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(5)
                      ),
                      child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const SizedBox(height: 10),
                            TextField(
                                enabled: false,
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
                            const SizedBox(height: 10)
                          ]
                      )
                  )
                ]
            )
        )
    );
  }
}