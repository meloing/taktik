import 'dart:async';
// import 'boilo_result_screen.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:totale_reussite/screens/quiz/quizz_answers_screen.dart';
// import 'package:prepa_reussite/services/api.dart';

class SpecificQuizzScreen extends StatefulWidget {
  const SpecificQuizzScreen({
    Key? key,
    required this.quizz,
    // required this.prepaId
  }) : super(key: key);

  final Map quizz;
  // final String prepaId;

  @override
  SpecificQuizzScreenState createState() => SpecificQuizzScreenState();
}

class SpecificQuizzScreenState extends State<SpecificQuizzScreen> {

  late Map quizz;
  int _start = 0;
  late Timer _timer;
  String prepaId = "";
  late List goodResponse;
  List userResponses = [];
  bool seeGoodResponse = false;
  late List questionsResponses;

  void startTimer() {
    const oneSec = Duration(seconds: 1);
    _timer = Timer.periodic(
      oneSec,
          (Timer timer) {
        if (_start == 0) {
          setState(() {
            timer.cancel();
            boiloResults();
          });
        } else {
          setState(() {
            _start--;
          });
        }
      },
    );
  }

  void prepareResponses(){
    // preparation de la liste de reponses

    setState(() {
      userResponses = [];
      seeGoodResponse = false;
      _start = int.parse(quizz["quizzSecond"].toString());
    });

    for(var value in questionsResponses){
      value = value.split("@@");
      var list = [for(var i=0; i<value.length; i+=1) false];
      setState(() {
        userResponses.add(list);
      });
    }

    startTimer();
  }

  Future boiloResults() async{
    int score = 0;
    int nbreBneReponses = 0;
    int nbreMseReponses = 0;
    int nbreSansReponses = 0;

    for(int i=0; i<userResponses.length; i+=1){

      bool havePoint = false;
      bool haveMinus = false;
      int nbreReponsesTrouve = 0;
      List value = userResponses[i];
      List goodResp = goodResponse[i].split("@@");

      for(int j=0; j<value.length; j+=1){

        // response true
        if(value[j]){

          // Vérification si la reponse appartient aux bonnes réponses
          bool enter = false;
          for(var index in goodResp){
            if(j == int.parse(index)){
              enter = true;
              break;
            }
          }

          if(!enter){
            // La réponse donnée n'appartient à aucune reponse, il reçoit -1
            haveMinus = true;
            break;
          }
          else{
            nbreReponsesTrouve += 1;
          }
        }
      }

      // Si le nombre de bonne reponse égale au nombre de bonne réponse
      if(!haveMinus && nbreReponsesTrouve == goodResp.length){
        havePoint = true;
      }

      // Gestion des points finaux
      if(haveMinus){
        score -= int.parse(quizz["quizzMinus"].toString());
        nbreMseReponses += 1;
      }
      else if(havePoint){
        score += int.parse(quizz["quizzAdd"].toString());
        nbreBneReponses += 1;
      }
      else{
        nbreSansReponses += 1;
      }
    }

    // Ajout de la note en local
    // await LocalPrepaRequest().addPrepaBoiloResult(boilo['prepaBoiloId'], prepaId, score);

    setState(() {
      _timer.cancel();
      seeGoodResponse = true;
      _start = quizz["quizzSecond"];
    });

    Navigator.push(
        context,
        MaterialPageRoute(builder: (context) =>
              QuizzAnswersScreen(
                  score: score,
                  // boiloId: boilo['prepaBoiloId'].toString(),
                  // prepaId: prepaId.toString(),
                  nbreBneReponses: nbreBneReponses,
                  nbreMseReponses: nbreMseReponses,
                  nbreSansReponses: nbreSansReponses,
                  add: int.parse(quizz["quizzAdd"].toString()),
                  minus: int.parse(quizz["quizzMinus"].toString()),
                  questionsResponses: questionsResponses.length
            )
        )
    );

  }

  Widget splitElement(String text, String part){
    List questions = text.split("|");
    return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: questions.map(
                (item) {
              if(item.trim().startsWith('[img]')){
                String adr = item.replaceAll("[/img]", "").replaceAll("[img]", "").trim();
                return Image(
                    image: NetworkImage("https://www.totale-reussite.com/prepa_reussite/ressources/postImages/"+adr),
                    width: 200,
                    errorBuilder: (BuildContext context, Object exception, StackTrace? stackTrace){
                      return const Center(
                          child: Padding(
                              padding: EdgeInsets.symmetric(vertical: 20),
                              child: Text(
                                  "IMPOSSIBLE DE LIRE L'IMAGE HORS LIGNE",
                                  style: TextStyle(
                                      fontWeight: FontWeight.bold
                                  )
                              )
                          )
                      );
                    }
                );
              }
              else{
                return Text(
                    "$item",
                    style: GoogleFonts.rubik(
                        textStyle: TextStyle(
                            fontSize: part == "quest" ? 18 : 16,
                            color: part == "quest" ? const Color(0xff1f71ba) : Colors.black87,
                            fontWeight: part == "quest" ? FontWeight.bold : null
                        )
                    )
                );
              }
            }
        ).toList()
    );
  }

  Widget _rep(rep, number){
    List responses = rep.split("@@");
    return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: responses.asMap().entries.map(
                (item) => Container(
              margin: const EdgeInsets.symmetric(vertical: 5),
              padding: const EdgeInsets.all(5),
              decoration: BoxDecoration(
                color: Colors.grey[200],
                borderRadius: BorderRadius.circular(15),
                border: Border.all(color: Colors.grey)
              ),
              child: Row(
                  children: [
                    Text("${(item.key+1).toString()}."),
                    Expanded(
                        child: CheckboxListTile(
                            value: userResponses[number][item.key],
                            onChanged: (bool? value) {
                              setState(() {
                                userResponses[number][item.key] = value;
                              });
                            },
                            title: splitElement(item.value, "rep")
                        )
                    )
                  ]
              ),
            )
        ).toList()
    );
  }

  Widget _body(){

    List questions = quizz["quizzQuestions"].replaceAll("\n", "").split("||");
    List responses = quizz["quizzResponses"].replaceAll("\n", "").split("||");

    return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: questions.asMap().entries.map(
                (item) {
              String b = "";
              List goResponses = goodResponse[item.key].split("@@");
              for(var a in goResponses){
                b += "${int.parse(a)+1}  ";
              }
              return Container(
                  width: double.infinity,
                  margin: const EdgeInsets.symmetric(vertical: 10),
                  padding: const EdgeInsets.symmetric(
                      vertical: 5,
                      horizontal: 20
                  ),
                  decoration: const BoxDecoration(
                      color: Colors.white
                  ),
                  child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const SizedBox(height: 5),
                        Row(
                            children: [
                              Text(
                                "${(item.key+1).toString()}. ",
                                style: const TextStyle(
                                    fontSize: 20,
                                    color: Color(0xff1f71ba),
                                    fontWeight: FontWeight.bold
                                ),
                              ),
                              Expanded(
                                  child: splitElement(item.value, "quest")
                              )
                            ]
                        ),
                        const SizedBox(height: 5),
                        _rep(responses[item.key], item.key),
                        seeGoodResponse ? Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const SizedBox(height: 5),
                            const Divider(thickness: 2),
                            Text.rich(
                                TextSpan(
                                    children: [
                                      TextSpan(
                                          text: 'Les bonnes reponses sont: ',
                                          style: GoogleFonts.rubik()
                                      ),
                                      TextSpan(
                                          text: b,
                                          style: GoogleFonts.rubik(
                                              textStyle: const TextStyle(
                                                  fontSize: 18,
                                                  color: Colors.red,
                                                  fontWeight: FontWeight.bold
                                              )
                                          )
                                      )
                                    ]
                                )
                            ),
                            const SizedBox(height: 5)
                          ],
                        ) : const SizedBox()
                      ]
                  )
              );
            }
        ).toList()
    );
  }

  @override
  initState() {
    super.initState();
    quizz = widget.quizz;
    // prepaId = widget.prepaId;
    goodResponse = quizz["quizzGoodResponse"].split("||");
    questionsResponses = quizz["quizzResponses"].split("||");
    prepareResponses();
  }

  @override
  void dispose() {
    _timer.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
            elevation: 0,
            centerTitle: true,
            title: Text(
                quizz["quizzTitle"].toUpperCase(),
                style: GoogleFonts.rubik(
                    textStyle: const TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold
                    )
                )
            )
        ),
        backgroundColor: Colors.grey[200],
        body: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                  padding: const EdgeInsets.all(10),
                  child: Center(
                      child: Text(
                          "$_start s",
                          textAlign: TextAlign.center,
                          style: const TextStyle(
                              fontSize: 26,
                              fontWeight: FontWeight.bold
                          )
                      )
                  )
              ),
              Expanded(
                  child: SingleChildScrollView(
                      child: Column(
                          children: [
                            const SizedBox(height: 5),
                            Container(
                                padding: const EdgeInsets.only(
                                    top: 10,
                                    bottom: 15,
                                    left: 5,
                                    right: 5
                                ),
                                width: double.infinity,
                                decoration: const BoxDecoration(
                                    color: Colors.white
                                ),
                                child: Text(
                                    quizz["quizzConsigne"].toString(),
                                    textAlign: TextAlign.center,
                                    style: GoogleFonts.rubik(
                                        textStyle: const TextStyle(
                                            fontSize: 18,
                                            color: Colors.red
                                        )
                                    )
                                )
                            ),
                            _body()
                          ]
                      )
                  )
              ),
              Padding(
                  padding: const EdgeInsets.all(10),
                  child: SizedBox(
                      height: 45,
                      width: double.infinity,
                      child: TextButton(
                          style: ButtonStyle(
                              backgroundColor: MaterialStateProperty.all<Color>(
                                  !seeGoodResponse ? const Color(0xff1f71ba) :
                                  const Color(0xfff29200)
                              ),
                              shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                                  RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(10)
                                  )
                              )
                          ),
                          onPressed: !seeGoodResponse ? boiloResults : prepareResponses,
                          child: Text(
                              !seeGoodResponse ? "Valider" : "Reprendre",
                              style: const TextStyle(
                                  color: Colors.white,
                                  fontWeight: FontWeight.bold
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
