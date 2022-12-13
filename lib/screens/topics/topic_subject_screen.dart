import 'package:flutter/material.dart';
import 'package:totale_reussite/screens/courses/specific_matter.dart';

class TopicSubjectsScreen extends StatefulWidget {
  const TopicSubjectsScreen({
    super.key,
    required this.code,
    required this.subjects
  });

  final String code;
  final Map subjects;

  @override
  State<TopicSubjectsScreen> createState() => TopicSubjectsScreenState();
}

class TopicSubjectsScreenState extends State<TopicSubjectsScreen> {

  String code = "";
  Map subjects = {};

  @override
  initState() {
    super.initState();
    code = widget.code;
    subjects = widget.subjects;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
            elevation: 0,
            title: const Text("MATIERES")
        ),
        backgroundColor: Colors.grey[200],
        body: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Padding(
                  padding: const EdgeInsets.all(10),
                  child: Row(
                      children: [
                        const Expanded(
                            child: TextField(
                                decoration: InputDecoration(
                                    filled: true,
                                    fillColor: Colors.white,
                                    border: OutlineInputBorder(),
                                    hintText: "Recherche matieres"
                                )
                            )
                        ),
                        const SizedBox(width: 5),
                        SizedBox(
                            height: 60,
                            child: TextButton(
                              style: ButtonStyle(
                                  backgroundColor: MaterialStateProperty.all<Color>(
                                      Colors.blue
                                  ),
                                  shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                                      RoundedRectangleBorder(
                                          borderRadius: BorderRadius.circular(5)
                                      )
                                  )
                              ),
                              onPressed: (){},
                              child: const Icon(
                                  Icons.search_rounded,
                                  color: Colors.white
                              )
                            )
                        )
                      ]
                  )
              ),
              Expanded(
                  child: ListView(
                      children: subjects.keys.map(
                              (key) => Container(
                              margin: const EdgeInsets.only(bottom: 10),
                              decoration: const BoxDecoration(
                                  color: Colors.white
                              ),
                              child: ListTile(
                                  title: Text(
                                      subjects[key],
                                      style: const TextStyle(
                                          fontWeight: FontWeight.bold
                                      )
                                  ),
                                  subtitle: Text("Les sujets de ${subjects[key]} ici"),
                                  trailing: const Icon(Icons.arrow_forward_ios_rounded),
                                  onTap: (){
                                    Navigator.of(context).push(
                                        MaterialPageRoute(
                                            builder: (context) => SpecificMatterScreen(
                                              subject: key,
                                              level: code,
                                            )
                                        )
                                    );
                                  }
                              )
                          )
                      ).toList()
                  )
              )
            ]
        )
    );
  }
}