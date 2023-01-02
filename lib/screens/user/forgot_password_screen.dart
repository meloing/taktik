import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:firebase_auth/firebase_auth.dart';

class ForgotPasswordScreen extends StatefulWidget {
  const ForgotPasswordScreen({
    super.key
  });

  @override
  State<ForgotPasswordScreen> createState() => ForgotPasswordScreenState();
}

class ForgotPasswordScreenState extends State<ForgotPasswordScreen> {
  String code = "";
  String info = "";
  String email = "";
  bool launch = false;
  TextEditingController emailController = TextEditingController();

  Future sendCode() async{
    setState(() { launch = true; });

    email = emailController.text;
    try{
      await FirebaseAuth.instance.sendPasswordResetEmail(email: email);
      modal(true);
    }
    on FirebaseAuthException catch (e) {
      if(e.code == "user-not-found"){
        modal(false);
      }
    }

    setState(() { launch = false; });
  }

  void modal(bool value){
    showDialog(
        context: context,
        barrierDismissible: false,
        builder: (context){
          return Dialog(
              shape: const RoundedRectangleBorder(
                  borderRadius: BorderRadius.all(Radius.circular(12))
              ),
              elevation: 0,
              backgroundColor: Colors.transparent,
              insetPadding: const EdgeInsets.all(10),
              child: Container(
                  decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(12)
                  ),
                  child: Column(
                      mainAxisSize: MainAxisSize.min,
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Container(
                            constraints: BoxConstraints.loose(const Size.fromHeight(60)),
                            child: Stack(
                                alignment: Alignment.topCenter,
                                clipBehavior: Clip.none,
                                children: [
                                  Positioned(
                                      top: -50,
                                      child: Image.asset(
                                          "assets/images/unlocked.png",
                                          width: 100,
                                          height: 100,
                                          fit: BoxFit.fill
                                      )
                                  )
                                ]
                            )
                        ),
                        Padding(
                            padding: const EdgeInsets.all(10),
                            child: value ?
                            Column(
                              children: [
                                Text(
                                    "Un email contenant le lien de réinitialisation "
                                        "vient de vous êtes envoyé à cette adresse: $email, cliquez sur le lien pour réinitialiser"
                                        " votre mot de passe.",
                                    textAlign: TextAlign.justify,
                                    style: GoogleFonts.rubik(
                                        textStyle: const TextStyle(
                                            fontSize: 16
                                        )
                                    )
                                ),
                                const SizedBox(height: 10),
                                Row(
                                    children: [
                                      const Icon(
                                          Icons.warning_rounded,
                                          color: Colors.orange
                                      ),
                                      const SizedBox(width: 10),
                                      Expanded(
                                          child: Text(
                                              "Au cas ou vous ne le voyez pas regarder dans votre boite spam.",
                                              textAlign: TextAlign.justify,
                                              style: GoogleFonts.rubik()
                                          )
                                      )
                                    ]
                                )
                              ],
                            ) :
                            Text(
                                "Utilisateur inconnu",
                                textAlign: TextAlign.justify,
                                style: GoogleFonts.rubik(
                                    textStyle: const TextStyle(
                                        fontSize: 16
                                    )
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
                                        backgroundColor: MaterialStateProperty.all<Color>(Colors.black),
                                        shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                                            RoundedRectangleBorder(
                                              borderRadius: BorderRadius.circular(10),
                                            )
                                        )
                                    ),
                                    onPressed: (){
                                      Navigator.pop(context);
                                    },
                                    child: Text(
                                        "Fermer",
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
              )
          );
        });
  }

  @override
  initState() {
    super.initState();
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
                "Mot de passe oublié",
                style: GoogleFonts.quicksand(
                    color: const Color(0xff0b65c2),
                    fontWeight: FontWeight.bold
                )
            )
        ),
        backgroundColor: Colors.white,
        body: Padding(
          padding: const EdgeInsets.all(20),
          child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                    "Saisissez votre adresse e-mail",
                    style: GoogleFonts.quicksand(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    )
                ),
                const SizedBox(height: 20),
                TextFormField(
                    controller: emailController,
                    cursorColor: Colors.black,
                    decoration: const InputDecoration(
                        labelText: "Votre e-mail *",
                        labelStyle: TextStyle(
                            fontSize: 13,
                            color: Colors.grey
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderSide: BorderSide(color: Colors.grey),
                        ),
                        border: OutlineInputBorder()
                    ),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Ce champ est obligatoire';
                      }
                      return null;
                    }
                ),
                const SizedBox(height: 5),
                Text(
                    info,
                    style: GoogleFonts.rubik(
                      fontSize: 15,
                      color: Colors.red
                    )
                ),
                const SizedBox(height: 10),
                SizedBox(
                    height: 56,
                    width: double.infinity,
                    child: TextButton(
                        style: ButtonStyle(
                            backgroundColor: MaterialStateProperty.all<Color>(const Color(0xff0b65c2)),
                            shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                                RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(5),
                                )
                            )
                        ),
                        onPressed: !launch ? sendCode : null,
                        child: !launch ?
                        Text(
                            "Envoyer",
                            textAlign: TextAlign.center,
                            style: GoogleFonts.rubik(
                                color: Colors.white
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
              ]
          )
        )
    );
  }
}