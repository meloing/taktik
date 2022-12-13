import 'package:flutter/material.dart';
import '../../../services/local_data.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:totale_reussite/screens/user/register/register_step_two_screen.dart';

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
  String siginMethod = "";
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

  @override
  initState() {
    super.initState();
    uid = widget.uid;
    siginMethod = widget.siginMethod;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Column(
          children: [
            Expanded(
                child: Center(
                  child: SingleChildScrollView(
                      padding: const EdgeInsets.all(15),
                      child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            const SizedBox(height: 20),
                            Text(
                                'Etape 1',
                                style: GoogleFonts.quicksand(
                                    textStyle: const TextStyle(
                                        fontSize: 30,
                                        color: Colors.blue,
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
                                      decoration: const InputDecoration(
                                          labelText: "Nom *",
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
                                  const SizedBox(height: 10),
                                  TextFormField(
                                      controller: lastNameController,
                                      decoration: const InputDecoration(
                                          labelText: "Prénoms *",
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
                                  const SizedBox(height: 10),
                                  TextFormField(
                                      controller: pseudoController,
                                      decoration: const InputDecoration(
                                          labelText: "Pseudo *",
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
                                  const SizedBox(height: 10),
                                  TextFormField(
                                      controller: numberController,
                                      decoration: const InputDecoration(
                                          labelText: "Numéro *",
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
                                  const SizedBox(height: 10),
                                  TextFormField(
                                      controller: birthdayController,
                                      decoration: const InputDecoration(
                                          labelText: "Date de naissance *",
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
                                  const SizedBox(height: 10),
                                  TextFormField(
                                      controller: establishmentController,
                                      decoration: const InputDecoration(
                                          labelText: "Etablissement *",
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
                    height: 50,
                    width: double.infinity,
                    child: TextButton(
                        style: ButtonStyle(
                            backgroundColor: MaterialStateProperty.all<Color>(Colors.blue),
                            shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                                RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(10),
                                )
                            )
                        ),
                        onPressed: (){
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

                          if(_registerFormKey.currentState!.validate()){
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => const RegisterStepTwoScreen()
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