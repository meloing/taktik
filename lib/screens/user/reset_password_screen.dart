import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class ResetPasswordScreen extends StatefulWidget {
  const ResetPasswordScreen({
    super.key,
    required this.code,
    required this.email
  });

  final String code;
  final String email;

  @override
  State<ResetPasswordScreen> createState() => ResetPasswordScreenState();
}

class ResetPasswordScreenState extends State<ResetPasswordScreen> {
  String code = "";
  String email = "";
  bool launch = false;
  final _registerFormKey = GlobalKey<FormState>();
  TextEditingController codeController = TextEditingController();
  TextEditingController newPasswordController = TextEditingController();
  TextEditingController confirmNewPasswordController = TextEditingController();

  Future changePassword()async{
    if(_registerFormKey.currentState!.validate()) {
      setState(() { launch = true; });

      setState(() { launch = false; });
    }
  }

  @override
  initState() {
    super.initState();
    code = widget.code;
    email = widget.email;
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
                "Réinitialisation de mot de passe",
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
                      "Réinitialisation de mot de passe",
                      style: GoogleFonts.quicksand(
                        fontSize: 24,
                        fontWeight: FontWeight.bold
                      )
                  ),
                  const SizedBox(height: 5),
                  Text(
                      "Vous venez de recevoir un code de 6 chiffres à cette adresse: $email"
                          " utilisé le pour reinitialiser votre mot de passe.",
                      style: GoogleFonts.rubik(
                          fontSize: 15,
                          color: Colors.grey
                      )
                  ),
                  const SizedBox(height: 20),
                  Form(
                    key: _registerFormKey,
                    child: Column(
                      children: [
                        TextFormField(
                            controller: codeController,
                            decoration: const InputDecoration(
                                labelText: "Code reçu par mail *",
                                labelStyle: TextStyle(
                                    fontSize: 13,
                                    color: Colors.grey
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
                        TextFormField(
                            controller: newPasswordController,
                            decoration: const InputDecoration(
                                labelText: "Nouveau mot de passe *",
                                labelStyle: TextStyle(
                                    fontSize: 13,
                                    color: Colors.grey
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
                        TextFormField(
                            controller: confirmNewPasswordController,
                            decoration: const InputDecoration(
                                labelText: "Confirmer nouveau mot de passe *",
                                labelStyle: TextStyle(
                                    fontSize: 13,
                                    color: Colors.grey
                                ),
                                border: OutlineInputBorder()
                            ),
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return 'Ce champ est obligatoire';
                              }
                              return null;
                            }
                        )
                      ]
                    )
                  ),
                  const SizedBox(height: 5),
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
                          onPressed: !launch ? changePassword : null,
                          child: !launch ?
                          Text(
                              "Valider",
                              textAlign: TextAlign.center,
                              style: GoogleFonts.rubik(
                                  color: Colors.white
                              )
                          ) :
                          const SizedBox(
                            width: 30,
                            height: 30,
                            child: CircularProgressIndicator()
                          )
                      )
                  )
                ]
            )
        )
    );
  }
}