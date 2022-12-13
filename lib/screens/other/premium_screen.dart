import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class PremiumScreen extends StatefulWidget {
  const PremiumScreen({super.key});

  @override
  State<PremiumScreen> createState() => PremiumScreenState();
}

class PremiumScreenState extends State<PremiumScreen> {

  @override
  initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          elevation: 0,
          centerTitle: true,
          title: Text(
              "DEVENIR PREMIUM",
              style: GoogleFonts.quicksand(
                fontWeight: FontWeight.bold
              )
          ),
        ),
        backgroundColor: Colors.grey[200],
        body: SingleChildScrollView(
          child: Column(
              children: <Widget>[
                Container(
                    margin: const EdgeInsets.all(5),
                    padding: const EdgeInsets.all(10),
                    decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(10)
                    ),
                    child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                              children: [
                                const Icon(
                                    Icons.card_giftcard_rounded,
                                    size: 30,
                                    color: Colors.purple
                                ),
                                const SizedBox(width: 10),
                                Text(
                                    "PREMIUM JOUR",
                                    style: GoogleFonts.quicksand(
                                        fontSize: 20,
                                        color: Colors.purple,
                                        fontWeight: FontWeight.bold
                                    )
                                )
                              ]
                          ),
                          const SizedBox(height: 10),
                          Text(
                              "150 FCFA / jour",
                              style: GoogleFonts.quicksand(
                                  fontSize: 20,
                                  color: Colors.purple,
                                  fontWeight: FontWeight.bold
                              )
                          ),
                          const SizedBox(height: 20),
                          Row(
                              children: [
                                const Icon(
                                  Icons.check,
                                  color: Colors.green,
                                ),
                                const SizedBox(width: 10),
                                Text(
                                    "Accés tous les cours sans limitation",
                                    style: GoogleFonts.quicksand(
                                      fontSize: 16,
                                      fontWeight: FontWeight.w500
                                    )
                                )
                              ]
                          ),
                          const SizedBox(height: 10),
                          Row(
                              children: [
                                const Icon(
                                  Icons.check,
                                  color: Colors.green,
                                ),
                                const SizedBox(width: 10),
                                Text(
                                    "Accés tous les sujets sans limitation",
                                    style: GoogleFonts.quicksand(
                                        fontSize: 16,
                                        fontWeight: FontWeight.w500
                                    )
                                )
                              ]
                          ),
                          const SizedBox(height: 10),
                          Row(
                              children: [
                                const Icon(
                                  Icons.check,
                                  color: Colors.green,
                                ),
                                const SizedBox(width: 10),
                                Text(
                                    "Accés à tous les quizz sans limite",
                                    style: GoogleFonts.quicksand(
                                        fontSize: 16,
                                        fontWeight: FontWeight.w500
                                    )
                                )
                              ]
                          ),
                          const SizedBox(height: 10),
                          Row(
                              children: [
                                const Icon(
                                  Icons.check,
                                  color: Colors.green,
                                ),
                                const SizedBox(width: 10),
                                Text(
                                    "Accés aux statistiques par matières",
                                    style: GoogleFonts.quicksand(
                                        fontSize: 16,
                                        fontWeight: FontWeight.w500
                                    )
                                )
                              ]
                          ),
                          const SizedBox(height: 10),
                          Row(
                              children: [
                                const Icon(
                                  Icons.check,
                                  color: Colors.green,
                                ),
                                const SizedBox(width: 10),
                                Text(
                                    "Enregistrement des cours hors ligne",
                                    style: GoogleFonts.quicksand(
                                        fontSize: 16,
                                        fontWeight: FontWeight.w500
                                    )
                                )
                              ]
                          ),
                          const SizedBox(height: 10),
                          Row(
                              children: [
                                const Icon(
                                  Icons.check,
                                  color: Colors.green,
                                ),
                                const SizedBox(width: 10),
                                Text(
                                    "Alerte information importante",
                                    style: GoogleFonts.quicksand(
                                        fontSize: 16,
                                        fontWeight: FontWeight.w500
                                    )
                                )
                              ]
                          ),
                          const SizedBox(height: 10),
                          Row(
                              children: [
                                const Icon(
                                  Icons.check,
                                  color: Colors.green,
                                ),
                                const SizedBox(width: 10),
                                Text(
                                    "Accés à nos clubs sans limitation",
                                    style: GoogleFonts.quicksand(
                                        fontSize: 16,
                                        fontWeight: FontWeight.w500
                                    )
                                )
                              ]
                          ),
                          const SizedBox(height: 10),
                          Row(
                              children: [
                                const Icon(
                                  Icons.check,
                                  color: Colors.green,
                                ),
                                const SizedBox(width: 10),
                                Text(
                                    "Accés à tous les concours",
                                    style: GoogleFonts.quicksand(
                                        fontSize: 16,
                                        fontWeight: FontWeight.w500
                                    )
                                )
                              ]
                          ),
                          const SizedBox(height: 20),
                          Center(
                              child: SizedBox(
                                  height: 55,
                                  width: double.infinity,
                                  child: TextButton(
                                      style: ButtonStyle(
                                          backgroundColor: MaterialStateProperty.all<Color>(Colors.purple),
                                          shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                                              RoundedRectangleBorder(
                                                  borderRadius: BorderRadius.circular(10)
                                              )
                                          )
                                      ),
                                      onPressed: null,
                                      child: Text(
                                          "Souscrire",
                                          style: GoogleFonts.rubik(
                                              color: Colors.white,
                                              fontWeight: FontWeight.bold
                                          )
                                      )
                                  )
                              )
                          ),
                          const SizedBox(height: 5)
                        ]
                    )
                ),
                const SizedBox(height: 15),
                Container(
                    margin: const EdgeInsets.all(5),
                    padding: const EdgeInsets.all(10),
                    decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(10)
                    ),
                    child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                              children: [
                                const Icon(
                                    Icons.near_me_rounded,
                                    size: 30,
                                    color: Colors.blue
                                ),
                                const SizedBox(width: 10),
                                Text(
                                    "PREMIUM MOIS",
                                    style: GoogleFonts.quicksand(
                                        fontSize: 20,
                                        color: Colors.blue,
                                        fontWeight: FontWeight.bold
                                    )
                                )
                              ]
                          ),
                          const SizedBox(height: 10),
                          Text(
                              "1 500 FCFA / mois",
                              style: GoogleFonts.quicksand(
                                  fontSize: 20,
                                  color: Colors.blue,
                                  fontWeight: FontWeight.bold
                              )
                          ),
                          const SizedBox(height: 20),
                          Row(
                              children: [
                                const Icon(
                                  Icons.check,
                                  color: Colors.green,
                                ),
                                const SizedBox(width: 10),
                                Text(
                                    "Accés tous les cours sans limitation",
                                    style: GoogleFonts.quicksand(
                                        fontSize: 16,
                                        fontWeight: FontWeight.w500
                                    )
                                )
                              ]
                          ),
                          const SizedBox(height: 10),
                          Row(
                              children: [
                                const Icon(
                                  Icons.check,
                                  color: Colors.green,
                                ),
                                const SizedBox(width: 10),
                                Text(
                                    "Accés tous les sujets sans limitation",
                                    style: GoogleFonts.quicksand(
                                        fontSize: 16,
                                        fontWeight: FontWeight.w500
                                    )
                                )
                              ]
                          ),
                          const SizedBox(height: 10),
                          Row(
                              children: [
                                const Icon(
                                  Icons.check,
                                  color: Colors.green,
                                ),
                                const SizedBox(width: 10),
                                Text(
                                    "Accés à tous les quizz sans limite",
                                    style: GoogleFonts.quicksand(
                                        fontSize: 16,
                                        fontWeight: FontWeight.w500
                                    )
                                )
                              ]
                          ),
                          const SizedBox(height: 10),
                          Row(
                              children: [
                                const Icon(
                                  Icons.check,
                                  color: Colors.green,
                                ),
                                const SizedBox(width: 10),
                                Text(
                                    "Accés aux statistiques par matières",
                                    style: GoogleFonts.quicksand(
                                        fontSize: 16,
                                        fontWeight: FontWeight.w500
                                    )
                                )
                              ]
                          ),
                          const SizedBox(height: 10),
                          Row(
                              children: [
                                const Icon(
                                  Icons.check,
                                  color: Colors.green,
                                ),
                                const SizedBox(width: 10),
                                Text(
                                    "Enregistrement des cours hors ligne",
                                    style: GoogleFonts.quicksand(
                                        fontSize: 16,
                                        fontWeight: FontWeight.w500
                                    )
                                )
                              ]
                          ),
                          const SizedBox(height: 10),
                          Row(
                              children: [
                                const Icon(
                                  Icons.check,
                                  color: Colors.green,
                                ),
                                const SizedBox(width: 10),
                                Text(
                                    "Alerte information importante",
                                    style: GoogleFonts.quicksand(
                                        fontSize: 16,
                                        fontWeight: FontWeight.w500
                                    )
                                )
                              ]
                          ),
                          const SizedBox(height: 10),
                          Row(
                              children: [
                                const Icon(
                                  Icons.check,
                                  color: Colors.green,
                                ),
                                const SizedBox(width: 10),
                                Text(
                                    "Accés à nos clubs sans limitation",
                                    style: GoogleFonts.quicksand(
                                        fontSize: 16,
                                        fontWeight: FontWeight.w500
                                    )
                                )
                              ]
                          ),
                          const SizedBox(height: 10),
                          Row(
                              children: [
                                const Icon(
                                  Icons.check,
                                  color: Colors.green,
                                ),
                                const SizedBox(width: 10),
                                Text(
                                    "Accés à tous les concours",
                                    style: GoogleFonts.quicksand(
                                        fontSize: 16,
                                        fontWeight: FontWeight.w500
                                    )
                                )
                              ]
                          ),
                          const SizedBox(height: 20),
                          Center(
                              child: SizedBox(
                                  height: 55,
                                  width: double.infinity,
                                  child: TextButton(
                                      style: ButtonStyle(
                                          backgroundColor: MaterialStateProperty.all<Color>(Colors.blue),
                                          shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                                              RoundedRectangleBorder(
                                                  borderRadius: BorderRadius.circular(10)
                                              )
                                          )
                                      ),
                                      onPressed: (){},
                                      child: Text(
                                          "Souscrire",
                                          style: GoogleFonts.rubik(
                                              color: Colors.white,
                                              fontWeight: FontWeight.bold
                                          )
                                      )
                                  )
                              )
                          ),
                          const SizedBox(height: 5)
                        ]
                    )
                ),
                const SizedBox(height: 15),
                Container(
                    margin: const EdgeInsets.all(5),
                    padding: const EdgeInsets.all(10),
                    decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(10)
                    ),
                    child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                              children: [
                                const Icon(
                                    Icons.airplanemode_on_rounded,
                                    size: 30,
                                    color: Colors.green
                                ),
                                const SizedBox(width: 10),
                                Text(
                                    "PREMIUM AN",
                                    style: GoogleFonts.quicksand(
                                        fontSize: 20,
                                        color: Colors.green,
                                        fontWeight: FontWeight.bold
                                    )
                                )
                              ]
                          ),
                          const SizedBox(height: 10),
                          Text(
                              "12 000 FCFA / mois",
                              style: GoogleFonts.quicksand(
                                  fontSize: 20,
                                  color: Colors.green,
                                  fontWeight: FontWeight.bold
                              )
                          ),
                          const SizedBox(height: 20),
                          Row(
                              children: [
                                const Icon(
                                  Icons.check,
                                  color: Colors.green
                                ),
                                const SizedBox(width: 10),
                                Text(
                                    "Accés tous les cours sans limitation",
                                    style: GoogleFonts.quicksand(
                                        fontSize: 16,
                                        fontWeight: FontWeight.w500
                                    )
                                )
                              ]
                          ),
                          const SizedBox(height: 10),
                          Row(
                              children: [
                                const Icon(
                                  Icons.check,
                                  color: Colors.green,
                                ),
                                const SizedBox(width: 10),
                                Text(
                                    "Accés tous les sujets sans limitation",
                                    style: GoogleFonts.quicksand(
                                        fontSize: 16,
                                        fontWeight: FontWeight.w500
                                    )
                                )
                              ]
                          ),
                          const SizedBox(height: 10),
                          Row(
                              children: [
                                const Icon(
                                  Icons.check,
                                  color: Colors.green,
                                ),
                                const SizedBox(width: 10),
                                Text(
                                    "Accés à tous les quizz sans limite",
                                    style: GoogleFonts.quicksand(
                                        fontSize: 16,
                                        fontWeight: FontWeight.w500
                                    )
                                )
                              ]
                          ),
                          const SizedBox(height: 10),
                          Row(
                              children: [
                                const Icon(
                                  Icons.check,
                                  color: Colors.green,
                                ),
                                const SizedBox(width: 10),
                                Text(
                                    "Accés aux statistiques par matières",
                                    style: GoogleFonts.quicksand(
                                        fontSize: 16,
                                        fontWeight: FontWeight.w500
                                    )
                                )
                              ]
                          ),
                          const SizedBox(height: 10),
                          Row(
                              children: [
                                const Icon(
                                  Icons.check,
                                  color: Colors.green,
                                ),
                                const SizedBox(width: 10),
                                Text(
                                    "Enregistrement des cours hors ligne",
                                    style: GoogleFonts.quicksand(
                                        fontSize: 16,
                                        fontWeight: FontWeight.w500
                                    )
                                )
                              ]
                          ),
                          const SizedBox(height: 10),
                          Row(
                              children: [
                                const Icon(
                                  Icons.check,
                                  color: Colors.green,
                                ),
                                const SizedBox(width: 10),
                                Text(
                                    "Alerte information importante",
                                    style: GoogleFonts.quicksand(
                                        fontSize: 16,
                                        fontWeight: FontWeight.w500
                                    )
                                )
                              ]
                          ),
                          const SizedBox(height: 10),
                          Row(
                              children: [
                                const Icon(
                                  Icons.check,
                                  color: Colors.green,
                                ),
                                const SizedBox(width: 10),
                                Text(
                                    "Accés à nos clubs sans limitation",
                                    style: GoogleFonts.quicksand(
                                        fontSize: 16,
                                        fontWeight: FontWeight.w500
                                    )
                                )
                              ]
                          ),
                          const SizedBox(height: 10),
                          Row(
                              children: [
                                const Icon(
                                  Icons.check,
                                  color: Colors.green,
                                ),
                                const SizedBox(width: 10),
                                Text(
                                    "Accés à tous les concours",
                                    style: GoogleFonts.quicksand(
                                        fontSize: 16,
                                        fontWeight: FontWeight.w500
                                    )
                                )
                              ]
                          ),
                          const SizedBox(height: 20),
                          Center(
                              child: SizedBox(
                                  height: 55,
                                  width: double.infinity,
                                  child: TextButton(
                                      style: ButtonStyle(
                                          backgroundColor: MaterialStateProperty.all<Color>(Colors.green),
                                          shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                                              RoundedRectangleBorder(
                                                  borderRadius: BorderRadius.circular(10)
                                              )
                                          )
                                      ),
                                      onPressed: (){},
                                      child: Text(
                                          "Souscrire",
                                          style: GoogleFonts.rubik(
                                              color: Colors.white,
                                              fontWeight: FontWeight.bold
                                          )
                                      )
                                  )
                              )
                          ),
                          const SizedBox(height: 5)
                        ]
                    )
                )
              ]
          )
        )
    );
  }
}