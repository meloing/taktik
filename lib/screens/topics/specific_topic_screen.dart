import 'package:flutter/material.dart';
import '../../services/utilities.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:totale_reussite/services/local_data.dart';

class SpecificTopicScreen extends StatefulWidget {
  const SpecificTopicScreen({
    super.key,
    required this.topic
  });

  final Map topic;

  @override
  State<SpecificTopicScreen> createState() => SpecificTopicScreenState();
}

class SpecificTopicScreenState extends State<SpecificTopicScreen> with TickerProviderStateMixin{
  Map topic = {};
  late TabController _tabController;

  @override
  initState() {
    super.initState();
    topic = widget.topic;
    _tabController = TabController(length: 2, vsync: this);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
            iconTheme: const IconThemeData(
                color: Color(0xff0b65c2)
            ),
            elevation: 1,
            centerTitle: true,
            title: Text(
                topic["title"],
                style: GoogleFonts.quicksand(
                    color: const Color(0xff0b65c2),
                    fontWeight: FontWeight.bold
                )
            ),
            bottom: TabBar(
              labelColor: const Color(0xff0b65c2),
              controller: _tabController,
              tabs: <Widget>[
                Tab(
                    child: Text(
                        "EXERCICE",
                        style: GoogleFonts.quicksand(
                          fontSize: 18,
                          fontWeight: FontWeight.bold
                        )
                    )
                ),
                Tab(
                    child: Text(
                        "CORRECTION",
                        style: GoogleFonts.quicksand(
                            fontSize: 18,
                            fontWeight: FontWeight.bold
                        )
                    )
                )
              ]
          )
        ),
        body: TabBarView(
                physics: const NeverScrollableScrollPhysics(),
                controller: _tabController,
                children: <Widget>[
                  SingleChildScrollView(
                    child: MarkDown().body(topic["exercice"])
                  ),
                  topic["type"] == "unlock" ?
                  SingleChildScrollView(
                      child: MarkDown().body(topic["correction"])
                  ) :
                  (topic["type"] == "correctionLock" || topic["type"] == "lock") && LocalData().getPremium() == "yes" ?
                  SingleChildScrollView(
                      child: MarkDown().body(topic["correction"])
                  ) :
                  Padding(
                    padding: const EdgeInsets.all(15),
                    child: Column(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                              'Cette correction est disponible pour les membres prémiums. Devenez'
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
                  )
                ]
        )
    );
  }
}