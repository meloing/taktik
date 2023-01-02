import 'package:flutter/material.dart';
import '../../services/utilities.dart';
import 'package:google_fonts/google_fonts.dart';

class SpecificArticleScreen extends StatefulWidget {
  const SpecificArticleScreen({
    super.key,
    required this.article
  });

  final Map article;

  @override
  State<SpecificArticleScreen> createState() => SpecificArticleScreenState();
}

class SpecificArticleScreenState extends State<SpecificArticleScreen> {
  Map article = {};
  
  @override
  initState() {
    super.initState();
    article = widget.article;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
            iconTheme: const IconThemeData(
                color: Color(0xff0b65c2)
            ),
          elevation: 1,
          title: Text(
              "Article",
              style: GoogleFonts.quicksand(
                  color: const Color(0xff0b65c2),
                  fontWeight: FontWeight.bold
              )
          ),
          centerTitle: true,
          actions: [
            IconButton(
                onPressed: (){},
                icon: const Icon(Icons.share_rounded)
            )
          ]
        ),
        backgroundColor: Colors.white,
        body: SingleChildScrollView(
            child: Column(
                children: [
                  Padding(
                    padding: const EdgeInsets.all(5),
                    child: Text(
                        article["title"],
                        textAlign: TextAlign.center,
                        style: GoogleFonts.quicksand(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                            color: const Color(0xff0b65c2)
                        )
                    )
                  ),
                  MarkDown().body(article["description"])
                ]
            )
        )
    );
  }
}