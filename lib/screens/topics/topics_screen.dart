import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:totale_reussite/screens/topics/specific_topic_screen.dart';
import 'package:totale_reussite/screens/topics/topic_subject_screen.dart';
import 'package:totale_reussite/services/local_data.dart';

import '../../services/topics_api.dart';

class TopicsScreen extends StatefulWidget {
  const TopicsScreen({super.key});

  @override
  State<TopicsScreen> createState() => TopicsScreenState();
}

class TopicsScreenState extends State<TopicsScreen> {
  List topics = [];
  TextEditingController searchController = TextEditingController();

  Future getTopics() async{
    String level = LocalData().getLevel();
    List values = await OnlineRequests().getTopics(level);
    setState(() {
      topics.addAll(values);
    });
  }

  void displayBottomMoreAction(BuildContext context, Map subLevels, Map subjects) {
    showModalBottomSheet(
        context: context,
        shape: const RoundedRectangleBorder(
            borderRadius: BorderRadius.only(
                topRight: Radius.circular(15),
                topLeft: Radius.circular(15)
            )
        ),
        builder: (ctx) {
          return SizedBox(
              height: 270,
              child: Column(
                  children: subLevels.keys.map(
                          (key) => Column(
                          children: [
                            const Divider(height: 0),
                            ListTile(
                                title: Text(
                                    subLevels[key],
                                    style: const TextStyle(
                                        fontWeight: FontWeight.bold
                                    )
                                ),
                                subtitle: Text("Les courses de ${subLevels[key]}"),
                                trailing: const Icon(Icons.arrow_forward_ios_rounded),
                                onTap: (){
                                  Navigator.of(context).push(
                                      MaterialPageRoute(
                                          builder: (context) => TopicSubjectsScreen(
                                              code: key,
                                              subjects: subjects[key]
                                          )
                                      )
                                  );
                                }
                            )
                          ]
                      )
                  ).toList()
              )
          );
        }
    );
  }

  @override
  initState() {
    super.initState();
    getTopics();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Colors.grey[200],
        body: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Expanded(
                  child: ListView(
                      children: topics.map(
                              (e) => Column(
                                children: [
                                  Container(
                                    color: Colors.white,
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
                                        trailing: const Icon(
                                            Icons.arrow_forward_ios_rounded
                                        ),
                                        onTap: (){
                                          Navigator.push(
                                              context,
                                              MaterialPageRoute(
                                                  builder: (context) => SpecificTopicScreen(
                                                      topic: e
                                                  )
                                              )
                                          );
                                        }
                                    )
                                  ),
                                  const Divider(height: 0, thickness: 2)
                                ]
                              )
                      ).toList()
                  )
              ),
              Container(
                  color: Colors.white,
                  padding: const EdgeInsets.all(2),
                  child: SizedBox(
                      height: 44,
                      child: TextField(
                          controller: searchController,
                          decoration: InputDecoration(
                              filled: true,
                              fillColor: Colors.transparent,
                              prefixIcon: const Icon(Icons.search_rounded),
                              border: const OutlineInputBorder(
                                  borderSide: BorderSide(color: Colors.transparent)
                              ),
                              labelText: "Recherche un sujet",
                              labelStyle: GoogleFonts.rubik(
                                  fontSize: 13
                              )
                          ),
                          onChanged: (value){
                            setState(() {


                            });
                          }
                      )
                  )
              )
            ]
        )
    );
  }
}