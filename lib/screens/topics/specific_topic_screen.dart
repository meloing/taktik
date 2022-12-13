import 'package:flutter/material.dart';
import '../../services/utilities.dart';
import 'package:google_fonts/google_fonts.dart';

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
          elevation: 0,
          centerTitle: true,
          title: Text(
              topic["title"],
              style: GoogleFonts.quicksand(
                fontWeight: FontWeight.bold
              )
          ),
          bottom: TabBar(
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
                ),
              ]
          ),
        ),
        body: TabBarView(
                physics: const NeverScrollableScrollPhysics(),
                controller: _tabController,
                children: <Widget>[
                  SingleChildScrollView(
                    child: MarkDown().body(
                          topic["exercice"]
                      )
                  ),
                  SingleChildScrollView(
                    child: MarkDown().body(
                        topic["correction"]
                    )
                  )
                ]
        )
    );
  }
}