import 'package:flutter/material.dart';
import '../../services/articles_api.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:totale_reussite/screens/article/specific_article_screen.dart';

class ArticleScreen extends StatefulWidget {
  const ArticleScreen({super.key});

  @override
  State<ArticleScreen> createState() => ArticleScreenState();
}

class ArticleScreenState extends State<ArticleScreen> {
  int offset = 0;
  List articles = [];
  bool seeMore = false;
  bool launchGetArticles = false;
  final ScrollController _controller = ScrollController();

  Future getArticles() async{
    List values = await ArticlesOfflineRequests().getArticles(offset, 10);
    setState(() {
      if(offset == 0){
        articles.clear();
      }

      if(values.length == 5){
        seeMore = true;
      }
      else{
        seeMore = false;
      }

      articles.addAll(values);
      launchGetArticles = false;
    });
  }

  @override
  initState() {
    super.initState();
    getArticles();
    _controller.addListener(() {
      if(_controller.position.pixels == _controller.position.maxScrollExtent){
        if(seeMore){
          offset += 5;
          getArticles();
        }
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
            iconTheme: const IconThemeData(
                color: Color(0xff0b65c2)
            ),
            elevation: 0,
            title: Text(
                "Nos articles",
                style: GoogleFonts.quicksand(
                    color: const Color(0xff0b65c2),
                    fontWeight: FontWeight.bold
                )
            ),
            centerTitle: true
        ),
        backgroundColor: const Color(0xffebe6e0),
        body: SingleChildScrollView(
            controller: _controller,
            padding: const EdgeInsets.only(top: 10),
            child: Column(
              children: [
                Column(
                    children: articles.map(
                            (e) => Container(
                            padding: const EdgeInsets.all(10),
                            margin: const EdgeInsets.only(bottom: 5),
                            decoration: const   BoxDecoration(
                                color: Colors.white
                            ),
                            child: Row(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  SizedBox(
                                      height: 119,
                                      width: 90,
                                      child: Padding(
                                          padding: const EdgeInsets.only(top: 6),
                                          child: ClipRRect(
                                              borderRadius: BorderRadius.circular(10),
                                              child: Image.network(
                                                  'https://app.huch.tech/pictures/',
                                                  height: 119,
                                                  width: 100,
                                                  fit: BoxFit.fill
                                              )
                                          )
                                      )
                                  ),
                                  const SizedBox(width: 10),
                                  Expanded(
                                      child: Column(
                                          crossAxisAlignment: CrossAxisAlignment.start,
                                          children: [
                                            const SizedBox(height: 3),
                                            Text(
                                                e["title"],
                                                style: GoogleFonts.rubik(
                                                    textStyle: const TextStyle(
                                                        fontSize: 14,
                                                        color: Color(0xff6f7faf),
                                                        fontWeight: FontWeight.bold
                                                    )
                                                )
                                            ),
                                            const SizedBox(height: 5),
                                            SizedBox(
                                                height: 40,
                                                child: Text(
                                                    e["description"],
                                                    style: GoogleFonts.rubik(
                                                        textStyle: const TextStyle(
                                                            fontSize: 16,
                                                            color: Color(0xff0e1b42)
                                                        )
                                                    )
                                                )
                                            ),
                                            Align(
                                                alignment: Alignment.centerRight,
                                                child: TextButton(
                                                    onPressed: (){
                                                      Navigator.push(
                                                          context,
                                                          MaterialPageRoute(
                                                              builder: (context) => SpecificArticleScreen(
                                                                  article: e
                                                              )
                                                          )
                                                      );
                                                    },
                                                    child: Text(
                                                        "> Lire l'article",
                                                        style: GoogleFonts.quicksand(
                                                            textStyle: const TextStyle(
                                                                fontSize: 15,
                                                                color: Colors.black,
                                                                fontWeight: FontWeight.bold
                                                            )
                                                        )
                                                    )
                                                )
                                            )
                                          ]
                                      )
                                  )
                                ]
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