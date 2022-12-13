import 'package:flutter/material.dart';
import 'package:totale_reussite/screens/courses/specific_matter.dart';

class CourseSubjectsScreen extends StatefulWidget {
  const CourseSubjectsScreen({
    super.key,
    required this.code,
    required this.subjects
  });

  final String code;
  final Map subjects;

  @override
  State<CourseSubjectsScreen> createState() => CourseSubjectsScreenState();
}

class CourseSubjectsScreenState extends State<CourseSubjectsScreen> {

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
        body: SingleChildScrollView(
          child: Column(
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
                                      hintText: "Recherche matiere"
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
                Column(
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
                                subtitle: Text("Les courses de ${subjects[key]} ici"),
                                trailing: const Icon(Icons.arrow_forward_ios_rounded),
                                onTap: (){
                                  Navigator.of(context).push(
                                      MaterialPageRoute(
                                          builder: (context) => SpecificMatterScreen(
                                            subject: key,
                                            level: code
                                          )
                                      )
                                  );
                                }
                            )
                        )
                    ).toList()
                )
              ]
          )
        )
    );
  }
}