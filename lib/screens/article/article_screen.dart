import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:totale_reussite/screens/article/specific_article_screen.dart';

class ArticleScreen extends StatefulWidget {
  const ArticleScreen({super.key});

  @override
  State<ArticleScreen> createState() => ArticleScreenState();
}

class ArticleScreenState extends State<ArticleScreen> {

  @override
  initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          elevation: 0,
          title: Text(
              "Nos articles",
              style: GoogleFonts.quicksand(
                fontWeight: FontWeight.bold
              )
          ),
          centerTitle: true
        ),
        backgroundColor: Colors.grey[200]!,
        body: SingleChildScrollView(
          padding: const EdgeInsets.all(10),
          child: Column(
              children: [
                Container(
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(10),
                        color: Colors.white
                    ),
                    child: Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          ClipRRect(
                              borderRadius: const BorderRadius.only(
                                  topLeft: Radius.circular(10),
                                  bottomLeft: Radius.circular(10)
                              ),
                              child: Image.asset(
                                  'assets/images/image.jpg',
                                  width: 90
                              )
                          ),
                          const SizedBox(width: 15),
                          Expanded(
                              child: Column(
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                        'Comment réussir son examen.',
                                        style: GoogleFonts.quicksand(
                                            textStyle: const TextStyle(
                                                fontSize: 16,
                                                color: Colors.black,
                                                fontWeight: FontWeight.bold
                                            )
                                        )
                                    ),
                                    const SizedBox(height: 10),
                                    Text(
                                        'Article très interessant pour reussir son examen ou concours',
                                        style: GoogleFonts.rubik(
                                            textStyle: const TextStyle(
                                                fontSize: 15,
                                                color: Colors.grey
                                            )
                                        )
                                    ),
                                    Align(
                                        alignment: Alignment.centerRight,
                                        child: TextButton(
                                            onPressed: (){
                                              Navigator.of(context).push(
                                                  MaterialPageRoute(
                                                      builder: (context) => const SpecificArticleScreen()
                                                  )
                                              );
                                            },
                                            child: Row(
                                                mainAxisSize: MainAxisSize.min,
                                                children: [
                                                  const Icon(
                                                      Icons.arrow_forward_ios_rounded,
                                                      size: 14
                                                  ),
                                                  Text(
                                                      "Lire l'article",
                                                      style: GoogleFonts.rubik()
                                                  )
                                                ]
                                            )
                                        )
                                    )
                                  ]
                              )
                          )
                        ]
                    )
                ),
                const SizedBox(height: 5),
                Container(
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(10),
                        color: Colors.white
                    ),
                    child: Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          ClipRRect(
                              borderRadius: const BorderRadius.only(
                                  topLeft: Radius.circular(10),
                                  bottomLeft: Radius.circular(10)
                              ),
                              child: Image.asset(
                                  'assets/images/image.jpg',
                                  width: 90
                              )
                          ),
                          const SizedBox(width: 15),
                          Expanded(
                              child: Column(
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                        'Comment réussir son examen.',
                                        style: GoogleFonts.quicksand(
                                            textStyle: const TextStyle(
                                                fontSize: 16,
                                                color: Colors.black,
                                                fontWeight: FontWeight.bold
                                            )
                                        )
                                    ),
                                    const SizedBox(height: 10),
                                    Text(
                                        'Article très interessant pour reussir son examen ou concours',
                                        style: GoogleFonts.rubik(
                                            textStyle: const TextStyle(
                                                fontSize: 15,
                                                color: Colors.grey
                                            )
                                        )
                                    ),
                                    Align(
                                        alignment: Alignment.centerRight,
                                        child: TextButton(
                                            onPressed: (){},
                                            child: Row(
                                                mainAxisSize: MainAxisSize.min,
                                                children: [
                                                  const Icon(
                                                      Icons.arrow_forward_ios_rounded,
                                                      size: 14
                                                  ),
                                                  Text(
                                                      "Lire l'article",
                                                      style: GoogleFonts.rubik()
                                                  )
                                                ]
                                            )
                                        )
                                    )
                                  ]
                              )
                          )
                        ]
                    )
                ),
              ]
          )
        )
    );
  }
}