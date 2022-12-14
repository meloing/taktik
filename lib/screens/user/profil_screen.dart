import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';
import '../../services/local_data.dart';
import 'package:social_share/social_share.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:google_fonts/google_fonts.dart';
import '../competition/competition_screen.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:totale_reussite/screens/user/login_screen.dart';
import 'package:totale_reussite/screens/other/premium_screen.dart';
import 'package:totale_reussite/screens/user/user_informations_screen.dart';

import '../product/buy_product_screen.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({
    super.key
  });

  @override
  State<ProfileScreen> createState() => ProfileScreenState();
}

class ProfileScreenState extends State<ProfileScreen> {
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
              "PROFIL",
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
                SizedBox(
                  height: 50,
                  child: Container(
                      decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(5)
                      ),
                      child: TextButton(
                        style: ButtonStyle(
                            shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                                RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(5)
                                )
                            )
                        ),
                        onPressed: () async{
                          if(!mounted) return;
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => const CompetitionScreen()
                              )
                          );
                        },
                        child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              const Icon(
                                  Icons.add_card_rounded,
                                  color: Colors.green
                              ),
                              const SizedBox(width: 5),
                              Text(
                                  "Concours",
                                  style: GoogleFonts.rubik(
                                      color: const Color(0xff0b65c2)
                                  )
                              ),
                              const Expanded(
                                  child: Align(
                                      alignment: Alignment.centerRight,
                                      child: Icon(Icons.arrow_forward_ios_rounded)
                                  )
                              )
                            ]
                        )
                    )
                  )
                ),
                const SizedBox(height: 10),
                SizedBox(
                    height: 50,
                    child: Container(
                        decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(5)
                        ),
                        child: TextButton(
                            style: ButtonStyle(
                                shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                                    RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(5)
                                    )
                                )
                            ),
                            onPressed: (){
                              Navigator.of(context).push(
                                  MaterialPageRoute(
                                      builder: (context) => const BuyProductScreen()
                                  )
                              );
                            },
                            child: Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
                                  const Icon(
                                      Icons.file_copy_rounded,
                                      color: Colors.purple
                                  ),
                                  const SizedBox(width: 5),
                                  Text(
                                      "Vos documents",
                                      style: GoogleFonts.rubik(
                                          color: const Color(0xff0b65c2)
                                      )
                                  ),
                                  const Expanded(
                                      child: Align(
                                          alignment: Alignment.centerRight,
                                          child: Icon(Icons.arrow_forward_ios_rounded)
                                      )
                                  )
                                ]
                            )
                        )
                    )
                ),
                const SizedBox(height: 10),
                Row(
                    children: [
                      Expanded(
                          child: Container(
                              decoration: BoxDecoration(
                                  color: Colors.white,
                                  borderRadius: BorderRadius.circular(5)
                              ),
                              child: TextButton(
                                  style: ButtonStyle(
                                      padding: MaterialStateProperty.all<EdgeInsets>(const EdgeInsets.all(10)),
                                      shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                                          RoundedRectangleBorder(
                                              borderRadius: BorderRadius.circular(5)
                                          )
                                      )
                                  ),
                                  onPressed: (){
                                    String text = "Je t'invite ?? d??couvrir l'application Totale Reussite!"
                                        "Disponible au lien suivant: \n\n"
                                        "https://play.google.com/store/apps/details?id=com.archetechnology.totale_reussite";
                                    SocialShare.shareOptions(text).then((data) {});
                                  },
                                  child: Column(
                                      children: [
                                        const Icon(
                                            Icons.send_rounded,
                                            size: 30,
                                            color: Colors.blue
                                        ),
                                        const SizedBox(height: 5),
                                        Text(
                                            "Partager l'APP",
                                            style: GoogleFonts.rubik(
                                                color: const Color(0xff0b65c2)
                                            )
                                        )
                                      ]
                                  )
                              )
                          )
                      ),
                      const SizedBox(width: 5),
                      Expanded(
                          child: Container(
                              decoration: BoxDecoration(
                                  color: Colors.white,
                                  borderRadius: BorderRadius.circular(5)
                              ),
                              child: TextButton(
                                  style: ButtonStyle(
                                      padding: MaterialStateProperty.all<EdgeInsets>(const EdgeInsets.all(10)),
                                      shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                                          RoundedRectangleBorder(
                                              borderRadius: BorderRadius.circular(5)
                                          )
                                      )
                                  ),
                                  onPressed: ()async{
                                    var url = Uri.parse("https://play.google.com/store/apps/details?id=com.archetechnology.totale_reussite");
                                    if (!await launchUrl(url)) throw '';
                                  },
                                  child: Column(
                                      children: [
                                        const Icon(
                                            Icons.star_rounded,
                                            size: 30,
                                            color: Colors.yellow
                                        ),
                                        const SizedBox(height: 5),
                                        Text(
                                            "Noter l'app",
                                            style: GoogleFonts.rubik(
                                                color: const Color(0xff0b65c2)
                                            )
                                        )
                                      ]
                                  )
                              )
                          )
                      )
                    ]
                ),
                const SizedBox(height: 10),
                Row(
                    children: [
                      Expanded(
                          child: Container(
                              decoration: BoxDecoration(
                                  color: Colors.white,
                                  borderRadius: BorderRadius.circular(5)
                              ),
                              child: TextButton(
                                  style: ButtonStyle(
                                      padding: MaterialStateProperty.all<EdgeInsets>(const EdgeInsets.all(10)),
                                      shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                                          RoundedRectangleBorder(
                                              borderRadius: BorderRadius.circular(5)
                                          )
                                      )
                                  ),
                                  onPressed: ()async{
                                    var url = Uri.parse("whatsapp://send?phone=+2250709263037");
                                    if (!await launchUrl(url)) throw '';
                                  },
                                  child: Column(
                                      children: [
                                        const Icon(
                                            Icons.call_rounded,
                                            size: 30,
                                            color: Colors.red
                                        ),
                                        const SizedBox(height: 5),
                                        Text(
                                            "Nous contacter",
                                            style: GoogleFonts.rubik(
                                                color: const Color(0xff0b65c2)
                                            )
                                        )
                                      ]
                                  )
                              )
                          )
                      ),
                      const SizedBox(width: 5),
                      Expanded(
                          child: Container(
                              decoration: BoxDecoration(
                                  color: Colors.white,
                                  borderRadius: BorderRadius.circular(5)
                              ),
                              child: TextButton(
                                  style: ButtonStyle(
                                      padding: MaterialStateProperty.all<EdgeInsets>(const EdgeInsets.all(10)),
                                      shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                                          RoundedRectangleBorder(
                                              borderRadius: BorderRadius.circular(5)
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
                                  child: Column(
                                      children: [
                                        const Icon(
                                            Icons.workspace_premium_rounded,
                                            size: 30,
                                            color: Colors.green
                                        ),
                                        const SizedBox(height: 5),
                                        Text(
                                            "Devenir premium",
                                            style: GoogleFonts.rubik(
                                                color: const Color(0xff0b65c2)
                                            )
                                        )
                                      ]
                                  )
                              )
                          )
                      )
                    ]
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
                        Row(
                          children: [
                            Expanded(
                              child: Text(
                                  "VOS INFORMATIONS",
                                  style: GoogleFonts.rubik(
                                      fontWeight: FontWeight.bold
                                  )
                              )
                            ),
                            TextButton(
                                onPressed: (){
                                  Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                          builder: (context) => const UserInformationScreen()
                                      )
                                  );
                                },
                                child: Text(
                                    "Tout voir",
                                    style: GoogleFonts.rubik(
                                        color: const Color(0xff0b65c2),
                                        fontWeight: FontWeight.bold
                                    )
                                )
                            )
                          ]
                        ),
                        TextField(
                            enabled: false,
                            controller: TextEditingController(text: pseudo),
                            decoration: InputDecoration(
                                labelText: "Pseudo",
                                contentPadding: const EdgeInsets.all(5),
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
                                contentPadding: const EdgeInsets.all(5),
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
                                labelText: "Pr??noms",
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
                                labelText: "Num??ro",
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
                                contentPadding: const EdgeInsets.all(5),
                                border: const OutlineInputBorder(),
                                labelStyle: GoogleFonts.rubik(
                                    textStyle: const TextStyle(
                                        fontSize: 13,
                                        color: Colors.grey
                                    )
                                )
                            )
                        )
                      ]
                  )
                ),
                const SizedBox(height: 10),
                Container(
                    height: 50,
                    decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(5)
                    ),
                    child: TextButton(
                      style: ButtonStyle(
                          shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                              RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(5)
                              )
                          )
                      ),
                      onPressed: () async{
                        if (await GoogleSignIn().isSignedIn()) {
                          await GoogleSignIn().disconnect().catchError((e, stack) {});
                        }
                        await FirebaseAuth.instance.signOut();
                        LocalData().setNumber("");

                        if(!mounted) return;
                        Navigator.pushReplacement(
                            context,
                            MaterialPageRoute(
                                builder: (context) => const LoginScreen()
                            )
                        );
                      },
                      child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            const Icon(
                                Icons.power_off,
                                size: 30,
                                color: Colors.red
                            ),
                            const SizedBox(width: 5),
                            Text(
                              "Deconnexion",
                              style: GoogleFonts.rubik(
                                color: const Color(0xff0b65c2)
                              )
                            ),
                            const Expanded(
                                child: Align(
                                  alignment: Alignment.centerRight,
                                  child: Icon(Icons.arrow_forward_ios_rounded),
                                )
                            )
                          ]
                      )
                  )
                )
              ]
          )
        )
    );
  }
}