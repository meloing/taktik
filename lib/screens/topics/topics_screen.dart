import 'package:flutter/material.dart';
import '../../services/topics_api.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:totale_reussite/services/local_data.dart';
import 'package:totale_reussite/screens/topics/specific_topic_screen.dart';

class TopicsScreen extends StatefulWidget {
  const TopicsScreen({super.key});

  @override
  State<TopicsScreen> createState() => TopicsScreenState();
}

class TopicsScreenState extends State<TopicsScreen> {
  int offset = 0;
  List topics = [];
  bool seeMore = false;
  bool launchGetTopics = true;
  final ScrollController _controller = ScrollController();
  TextEditingController searchController = TextEditingController();

  Future getTopics() async{
    String text = searchController.text;
    String level = LocalData().getLevel();
    List values = await TopicOfflineRequests().getTopics(level, offset, text);

    setState(() {
      if(offset == 0){
        topics.clear();
      }

      if(values.length == 20){
        seeMore = true;
      }
      else{
        seeMore = false;
      }

      topics.addAll(values);
      launchGetTopics = false;
    });
  }

  void bottomSheet(){
    showModalBottomSheet<void>(
        elevation: 10,
        context: context,
        shape:const  RoundedRectangleBorder(
            borderRadius: BorderRadius.only(
                topLeft: Radius.circular(10),
                topRight: Radius.circular(10)
            )
        ),
        builder: (BuildContext context) {
          return Padding(
              padding: const EdgeInsets.all(5),
              child: Column(
                  mainAxisSize: MainAxisSize.min,
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Text(
                        'Sujet premium',
                        style: GoogleFonts.quicksand(
                            textStyle: const TextStyle(
                                fontSize: 28,
                                color: Colors.black,
                                fontWeight: FontWeight.bold
                            )
                        )
                    ),
                    const SizedBox(height: 10),
                    Text(
                        'Ce sujet est disponible pour les membres prémiums. Devenez'
                            ' premium pour avoir accès à tous nos cours et sujets en illimité.',
                        textAlign: TextAlign.justify,
                        style: GoogleFonts.rubik(
                            textStyle: const TextStyle(
                                fontSize: 16,
                                color: Color(0xff0e1b42)
                            )
                        )
                    ),
                    const SizedBox(height: 15),
                    SizedBox(
                        height: 56,
                        width: double.infinity,
                        child: TextButton(
                            style: ButtonStyle(
                                backgroundColor: MaterialStateProperty.all<Color>(Colors.orange),
                                shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                                    RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(6),
                                    )
                                )
                            ),
                            onPressed: (){},
                            child: Text(
                                "Devenir premium",
                                style: GoogleFonts.rubik(
                                    color: Colors.white
                                )
                            )
                        )
                    )
                  ]
              )
          );
        }
    );
  }

  @override
  initState() {
    super.initState();
    getTopics();
    _controller.addListener(() {
      if(_controller.position.pixels == _controller.position.maxScrollExtent){
        if(seeMore){
          offset += 20;
          getTopics();
        }
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: const Color(0xffebe6e0),
        body: SingleChildScrollView(
            controller: _controller,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Container(
                    margin: const EdgeInsets.symmetric(
                        horizontal: 7,
                        vertical: 5
                    ),
                    padding: const EdgeInsets.all(2),
                    child: SizedBox(
                        height: 44,
                        child: TextField(
                            cursorColor: Colors.black,
                            controller: searchController,
                            decoration: InputDecoration(
                                filled: true,
                                fillColor: Colors.transparent,
                                prefixIcon: const Icon(
                                    Icons.search_rounded,
                                    color: Colors.black
                                ),
                                border: const OutlineInputBorder(
                                    borderSide: BorderSide(color: Colors.grey)
                                ),
                                focusedBorder: const OutlineInputBorder(
                                    borderSide: BorderSide(color: Colors.grey)
                                ),
                                labelText: "Recherche un sujet",
                                labelStyle: GoogleFonts.rubik(
                                    fontSize: 13,
                                    color: Colors.black
                                )
                            ),
                            onChanged: (value){
                              setState(() {
                                offset = 0;
                                launchGetTopics = true;
                              });
                              getTopics();
                            }
                        )
                    )
                ),
                launchGetTopics ?
                const Center(
                    child: CircularProgressIndicator(
                        color: Color(0xff0b65c2)
                    )
                ) :
                topics.isEmpty ?
                Center(
                    child: Padding(
                        padding: const EdgeInsets.only(top: 20),
                        child: Text(
                            "Aucun résultat",
                            style: GoogleFonts.rubik(
                                fontWeight: FontWeight.bold
                            )
                        )
                    )
                ):
                Column(
                    children: topics.map(
                            (e) => Container(
                            margin: const EdgeInsets.only(bottom: 3),
                            decoration: const BoxDecoration(
                                color: Colors.white
                            ),
                            child: ListTile(
                                title: Text(
                                  e["title"],
                                  style: GoogleFonts.quicksand(
                                      fontSize: 18,
                                      fontWeight: FontWeight.bold
                                  ),
                                ),
                                subtitle: Text(
                                    e["description"],
                                    style: GoogleFonts.rubik()
                                ),
                                trailing: Icon(
                                    e["type"] == "lock" ? Icons.lock :
                                    e["type"] == "unlock" ? Icons.lock_open_rounded :
                                    Icons.lock_clock_rounded,
                                    size: 16
                                ),
                                onTap: (){
                                  if(e["type"] == "lock"){
                                    if(LocalData().getPremium() == "yes"){
                                      Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                              builder: (context) => SpecificTopicScreen(
                                                  topic: e
                                              )
                                          )
                                      );
                                    }
                                    else{
                                      bottomSheet();
                                    }
                                  }
                                  else{
                                    Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                            builder: (context) => SpecificTopicScreen(
                                                topic: e
                                            )
                                        )
                                    );
                                  }
                                }
                            )
                        )
                    ).toList()
                ),
                const SizedBox(height: 10),
                Visibility(
                    visible: seeMore,
                    child: const SizedBox(
                        width: 30,
                        height: 30,
                        child: CircularProgressIndicator(
                            color: Color(0xff0b65c2)
                        )
                    )
                ),
                const SizedBox(height: 10)
              ]
          )
        )
    );
  }
}