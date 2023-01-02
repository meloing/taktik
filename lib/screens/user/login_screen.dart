import '../other/nav_screen.dart';
import 'forgot_password_screen.dart';
import 'package:flutter/material.dart';
import '../../services/local_data.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:totale_reussite/services/user_api.dart';
import 'package:flutter_facebook_auth/flutter_facebook_auth.dart';
import 'package:totale_reussite/screens/user/register/mail_verification_screen.dart';
import 'package:totale_reussite/screens/user/register/register_step_one_screen.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => LoginScreenState();
}

class LoginScreenState extends State<LoginScreen> {
  String info = "";
  bool launch = false;
  bool obscureText = false;
  bool launchDirect = false;
  bool launchGoogle = false;
  bool launchFacebook = false;
  final _registerFormKey = GlobalKey<FormState>();
  final FirebaseAuth _auth = FirebaseAuth.instance;
  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();

  Future<void> facebookSignIn() async {
    setState(() { launchFacebook = launch = true; });
    final LoginResult loginResult = await FacebookAuth.instance.login();
    if(loginResult.status == LoginStatus.success) {

      final OAuthCredential facebookAuthCredential = FacebookAuthProvider.credential(
          loginResult.accessToken!.token
      );

      UserCredential result = await _auth.signInWithCredential(facebookAuthCredential);
      User? user = result.user;

      if(user != null){
        List u = await UserOnlineRequests().getUserById(user.uid);
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

    setState(() {
      launchFacebook = launch = false;
    });
  }

  Future<void> googleSignIn() async {
    setState(() { launchGoogle = launch = true; });

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
        List u = await UserOnlineRequests().getUserById(user.uid);
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

    setState(() { launchGoogle = launch = false; });
  }

  Future<void> emailPasswordSignIn() async{
    if(_registerFormKey.currentState!.validate()){
      setState(() {
        launchDirect = launch = true;
      });
      try {
        UserCredential userCredential = await FirebaseAuth.instance
            .signInWithEmailAndPassword(
            email: emailController.text,
            password: passwordController.text
        );

        User? user = userCredential.user;
        if (user != null) {
          List u = await UserOnlineRequests().getUserById(user.uid);
          if (!mounted) return;

          if (u.isEmpty) {
            Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) =>
                        RegisterStepOneScreen(
                            uid: user.uid,
                            siginMethod: "emailPassword"
                        )
                )
            );
          }
          else {
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
        if (e.code == 'user-not-found') {
          Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (context) =>
                      MailVerificationScreen(
                          email: emailController.text,
                          password: passwordController.text
                      )
              )
          );
        }
        else if (e.code == 'wrong-password') {
          setState(() {
            info = "Mot de passe incorrect";
          });
        }
      }

      setState(() {
        launchDirect = launch = false;
      });
    }
  }

  @override
  initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Colors.white,
        body: Center(
          child: SingleChildScrollView(
              padding: const EdgeInsets.all(20),
              child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Image.asset(
                        "assets/images/taktik_logo.jpeg",
                        width: 150
                    ),
                    const SizedBox(height: 60),
                    Container(
                        height: 50,
                        width: double.infinity,
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(5),
                            gradient: const LinearGradient(
                                colors: [
                                  Color(0xff5b86e5),
                                  Color(0xff36d1dc)
                                ],
                                begin: FractionalOffset(1, 0),
                                end: FractionalOffset(0, 1),
                                stops: [0.0, 1.0],
                                tileMode: TileMode.clamp
                            )
                        ),
                        child: TextButton(
                            style: ButtonStyle(
                                shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                                    RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(5)
                                    )
                                )
                            ),
                            onPressed: !launch ? googleSignIn : null,
                            child: Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  const Icon(
                                    Icons.mail_rounded,
                                    color: Colors.white,
                                  ),
                                  Expanded(
                                      child: Text(
                                          "Se connecter / s'inscrire avec Google",
                                          textAlign: TextAlign.center,
                                          style: GoogleFonts.rubik(
                                              color: Colors.white
                                          )
                                      )
                                  ),
                                  !launchGoogle ?
                                  const Icon(
                                      Icons.arrow_forward_rounded
                                  ) :
                                  const SizedBox(
                                      width: 15,
                                      height: 15,
                                      child: CircularProgressIndicator(
                                          color: Colors.white
                                      )
                                  )
                                ]
                            )
                        )
                    ),
                    const SizedBox(height: 5),
                    SizedBox(
                        height: 50,
                        width: double.infinity,
                        child: TextButton(
                            style: ButtonStyle(
                                backgroundColor: MaterialStateProperty.all<Color>(const Color(0xff3c5a99)),
                                shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                                    RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(5)
                                    )
                                )
                            ),
                            onPressed: !launch ? facebookSignIn : null,
                            child: Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  const Icon(
                                    Icons.facebook,
                                    color: Colors.white,
                                  ),
                                  Expanded(
                                      child: Text(
                                          "Se connecter / s'inscrire avec Facebook",
                                          textAlign: TextAlign.center,
                                          style: GoogleFonts.rubik(
                                              color: Colors.white
                                          )
                                      )
                                  ),
                                  !launchFacebook ?
                                  const Icon(
                                      Icons.arrow_forward_rounded
                                  ) :
                                  const SizedBox(
                                      width: 15,
                                      height: 15,
                                      child: CircularProgressIndicator(
                                          color: Colors.white
                                      )
                                  )
                                ]
                            )
                        )
                    ),
                    const SizedBox(height: 25),
                    Row(
                        children: [
                          const Expanded(
                              child: Divider(
                                  color: Colors.black
                              )
                          ),
                          Text(
                              "  Ou  ",
                              style: GoogleFonts.rubik(
                                  fontSize: 20
                              )
                          ),
                          const Expanded(
                              child: Divider(
                                  color: Colors.black
                              )
                          )
                        ]
                    ),
                    const SizedBox(height: 25),
                    Form(
                        key: _registerFormKey,
                        child: Column(
                            children: [
                              TextFormField(
                                  controller: emailController,
                                  style: GoogleFonts.rubik(),
                                  cursorColor: Colors.black,
                                  decoration: const InputDecoration(
                                      labelText: "Email *",
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
                                  obscureText: obscureText,
                                  cursorColor: Colors.black,
                                  controller: passwordController,
                                  decoration: InputDecoration(
                                      labelText: "password *",
                                      labelStyle: const TextStyle(
                                          fontSize: 13,
                                          color: Colors.grey
                                      ),
                                      focusedBorder: const OutlineInputBorder(
                                        borderSide: BorderSide(color: Colors.grey),
                                      ),
                                      border: const OutlineInputBorder(),
                                      suffixIconColor: Colors.black,
                                      suffixIcon: IconButton(
                                          onPressed: (){
                                            setState(() {
                                              if(obscureText){
                                                obscureText = false;
                                              }
                                              else{
                                                obscureText = true;
                                              }
                                            });
                                          },
                                          icon: const Icon(
                                              Icons.remove_red_eye_rounded,
                                              color: Colors.black
                                          )
                                      )
                                  ),
                                  validator: (value) {
                                    if(value == null || value.isEmpty) {
                                      return 'Ce champ est obligatoire';
                                    }
                                    else if(value.length < 6){
                                      return 'Au minimum 6 caractères';
                                    }
                                    return null;
                                  }
                              )
                            ]
                        )
                    ),
                    Visibility(
                        visible: info.isNotEmpty,
                        child: Align(
                          alignment: Alignment.centerLeft,
                          child: Padding(
                              padding: const EdgeInsets.only(top: 10),
                              child: Text(
                                  info,
                                  style: GoogleFonts.rubik(
                                      color: Colors.red
                                  )
                              )
                          )
                        )
                    ),
                    const SizedBox(height: 5),
                    Align(
                        alignment: Alignment.center,
                        child: TextButton(
                            onPressed: (){
                              Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) => const ForgotPasswordScreen()
                                  )
                              );
                            },
                            child: Text(
                                "Mot de passe oublié ?",
                                style: GoogleFonts.rubik(
                                    color: Colors.grey
                                )
                            )
                        )
                    ),
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
                            onPressed: !launch ? emailPasswordSignIn : null,
                            child: Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Expanded(
                                      child: Text(
                                          "Se connecter / s'inscrire directement",
                                          textAlign: TextAlign.center,
                                          style: GoogleFonts.rubik(
                                              color: Colors.white
                                          )
                                      )
                                  ),
                                  !launchDirect ?
                                  const Icon(
                                      Icons.arrow_forward_rounded
                                  ) :
                                  const SizedBox(
                                      width: 15,
                                      height: 15,
                                      child: CircularProgressIndicator(
                                          color: Colors.white
                                      )
                                  )
                                ]
                            )
                        )
                    )
                  ]
              )
          )
        )
    );
  }
}