import 'dart:math';
import 'dart:async';
import '../../../services/api.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:pin_code_fields/pin_code_fields.dart';
import 'package:totale_reussite/screens/user/register/register_step_one_screen.dart';

class MailVerificationScreen extends StatefulWidget {
  const MailVerificationScreen({
    super.key,
    required this.email,
    required this.password
  });

  final String email;
  final String password;

  @override
  State<MailVerificationScreen> createState() => MailVerificationScreenState();
}

class MailVerificationScreenState extends State<MailVerificationScreen> {
  int _start = 30;
  String code = "";
  String info = "";
  String email = "";
  late Timer _timer;
  String password = "";
  bool hasError = false;
  String currentText = "";
  bool launchVerifyCode = false;
  bool seeButtonResendCode = false;
  final formKey = GlobalKey<FormState>();
  final FirebaseAuth _auth = FirebaseAuth.instance;
  StreamController<ErrorAnimationType>? errorController;
  TextEditingController textEditingController = TextEditingController();

  String generateCode() {
    String value = "";
    var rng = Random();
    for(var i = 0; i < 6; i++) {
      value += rng.nextInt(10).toString();
    }

    return value;
  }

  void startTimer() {
    const oneSec = Duration(seconds: 1);
    _timer = Timer.periodic(
        oneSec, (Timer timer) {
      if(_start == 0) {
        setState(() {
          timer.cancel();
          _start = 30;
          seeButtonResendCode = true;
        });
      } else {
        setState(() {
          _start--;
        });
      }
    }
    );
  }

  Future resendCode() async{
    code = generateCode();
    await LocalDatabase().sendCode(email, code);
  }

  Future verifyCode() async{
    formKey.currentState!.validate();
    if(currentText.length != 6 || currentText != code) {
      errorController!.add(ErrorAnimationType.shake);
      setState(() => hasError = true);
    }
    else{
      setState(() { hasError = false; });
      await emailPasswordSignIn();
    }
  }

  Future<void> emailPasswordSignIn() async{

    try{
      final credential = await FirebaseAuth.instance.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );

      String uid = credential.user?.uid ?? "";

      if(!mounted) return ;
      Navigator.of(context).push(
            MaterialPageRoute(builder: (context) => RegisterStepOneScreen(
                uid: uid,
                siginMethod: "emailPassword"
            )
          )
      );
    }
    on FirebaseAuthException catch (_) {}
    catch (_) { }
  }

  @override
  void dispose() {
    _timer.cancel();
    errorController!.close();
    super.dispose();
  }

  @override
  void initState(){
    super.initState();
    email = widget.email;
    password = widget.password;
    errorController = StreamController<ErrorAnimationType>();
    resendCode();
    startTimer();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Colors.white,
        body: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 30),
              IconButton(
                  onPressed: (){
                    Navigator.pop(context);
                  },
                  icon: const Icon(
                      Icons.arrow_back_ios_new_rounded
                  )
              ),
              Expanded(
                  child: Center(
                      child: SingleChildScrollView(
                          padding: const EdgeInsets.all(24),
                          child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: <Widget>[
                                Text(
                                    'Verification de email',
                                    style: GoogleFonts.quicksand(
                                        textStyle: const TextStyle(
                                            fontSize: 28,
                                            fontWeight: FontWeight.bold
                                        )
                                    )
                                ),
                                const SizedBox(height: 9),
                                Text(
                                    'Entrer les 6 chiffres envoyés à $email',
                                    style: GoogleFonts.rubik(
                                        textStyle: const TextStyle(
                                            fontSize: 16,
                                            color: Colors.grey
                                        )
                                    )
                                ),
                                const SizedBox(height: 50),
                                Form(
                                    key: formKey,
                                    child: PinCodeTextField(
                                        appContext: context,
                                        pastedTextStyle: const TextStyle(
                                          color: Colors.white,
                                          fontWeight: FontWeight.bold,
                                        ),
                                        length: 6,
                                        blinkWhenObscuring: true,
                                        backgroundColor: Colors.white,
                                        animationType: AnimationType.fade,
                                        pinTheme: PinTheme(
                                          shape: PinCodeFieldShape.box,
                                          borderRadius: BorderRadius.circular(5),
                                          fieldHeight: 45,
                                          fieldWidth: 45,
                                          activeFillColor: Colors.white,
                                        ),
                                        cursorColor: Colors.black,
                                        animationDuration: const Duration(milliseconds: 300),
                                        enableActiveFill: true,
                                        errorAnimationController: errorController,
                                        controller: textEditingController,
                                        keyboardType: TextInputType.number,
                                        boxShadows: const [
                                          BoxShadow(
                                            offset: Offset(0, 1),
                                            color: Colors.black12,
                                            blurRadius: 10,
                                          )
                                        ],
                                        onCompleted: (v) {

                                        },
                                        onChanged: (value) {
                                          setState(() {
                                            currentText = value;
                                          });
                                        }
                                    )
                                ),
                                Text(
                                    info,
                                    style: GoogleFonts.rubik(
                                        fontSize: 14,
                                        color: Colors.red
                                    )
                                ),
                                const SizedBox(height: 70),
                                !seeButtonResendCode ?
                                Text(
                                    "Resend code in 00:$_start",
                                    style: const TextStyle(
                                        fontSize: 15,
                                        color: Color(0xff0e1b42),
                                        fontWeight: FontWeight.w500
                                    )
                                ) :
                                TextButton(
                                    onPressed: resendCode,
                                    child: const Text("Renvoyer le code")
                                )
                              ]
                          )
                      )
                  )
              ),
              Padding(
                  padding: const EdgeInsets.all(24),
                  child: SizedBox(
                      height: 56,
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
                          onPressed: verifyCode,
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
