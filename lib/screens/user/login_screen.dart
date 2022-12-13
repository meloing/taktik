import 'package:totale_reussite/screens/user/register/mail_verification_screen.dart';

import '../../services/local_data.dart';
import '../other/nav_screen.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:totale_reussite/services/api.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:flutter_facebook_auth/flutter_facebook_auth.dart';
import 'package:totale_reussite/screens/user/register/register_step_one_screen.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => LoginScreenState();
}

class LoginScreenState extends State<LoginScreen> {
  String info = "";
  bool launch = false;
  bool _checking = true;
  AccessToken? _accessToken;
  Map<String, dynamic>? _userData;
  final FirebaseAuth _auth = FirebaseAuth.instance;
  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();

  Future<void> facebookSignIn() async {
    setState(() { launch = true; });
    final LoginResult loginResult = await FacebookAuth.instance.login();
    if(loginResult.status == LoginStatus.success) {

      // Create a credential from the access token
      final OAuthCredential facebookAuthCredential = FacebookAuthProvider.credential(
          loginResult.accessToken!.token
      );

      UserCredential result = await _auth.signInWithCredential(facebookAuthCredential);
      User? user = result.user;

      if(user != null){
        List u = await ManageDatabase().getUserById(user.uid);
        if(!mounted) return;

        if(u.isEmpty){
          Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (context) => RegisterStepOneScreen(
                      uid: user.uid,
                      siginMethod: "facebook"
                  )
              )
          );
        }
        else{
          LocalData().setLoginInfo(u[0]);
          Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (context) => const NavScreen()
              )
          );
        }
      }
    }
    else{
      print(loginResult.status);
      print(loginResult.message);
    }

    setState(() {
      launch = false;
      _checking = false;
    });
  }

  Future<void> googleSignIn() async {
    setState(() { launch = true; });

    final GoogleSignIn googleSignIn = GoogleSignIn();
    final GoogleSignInAccount? googleSignInAccount = await googleSignIn.signIn();
    if(googleSignInAccount != null){
      final GoogleSignInAuthentication googleSignInAuthentication = await googleSignInAccount.authentication;
      final AuthCredential authCredential = GoogleAuthProvider.credential(
            idToken: googleSignInAuthentication.idToken,
            accessToken: googleSignInAuthentication.accessToken
      );

      UserCredential result = await _auth.signInWithCredential(authCredential);
      User? user = result.user;

      if(user != null){
        List u = await ManageDatabase().getUserById(user.uid);
        if(!mounted) return;

        if(u.isEmpty){
          Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (context) => RegisterStepOneScreen(
                      uid: user.uid,
                      siginMethod: "google"
                  )
              )
          );
        }
        else{
          LocalData().setLoginInfo(u[0]);
          Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (context) => const NavScreen()
              )
          );
        }
      }
    }

    setState(() { launch = false; });
  }

  Future<void> emailPasswordSignIn() async{
    setState(() { launch = true; });

    try{
      UserCredential userCredential = await FirebaseAuth.instance.signInWithEmailAndPassword(
          email: emailController.text,
          password: passwordController.text
      );

      User? user = userCredential.user;
      if(user != null){
        List u = await ManageDatabase().getUserById(user.uid);
        if(!mounted) return;

        if(u.isEmpty){
          Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (context) => RegisterStepOneScreen(
                      uid: user.uid,
                      siginMethod: "emailPassword"
                  )
              )
          );
        }
        else{
          LocalData().setLoginInfo(u[0]);
          Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (context) => const NavScreen()
              )
          );
        }
      }

    }
    on FirebaseAuthException catch (e) {
      if(e.code == 'user-not-found'){
        Navigator.push(
            context,
            MaterialPageRoute(
                builder: (context) => MailVerificationScreen(
                    email: emailController.text,
                    password: passwordController.text
                )
            )
        );
      }
      else if(e.code == 'wrong-password'){
        setState(() {
          info = "Mot de passe incorrect";
        });
      }
    }

    setState(() { launch = false; });
  }

  @override
  initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Padding(
            padding: const EdgeInsets.all(20),
            child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Expanded(
                    child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          SizedBox(
                            height: 50,
                            width: double.infinity,
                            child: TextButton(
                                style: ButtonStyle(
                                    backgroundColor: MaterialStateProperty.all<Color>(Colors.red),
                                    shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                                        RoundedRectangleBorder(
                                          borderRadius: BorderRadius.circular(5)
                                        )
                                    )
                                ),
                                onPressed: !launch ? googleSignIn : null,
                                child: !launch ?
                                Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      const Icon(
                                        Icons.mail_rounded,
                                        color: Colors.white,
                                      ),
                                      Expanded(
                                        child: Text(
                                            "Se connecter ou s'inscrire avec google",
                                            textAlign: TextAlign.center,
                                            style: GoogleFonts.rubik(
                                                color: Colors.white
                                            )
                                        )
                                      )
                                    ]
                                ):
                                const CircularProgressIndicator(
                                  color: Colors.white
                                )
                            )
                          ),
                          const SizedBox(height: 5),
                          SizedBox(
                              height: 50,
                              width: double.infinity,
                              child: TextButton(
                                style: ButtonStyle(
                                    backgroundColor: MaterialStateProperty.all<Color>(Colors.blue),
                                    shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                                        RoundedRectangleBorder(
                                          borderRadius: BorderRadius.circular(5)
                                        )
                                    )
                                ),
                                onPressed: !launch ? facebookSignIn : null,
                                child: !launch ?
                                Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      const Icon(
                                        Icons.facebook,
                                        color: Colors.white,
                                      ),
                                      Expanded(
                                        child: Text(
                                            "Se connecter ou s'inscrire avec Facebook",
                                            textAlign: TextAlign.center,
                                            style: GoogleFonts.rubik(
                                                color: Colors.white
                                            )
                                        )
                                      )
                                    ]
                                ) :
                                const CircularProgressIndicator(
                                    color: Colors.white
                                )
                            )
                          ),
                          const SizedBox(height: 5)
                        ]
                    )
                  ),
                  TextFormField(
                      controller: emailController,
                      style: GoogleFonts.rubik(),
                      decoration: const InputDecoration(
                          labelText: "Email *",
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
                      controller: passwordController,
                      decoration: const InputDecoration(
                          labelText: "password *",
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
                  Text(
                      info,
                      style: GoogleFonts.rubik(
                        color: Colors.red
                      )
                  ),
                  const SizedBox(height: 10),
                  SizedBox(
                      height: 50,
                      width: double.infinity,
                      child: TextButton(
                          style: ButtonStyle(
                              backgroundColor: MaterialStateProperty.all<Color>(Colors.orange),
                              shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                                  RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(5),
                                  )
                              )
                          ),
                          onPressed: ()async{
                            emailPasswordSignIn();
                          },
                          child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                const Icon(
                                  Icons.add_rounded,
                                  color: Colors.white,
                                ),
                                Expanded(
                                    child: Text(
                                        "Se connecter ou s'inscrire directement",
                                        textAlign: TextAlign.center,
                                        style: GoogleFonts.rubik(
                                            color: Colors.white
                                        )
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