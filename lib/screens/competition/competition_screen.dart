import 'package:flutter/material.dart';
import '../../services/competition_api.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:flutter_parsed_text/flutter_parsed_text.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:totale_reussite/screens/competition/specific_competition.dart';

class CompetitionScreen extends StatefulWidget {
  const CompetitionScreen({super.key});

  @override
  State<CompetitionScreen> createState() => CompetitionScreenState();
}

class CompetitionScreenState extends State<CompetitionScreen> {
  int offset = 0;
  bool seeMore = false;
  List competition = [];
  List updateCompetition = [];
  bool launchGetCompetition = true;
  bool launchSynchronizeOnlineOffline = true;
  final ScrollController _controller = ScrollController();
  TextEditingController searchController = TextEditingController();

  Future getCompetition() async{
    String text = searchController.text;
    List values = await CompetitionOfflineRequests().getCompetition(text, offset);

    setState(() {
      if(offset == 0){
        competition.clear();
      }

      if(values.length == 20){
        seeMore = true;
      }
      else{
        seeMore = false;
      }

      competition.addAll(values);
      launchGetCompetition = false;
    });

  }

  Future synchronizeOnlineOffline() async{
    updateCompetition = await CompetitionOfflineRequests().synchronizeOnlineOffline();
    setState(() {
      launchSynchronizeOnlineOffline = false;
    });
  }

  @override
  initState() {
    super.initState();
    getCompetition();
    synchronizeOnlineOffline();
    _controller.addListener(() {
      if(_controller.position.pixels == _controller.position.maxScrollExtent){
        if(seeMore){
          offset += 20;
          getCompetition();
        }
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
            elevation: 0,
            centerTitle: true,
            iconTheme: const IconThemeData(
                color: Color(0xff0b65c2)
            ),
            title: Text(
              "Concours",
              style: GoogleFonts.quicksand(
                  textStyle: const TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 18,
                      color: Color(0xff0b65c2)
                  )
              )
          )
        ),
        backgroundColor: const Color(0xffebe6e0),
        body: SingleChildScrollView(
            controller: _controller,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Padding(
                    padding: const EdgeInsets.all(7),
                    child: SizedBox(
                        height: 45,
                        child: TextField(
                            controller: searchController,
                            decoration: InputDecoration(
                                prefixIcon: const Icon(Icons.search_rounded),
                                border: const OutlineInputBorder(),
                                labelText: "Recherche un produit",
                                labelStyle: GoogleFonts.rubik(
                                    fontSize: 13
                                )
                            ),
                            onChanged: (value){
                              setState(() {
                                competition.clear();
                                launchGetCompetition = true;
                              });
                              getCompetition();
                            }
                        )
                    )
                ),
                launchGetCompetition ?
                const Center(
                    child: CircularProgressIndicator()
                ):
                competition.isEmpty ?
                Center(
                    child: Text(
                        "Aucun concours trouvé",
                        style: GoogleFonts.rubik(
                            textStyle: const TextStyle(
                                fontWeight: FontWeight.bold
                            )
                        )
                    )
                ):
                Column(
                    children: [
                      Padding(
                          padding: const EdgeInsets.symmetric(
                            vertical: 5,
                            horizontal: 10,
                          ),
                          child: launchSynchronizeOnlineOffline ?
                          Row(
                              children: [
                                const Icon(
                                    Icons.cloud_rounded,
                                    size: 40
                                ),
                                const SizedBox(width: 10),
                                Expanded(
                                    child: Column(
                                        crossAxisAlignment: CrossAxisAlignment.start,
                                        children: const [
                                          Text("Syncronisation en cours"),
                                          SizedBox(height: 10),
                                          LinearProgressIndicator(
                                            color: Color(0xff0b65c2),
                                          )
                                        ]
                                    )
                                )
                              ]
                          ) :
                          Visibility(
                              visible: updateCompetition.isNotEmpty,
                              child: GestureDetector(
                                  onTap: (){
                                     setState(() {
                                       updateCompetition.clear();
                                     });
                                    getCompetition();
                                  },
                                  child: Row(
                                      children: [
                                        Expanded(
                                            child: Column(
                                                                                                        crossAxisAlignment: CrossAxisAlignment.start,
                                                children: [
                                                  Text(
                                                      "${updateCompetition.length} nouveaux concours",
                                                      style: GoogleFonts.rubik(
                                                          fontSize: 13,
                                                          fontWeight: FontWeight.bold
                                                      )
                                                  ),
                                                  const SizedBox(height: 5),
                                                  Text(
                                                      "Cliquez sur le bouton actualiser ci-contre pour voir.",
                                                      style: GoogleFonts.rubik(
                                                          fontSize: 13,
                                                          color: Colors.grey
                                                      )
                                                  ),
                                                  const SizedBox(height: 3)
                                                ]
                                            )
                                        ),
                                        const SizedBox(width: 10),
                                        const Icon(Icons.refresh_rounded)
                                      ]
                                  )
                              )
                          )
                      ),
                      Column(
                          children: competition.map(
                                  (e){
                                String text = "";
                                return GestureDetector(
                                  onTap: (){
                                    Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                            builder: (context) => SpecificCompetitionScreen(
                                              competition: e,
                                            )
                                        )
                                    );
                                  },
                                  child: Container(
                                      padding: const EdgeInsets.all(5),
                                      margin: const EdgeInsets.only(bottom: 3),
                                      decoration: const BoxDecoration(
                                          color: Colors.white
                                      ),
                                      child: Row(
                                          children: [
                                            CachedNetworkImage(
                                                imageUrl: "https://archetechnology.com/public/assets/img/infographie.png",
                                                placeholder: (context, url) => const Center(
                                                    child: SizedBox(
                                                        width: 30,
                                                        height: 30,
                                                        child: CircularProgressIndicator()
                                                    )
                                                ),
                                                imageBuilder: (context, imageProvider) =>
                                                    Container(
                                                        width: 50,
                                                        height: 50,
                                                        decoration: BoxDecoration(
                                                            image: DecorationImage(
                                                                image: imageProvider,
                                                                fit: BoxFit.cover
                                                            ),
                                                            borderRadius: BorderRadius.circular(5)
                                                        )
                                                    ),
                                                errorWidget: (context, url, error) => const Padding(
                                                    padding: EdgeInsets.all(10),
                                                    child: Icon(Icons.error)
                                                )
                                            ),
                                            const SizedBox(width: 10),
                                            Expanded(
                                                child: Column(
                                                    crossAxisAlignment: CrossAxisAlignment.start,
                                                    children: [
                                                      Text(
                                                          e["competitionName"].toUpperCase(),
                                                          overflow: TextOverflow.ellipsis,
                                                          style: GoogleFonts.rubik(
                                                            color: Colors.black,
                                                            fontWeight: FontWeight.w500,
                                                            fontSize: 18
                                                          )
                                                      ),
                                                      const SizedBox(height: 8),
                                                      Text(
                                                          e["competitionDescription"],
                                                          overflow: TextOverflow.ellipsis,
                                                          style: GoogleFonts.rubik(
                                                              color: Colors.grey
                                                          )
                                                      )
                                                    ]
                                                )
                                            ),
                                            const SizedBox(width: 5),
                                            const Icon(
                                                Icons.arrow_forward_ios_rounded,
                                                size: 16
                                            )
                                          ]
                                      )
                                  )
                                );
                              }
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
              ]
          )
        )
    );
  }
}