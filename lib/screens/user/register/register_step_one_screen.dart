import 'package:flutter/material.dart';
import '../../../services/local_data.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:totale_reussite/screens/user/register/register_step_two_screen.dart';

import '../../../services/user_api.dart';

class RegisterStepOneScreen extends StatefulWidget {
  const RegisterStepOneScreen({
    super.key,
    required this.uid,
    required this.siginMethod
  });

  final String uid;
  final String siginMethod;

  @override
  State<RegisterStepOneScreen> createState() => RegisterStepOneScreenState();
}

class RegisterStepOneScreenState extends State<RegisterStepOneScreen> {
  String uid = "";
  bool launch = false;
  String sigInMethod = "";
  String country = "Choisissez votre pays";
  String gender = 'Choisissez votre genre';
  final _registerFormKey = GlobalKey<FormState>();
  var items = ['Choisissez votre genre', 'Masculin', 'Feminin'];
  var countryItems = ['Choisissez votre pays', 'Côte d\'Ivoire'];

  TextEditingController pseudoController = TextEditingController();
  TextEditingController numberController = TextEditingController();
  TextEditingController birthdayController = TextEditingController();
  TextEditingController lastNameController = TextEditingController();
  TextEditingController firstNameController = TextEditingController();
  TextEditingController establishmentController = TextEditingController();

  void modal(){
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
                  width: 500,
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
                                      child: ClipRRect(
                                          borderRadius: BorderRadius.circular(100),
                                          child: Image.asset(
                                              "assets/images/unlocked.png",
                                              width: 100,
                                              height: 100,
                                              fit: BoxFit.fill
                                          )
                                      )
                                  )
                                ]
                            )
                        ),
                        Padding(
                          padding: const EdgeInsets.all(10),
                          child: Center(
                            child: RichText(
                              text: TextSpan(
                                  text: 'Ce pseudo  ',
                                  style: GoogleFonts.quicksand(
                                      textStyle: const TextStyle(
                                          fontSize: 22,
                                          color: Color(0xff0e1b42),
                                          fontWeight: FontWeight.bold
                                      )
                                  ),
                                  children: <TextSpan>[
                                    TextSpan(
                                        text: pseudoController.text,
                                        style: GoogleFonts.quicksand(
                                            textStyle: const TextStyle(
                                                fontSize: 22,
                                                color: Colors.red,
                                                fontWeight: FontWeight.bold
                                            )
                                        )
                                    ),
                                    TextSpan(
                                        text: "  est déjà utilisé par une autre personne. Veuillez choisir un autre.",
                                        style: GoogleFonts.quicksand(
                                            textStyle: const TextStyle(
                                                fontSize: 22,
                                                color: Color(0xff0e1b42),
                                                fontWeight: FontWeight.bold
                                            )
                                        )
                                    )
                                  ]
                              )
                            )
                          )
                        ),
                        const SizedBox(height: 10),
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

  Future getStepTwo()async{
    if(_registerFormKey.currentState!.validate()){
      setState(() { launch = true; });
      String pseudo = pseudoController.text;
      String number = numberController.text;
      String birthday = birthdayController.text;
      String lastName = lastNameController.text;
      String firstName = firstNameController.text;
      String establishment = establishmentController.text;

      LocalData().setUid(uid);
      LocalData().setNumber(number);
      LocalData().setPseudo(pseudo);
      LocalData().setGender(gender);
      LocalData().setCountry(country);
      LocalData().setLastName(lastName);
      LocalData().setBirthday(birthday);
      LocalData().setFirstName(firstName);
      LocalData().setEstablishment(establishment);

      List val = await UserOnlineRequests().getUserByPseudo(pseudo);
      if(val.isNotEmpty){
        modal();
      }
      else{
        if(!mounted) return;
        Navigator.push(
            context,
            MaterialPageRoute(
                builder: (context) => const RegisterStepTwoScreen()
            )
        );
      }

      setState(() { launch = false; });
    }
  }

  @override
  initState() {
    super.initState();
    uid = widget.uid;
    sigInMethod = widget.siginMethod;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
        body: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
                child: Center(
                  child: SingleChildScrollView(
                      padding: const EdgeInsets.all(15),
                      child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                                'Etape 1',
                                style: GoogleFonts.quicksand(
                                    textStyle: const TextStyle(
                                        fontSize: 30,
                                        color: Color(0xff0b65c2),
                                        fontWeight: FontWeight.bold
                                    )
                                )
                            ),
                            Text(
                                'Veuillez remplir les informations ci-dessous',
                                style: GoogleFonts.rubik(
                                    textStyle: const TextStyle(
                                        fontSize: 16,
                                        color: Colors.grey
                                    )
                                )
                            ),
                            const SizedBox(height: 20),
                            Form(
                              key: _registerFormKey,
                              child: Column(
                                children: [
                                  TextFormField(
                                      controller: firstNameController,
                                      style: GoogleFonts.rubik(),
                                      cursorColor: Colors.black,
                                      decoration: const InputDecoration(
                                          labelText: "Nom *",
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
                                  const SizedBox(height: 10),
                                  TextFormField(
                                      controller: lastNameController,
                                      style: GoogleFonts.rubik(),
                                      cursorColor: Colors.black,
                                      decoration: const InputDecoration(
                                          labelText: "Prénoms *",
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
                                  const SizedBox(height: 10),
                                  TextFormField(
                                      controller: pseudoController,
                                      style: GoogleFonts.rubik(),
                                      cursorColor: Colors.black,
                                      decoration: const InputDecoration(
                                          labelText: "Pseudo *",
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
                                  const SizedBox(height: 10),
                                  TextFormField(
                                      controller: numberController,
                                      style: GoogleFonts.rubik(),
                                      cursorColor: Colors.black,
                                      keyboardType: TextInputType.phone,
                                      decoration: const InputDecoration(
                                          labelText: "Numéro *",
                                          labelStyle: TextStyle(
                                              fontSize: 13,
                                              color: Colors.grey
                                          ),
                                          focusedBorder: OutlineInputBorder(
                                            borderSide: BorderSide(color: Colors.grey)
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
                                  const SizedBox(height: 10),
                                  TextFormField(
                                      controller: birthdayController,
                                      style: GoogleFonts.rubik(),
                                      cursorColor: Colors.black,
                                      decoration: const InputDecoration(
                                          labelText: "Date de naissance *",
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
                                  const SizedBox(height: 10),
                                  TextFormField(
                                      controller: establishmentController,
                                      style: GoogleFonts.rubik(),
                                      cursorColor: Colors.black,
                                      decoration: const InputDecoration(
                                          labelText: "Etablissement *",
                                          labelStyle: TextStyle(
                                              fontSize: 13,
                                              color: Colors.grey
                                          ),
                                          focusedBorder: OutlineInputBorder(
                                            borderSide: BorderSide(color: Colors.grey)
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
                                  const SizedBox(height: 10),
                                  DropdownButtonFormField(
                                      value: gender,
                                      isExpanded: true,
                                      style: GoogleFonts.rubik(
                                          textStyle: const TextStyle(
                                              fontSize: 13,
                                              color: Colors.black
                                          )
                                      ),
                                      iconSize: 30,
                                      decoration: InputDecoration(
                                        contentPadding: const EdgeInsets.all(14),
                                          labelText: "Genre *",
                                          labelStyle: GoogleFonts.rubik(
                                              textStyle: const TextStyle(
                                                  fontSize: 13,
                                                  color: Colors.grey
                                              )
                                          ),
                                          focusedBorder: const OutlineInputBorder(
                                            borderSide: BorderSide(color: Colors.grey)
                                          ),
                                          border: const OutlineInputBorder()
                                      ),
                                      iconEnabledColor: const Color(0xff0e1b42),
                                      icon: const Icon(Icons.keyboard_arrow_down),
                                      items: items.map((String items) {
                                        return DropdownMenuItem(
                                            value: items,
                                            child: Text(items)
                                        );
                                      }).toList(),
                                      onChanged: (String? newValue) {
                                        setState(() {
                                          gender = newValue!;
                                        }
                                        );
                                      },
                                      validator: (value) {
                                        if (value == null || value.isEmpty || value == "Choisissez votre genre") {
                                          return 'Ce champ est obligatoire';
                                        }
                                        return null;
                                      }
                                  ),
                                  const SizedBox(height: 10),
                                  DropdownButtonFormField(
                                      value: country,
                                      isExpanded: true,
                                      style: GoogleFonts.rubik(
                                          textStyle: const TextStyle(
                                              fontSize: 13,
                                              color: Colors.black
                                          )
                                      ),
                                      iconSize: 30,
                                      decoration: InputDecoration(
                                          contentPadding: const EdgeInsets.all(14),
                                          labelText: "Pays *",
                                          labelStyle: GoogleFonts.rubik(
                                              textStyle: const TextStyle(
                                                  fontSize: 13,
                                                  color: Colors.grey
                                              )
                                          ),
                                          focusedBorder: const OutlineInputBorder(
                                            borderSide: BorderSide(color: Colors.grey),
                                          ),
                                          border: const OutlineInputBorder()
                                      ),
                                      iconEnabledColor: const Color(0xff0e1b42),
                                      icon: const Icon(Icons.keyboard_arrow_down),
                                      items: countryItems.map((String item) {
                                        return DropdownMenuItem(
                                            value: item,
                                            child: Text(item)
                                        );
                                      }).toList(),
                                      onChanged: (String? newValue) {
                                        setState(() {
                                          country = newValue!;
                                        }
                                        );
                                      },
                                      validator: (value) {
                                        if (value == null || value.isEmpty || value == "Choisissez votre pays") {
                                          return 'Ce champ est obligatoire';
                                        }
                                        return null;
                                      }
                                  )
                                ]
                              )
                            )
                          ]
                      )
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
                        onPressed: !launch ? getStepTwo : null,
                        child: !launch ?
                        Text(
                            "Etape suivante",
                            style: GoogleFonts.rubik(
                                fontSize: 16,
                                color: Colors.white,
                                fontWeight: FontWeight.w500
                            )
                        ) :
                        const CircularProgressIndicator()
                    )
                )
            )
          ]
        )
    );
  }
}