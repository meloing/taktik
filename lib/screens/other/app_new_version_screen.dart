import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class AppNewVersionScreen extends StatefulWidget {
  const AppNewVersionScreen({super.key});

  @override
  State<AppNewVersionScreen> createState() => AppNewVersionScreenState();
}

class AppNewVersionScreenState extends State<AppNewVersionScreen> {

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
                                          "assets/images/new.png",
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
                            child: Column(
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
                                  Text(
                                      'Nouvelle version',
                                      style: GoogleFonts.rubik(
                                          textStyle: const TextStyle(
                                              fontSize: 28,
                                              color: Color(0xff0b65c2),
                                              fontWeight: FontWeight.bold
                                          )
                                      )
                                  ),
                                  const SizedBox(height: 20),
                                  Text(
                                      'Une nouvelle version de notre application est disponible.'
                                          ' Cliquez sur le bouton télécharger pour mettre à niveau votre application. Cette version vient avec des mises à jour majeures  '
                                          ' qui vous aiderons à atteindre vos objectifs.',
                                      textAlign: TextAlign.justify,
                                      style: GoogleFonts.rubik(
                                          textStyle: const TextStyle(
                                              fontSize: 16,
                                              color: Color(0xff0e1b42)
                                          )
                                      )
                                  )
                                ]
                            )
                        ),
                        Padding(
                            padding: const EdgeInsets.all(10),
                            child:  SizedBox(
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
                                    onPressed: (){

                                    },
                                    child: Text(
                                        "Télécharger",
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
    WidgetsBinding.instance.addPostFrameCallback((_)async{
      modal();
    });
  }

  @override
  Widget build(BuildContext context) {

    return Scaffold(
        backgroundColor: Colors.grey[200],
        body: const Center(
          child: Text("")
        )
    );
  }
}