import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class QuizzAnswersScreen extends StatefulWidget {
  const QuizzAnswersScreen({
    Key? key,
    required this.add,
    required this.score,
    required this.minus,
    // required this.boiloId,
    // required this.prepaId,
    required this.nbreBneReponses,
    required this.nbreMseReponses,
    required this.nbreSansReponses,
    required this.questionsResponses
  }) : super(key: key);

  final int add;
  final int minus;
  final int score;
  // final String boiloId;
  // final String prepaId;
  final int nbreBneReponses;
  final int nbreMseReponses;
  final int nbreSansReponses;
  final int questionsResponses;

  @override
  _QuizzAnswersScreenState createState() => _QuizzAnswersScreenState();
}

class _QuizzAnswersScreenState extends State<QuizzAnswersScreen> {

  int add = 0;
  var rang = 0;
  int score = 0;
  int minus = 0;
  String boiloId = "";
  String prepaId = "";
  int nbreBneReponses = 0;
  int nbreMseReponses = 0;
  int nbreSansReponses = 0;
  int questionsResponses = 0;
  String otherResultsValues = "";

  Widget otherResultsRender(){
    List values = otherResultsValues.split("||");
    return Column(
        children: values.asMap().entries.map(
              (item) => Column(
              children: [
                ListTile(
                    leading: CircleAvatar(
                      radius: 30,
                      child: Text(
                        item.value.split(";")[0][0].toUpperCase(),
                        style: const TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                    subtitle: Text(
                      item.value.split(";")[1],
                      style: const TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    title: Text(
                      item.value.split(";")[0],
                      style: const TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    trailing: CircleAvatar(
                        backgroundColor: Colors.grey,
                        child: Text(
                            (item.key+1).toString(),
                            style: const TextStyle(
                                fontSize: 18,
                                color: Colors.black,
                                fontWeight: FontWeight.bold
                            )
                        )
                    )
                ),
                const Divider()
              ]
          ),
        ).toList()
    );
  }

  @override
  initState() {
    super.initState();
    add = widget.add;
    minus = widget.minus;
    score = widget.score;
    // boiloId = widget.boiloId;
    // prepaId = widget.prepaId;
    nbreBneReponses = widget.nbreBneReponses;
    nbreMseReponses = widget.nbreMseReponses;
    nbreSansReponses = widget.nbreSansReponses;
    questionsResponses = widget.questionsResponses;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        centerTitle: true,
        title: Text(
            "RESULTATS DU QUIZZ",
            style: GoogleFonts.rubik(
                textStyle: const TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold
                )
            )
        )
      ),
      body: Container(
          color: Colors.white,
          width: double.infinity,
          padding: const EdgeInsets.all(10),
          child: Column(
              children: [
                Expanded(
                    child: SingleChildScrollView(
                        child: Column(
                            children: [
                              Container(
                                  width: 150,
                                  height: 150,
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(100),
                                    color: const Color(0xff1f71ba),
                                  ),
                                  child: Center(
                                      child: Text(
                                        "$score / ${questionsResponses*minus}",
                                        textAlign: TextAlign.center,
                                        style: const TextStyle(
                                            fontSize: 25,
                                            color: Colors.white,
                                            fontWeight: FontWeight.bold
                                        ),
                                      )
                                  )
                              ),
                              const SizedBox(height: 30),
                              Card(
                                child: Container(
                                    decoration: BoxDecoration(
                                        border: Border.all(color: Colors.grey[200]!),
                                        borderRadius: BorderRadius.circular(5)
                                    ),
                                    child: Table(
                                        border: TableBorder.symmetric(
                                            outside: BorderSide.none,
                                            inside: BorderSide(color: Colors.grey[200]!)
                                        ),
                                        children: [
                                          TableRow(
                                              children: [
                                                Padding(
                                                    padding: const EdgeInsets.all(15),
                                                    child: Text(
                                                        "Nombre de questions",
                                                        style: GoogleFonts.rubik(
                                                            textStyle: const TextStyle(
                                                                color: Colors.black
                                                            )
                                                        )
                                                    )
                                                ),
                                                Padding(
                                                    padding: const EdgeInsets.all(15),
                                                    child: Text(
                                                        questionsResponses.toString(),
                                                        textAlign: TextAlign.center,
                                                        style: GoogleFonts.rubik(
                                                            textStyle: const TextStyle(
                                                                fontSize: 20,
                                                                color: Color(0xfff29200),
                                                                fontWeight: FontWeight.bold
                                                            )
                                                        )
                                                    )
                                                )
                                              ]
                                          ),
                                          TableRow(
                                              children: [
                                                Padding(
                                                    padding: const EdgeInsets.all(15),
                                                    child: Text(
                                                        "Nombre de bonne réponses",
                                                        style: GoogleFonts.rubik(
                                                            textStyle: const TextStyle(
                                                                color: Colors.black
                                                            )
                                                        )
                                                    )
                                                ),
                                                Padding(
                                                    padding: const EdgeInsets.all(15),
                                                    child: Text(
                                                        nbreBneReponses.toString(),
                                                        textAlign: TextAlign.center,
                                                        style: GoogleFonts.rubik(
                                                            textStyle: const TextStyle(
                                                                fontSize: 20,
                                                                color: Color(0xfff29200),
                                                                fontWeight: FontWeight.bold
                                                            )
                                                        )
                                                    )
                                                )
                                              ]
                                          ),
                                          TableRow(
                                              children: [
                                                Padding(
                                                    padding: EdgeInsets.all(15),
                                                    child: Text(
                                                        "Nombre de mauvaise réponses",
                                                        style: GoogleFonts.rubik(
                                                            textStyle: const TextStyle(
                                                                color: Colors.black
                                                            )
                                                        )
                                                    )
                                                ),
                                                Padding(
                                                    padding: const EdgeInsets.all(15),
                                                    child: Text(
                                                        nbreMseReponses.toString(),
                                                        textAlign: TextAlign.center,
                                                        style: GoogleFonts.rubik(
                                                            textStyle: const TextStyle(
                                                                fontSize: 20,
                                                                color: Color(0xfff29200),
                                                                fontWeight: FontWeight.bold
                                                            )
                                                        )
                                                    )
                                                )
                                              ]
                                          ),
                                          TableRow(
                                              children: [
                                                Padding(
                                                    padding: const EdgeInsets.all(15),
                                                    child: Text(
                                                        "Nombre de sans réponses",
                                                        style: GoogleFonts.rubik(
                                                            textStyle: const TextStyle(
                                                                color: Colors.black
                                                            )
                                                        )
                                                    )
                                                ),
                                                Padding(
                                                    padding: const EdgeInsets.all(15),
                                                    child: Text(
                                                        nbreSansReponses.toString(),
                                                        textAlign: TextAlign.center,
                                                        style: GoogleFonts.rubik(
                                                            textStyle: const TextStyle(
                                                                fontSize: 20,
                                                                color: Color(0xfff29200),
                                                                fontWeight: FontWeight.bold
                                                            )
                                                        )
                                                    )
                                                )
                                              ]
                                          ),
                                          TableRow(
                                              children: [
                                                Padding(
                                                    padding: const EdgeInsets.all(15),
                                                    child: Text(
                                                        "Une bonne réponse",
                                                        style: GoogleFonts.rubik(
                                                            textStyle: const TextStyle(
                                                                color: Colors.black
                                                            )
                                                        )
                                                    )
                                                ),
                                                Padding(
                                                    padding: const EdgeInsets.all(15),
                                                    child: Text(
                                                        "+ $add",
                                                        textAlign: TextAlign.center,
                                                        style: GoogleFonts.rubik(
                                                            textStyle: const TextStyle(
                                                                fontSize: 20,
                                                                color: Color(0xfff29200),
                                                                fontWeight: FontWeight.bold
                                                            )
                                                        )
                                                    )
                                                )
                                              ]
                                          ),
                                          TableRow(
                                              children: [
                                                Padding(
                                                    padding: const EdgeInsets.all(15),
                                                    child: Text(
                                                        "Une mauvaise réponse",
                                                        style: GoogleFonts.rubik(
                                                            textStyle: const TextStyle(
                                                                color: Colors.black
                                                            )
                                                        )
                                                    )
                                                ),
                                                Padding(
                                                    padding: const EdgeInsets.all(15),
                                                    child: Text(
                                                        "- $minus",
                                                        textAlign: TextAlign.center,
                                                        style: GoogleFonts.rubik(
                                                            textStyle: const TextStyle(
                                                                fontSize: 20,
                                                                color: Color(0xfff29200),
                                                                fontWeight: FontWeight.bold
                                                            )
                                                        )
                                                    )
                                                )
                                              ]
                                          )
                                        ]
                                    )
                                )
                              )
                            ]
                        )
                    )
                ),
                SizedBox(
                  height: 45,
                  width: double.infinity,
                  child: TextButton(
                      style: ButtonStyle(
                          backgroundColor: MaterialStateProperty.all<Color>(const Color(0xfff29200)),
                          shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                              RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(10)
                              )
                          )
                      ),
                      onPressed: (){
                        Navigator.pop(context);
                      },
                      child: const Text(
                          "Fermer",
                          style: TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.bold
                          )
                      )
                  )
                )
              ]
          )
      ),
    );
  }
}