import 'package:flutter/material.dart';
import 'package:flutter_parsed_text/flutter_parsed_text.dart';

class QuizzScreen extends StatefulWidget {
  const QuizzScreen({
    Key? key,
    // required this.prepaId,
    // required this.prepaCode
  }) : super(key: key);

  // final String prepaId;
  // final String prepaCode;

  @override
  QuizzScreenState createState() => QuizzScreenState();
}

class QuizzScreenState extends State<QuizzScreen> {

  int number = 0;
  int offset = 0;
  late String prepaId;
  int boilosLength = 0;
  late String prepaCode;
  final List boilos = [];
  bool firstLaunch = true;
  String infoConnexion = "";
  bool hideSeeMoreButtonBoilo = true;
  TextEditingController searchController = TextEditingController();

  @override
  initState() {
    super.initState();
    // prepaId = widget.prepaId;
    // prepaCode = widget.prepaCode;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: const Color(0xFFFBFBFD),
        appBar: AppBar(
            elevation: 1,
            iconTheme: const IconThemeData(
                color: Colors.black
            ),
            title: const Text(
                "Quizz",
                style: TextStyle(
                    color: Colors.black,
                    fontWeight: FontWeight.bold
                )
            ),
            backgroundColor: Colors.white
        ),
        body: RefreshIndicator(
            child: Column(
                children: [
                  const SizedBox(height: 10),
                  Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 13),
                      child: TextField(
                        controller: searchController,
                        decoration: const InputDecoration(
                            enabledBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.all(Radius.circular(40)),
                              borderSide: BorderSide.none,
                            ),
                            focusedBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.all(Radius.circular(40)),
                              borderSide: BorderSide.none,
                            ),
                            hintText: "Rechercher un quizz",
                            hintStyle: TextStyle(
                                fontSize: 18.0,
                                color: Color(0xFFA0A5BD)
                            ),
                            contentPadding: EdgeInsets.all(15.0),
                            fillColor: Color(0xFFF5F5F7),
                            filled: true,
                            prefixIcon: Icon(
                                Icons.search_rounded,
                                color: Color(0xFFA0A5BD)
                            )
                        ),
                        onChanged: (value){
                          offset = 0;
                          setState(() {
                            firstLaunch = true;
                          });
                        },
                      )
                  ),
                  const Divider(thickness: 2),
                  Expanded(
                      child: firstLaunch ? Center(
                          child: Column(
                              crossAxisAlignment: CrossAxisAlignment.center,
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: const [
                                CircularProgressIndicator(),
                                SizedBox(height: 10),
                                Text("0"),
                              ]
                          )
                      ) : boilos.isEmpty ? const Center(
                          child: Text(
                              "Aucun résultat pour cette recherche",
                              style: TextStyle(
                                  fontWeight: FontWeight.bold
                              )
                          )
                      ):
                      ListView.separated(
                          itemCount: boilos.length,
                          itemBuilder: (BuildContext context,int index){
                            String text = searchController.text;
                            return Column(
                              children: [
                                Container(
                                    decoration: const BoxDecoration(
                                      color: Colors.white,
                                    ),
                                    child: ListTile(
                                      contentPadding: const EdgeInsets.symmetric(
                                          vertical: 0,
                                          horizontal: 7
                                      ),
                                      leading: Container(
                                          width: 50,
                                          height: 50,
                                          decoration: const BoxDecoration(
                                              color: Color(0xfff29200),
                                              borderRadius: BorderRadius.all(Radius.circular(17))
                                          ),
                                          child: const Icon(
                                              Icons.play_arrow,
                                              color: Color(0xff1f71ba)
                                          )
                                      ),
                                      subtitle: Text(
                                          boilos[index]["quizzSubTitle"].toString()
                                      ),
                                      title: text == "" ? Text(
                                          boilos[index]["quizzTitle"].toString().toUpperCase(),
                                          style: const TextStyle(
                                              fontWeight: FontWeight.bold
                                          )
                                      ):
                                      ParsedText(
                                          text: boilos[index]["quizzTitle"].toString().toUpperCase(),
                                          style:  const TextStyle(
                                              color: Colors.black,
                                              fontWeight: FontWeight.bold
                                          ),
                                          parse: <MatchText>[
                                            MatchText(
                                                pattern: r""+text.toUpperCase(),
                                                style: const TextStyle(
                                                    color: Colors.blue
                                                )
                                            )
                                          ]
                                      ),
                                      trailing: const Icon(Icons.arrow_forward_ios_rounded),
                                      onTap: (){
                                        /*
                                          Navigator.push(
                                              context,
                                              MaterialPageRoute(builder: (context) =>
                                                  SpecificBoiloScreen(
                                                      boilo: boilos[index],
                                                      prepaId: prepaId
                                                  )
                                              )
                                          );
                                         */
                                      }
                                    )
                                ),
                                index == boilos.length - 1 && !hideSeeMoreButtonBoilo ?
                                Column(
                                    children: [
                                      const SizedBox(height: 10),
                                      Center(
                                          child: SizedBox(
                                              width: 150,
                                              height: 40,
                                              child: TextButton(
                                                  style: ButtonStyle(
                                                      backgroundColor: MaterialStateProperty.all<Color>(const Color(0xfff29200)),
                                                      shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                                                          RoundedRectangleBorder(
                                                              borderRadius: BorderRadius.circular(100)
                                                          )
                                                      )
                                                  ),
                                                  onPressed: (){
                                                    offset += 10;
                                                    // backupPrepaBoilos();
                                                  },
                                                  child: const Text(
                                                    "Voir plus",
                                                    style: TextStyle(
                                                        color: Colors.white,
                                                        fontWeight: FontWeight.bold
                                                    )
                                                  )
                                              )
                                          )
                                      ),
                                      const SizedBox(height: 10)
                                    ]
                                ) :
                                const SizedBox()
                              ]
                            );
                          },
                          separatorBuilder: (context, index) {
                            return const Divider(height: 0);
                          }
                      )
                  )
                ]
            ),
            onRefresh: ()async{
              setState(() {
                offset = 0;
                firstLaunch = true;
                searchController.text = "";
              });
              // backupPrepaBoilos();
            }
        )
    );
  }
}