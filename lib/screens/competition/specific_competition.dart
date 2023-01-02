import '../../services/utilities.dart';
import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:flutter_parsed_text/flutter_parsed_text.dart';
import 'package:cached_network_image/cached_network_image.dart';

class SpecificCompetitionScreen extends StatefulWidget {
  const SpecificCompetitionScreen({
    Key? key,
    required this.competition
  }) : super(key: key);

  final Map competition;

  @override
  SpecificCompetitionScreenState createState() => SpecificCompetitionScreenState();
}

class SpecificCompetitionScreenState extends State<SpecificCompetitionScreen> {
  bool start = false;
  late Map competition;

  @override
  initState() {
    super.initState();
    competition = widget.competition;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
            elevation: 1,
            centerTitle: true,
            iconTheme: const IconThemeData(
                color: Color(0xff0b65c2)
            ),
            title: Text(
                competition["competitionName"].toUpperCase(),
                style: GoogleFonts.quicksand(
                    textStyle: const TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 18,
                        color: Color(0xff0b65c2)
                    )
                )
            )
        ),
        body: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                  child: SingleChildScrollView(
                      child: Column(
                          children: [
                            CachedNetworkImage(
                                imageUrl: "https://www.archetechnology.com/totale-reussite/ressources/${competition['competitionPicture']}",
                                imageBuilder: (context, imageProvider) =>
                                    Container(
                                        height: 200,
                                        decoration: BoxDecoration(
                                            image: DecorationImage(
                                                image: imageProvider,
                                                fit: BoxFit.cover
                                            )
                                        )
                                    ),
                                placeholder: (context, url) => Container(
                                    height: 200,
                                    color: Colors.grey,
                                    child: const Center(
                                      child: SizedBox(
                                          width: 30,
                                          height: 30,
                                          child: CircularProgressIndicator()
                                      )
                                  )
                                ),
                                errorWidget: (context, url, error) => Container(
                                    height: 200,
                                    color: Colors.grey,
                                    child: const Center(
                                        child: Text(
                                            'Concours',
                                            textAlign: TextAlign.center,
                                            style: TextStyle(
                                                fontWeight: FontWeight.bold
                                            )
                                        )
                                    )
                                )
                            ),
                            Padding(
                                padding: const EdgeInsets.all(10),
                                child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      const SizedBox(height: 10),
                                      Text(
                                          competition["competitionName"].toString().toUpperCase(),
                                          style: GoogleFonts.rubik(
                                              fontSize: 20,
                                              fontWeight: FontWeight.bold
                                          )
                                      ),
                                      const SizedBox(height: 15),
                                      Text(
                                          competition["competitionCountry"].toString(),
                                          style: GoogleFonts.rubik(
                                              fontSize: 20
                                          )
                                      ),
                                      const SizedBox(height: 10),
                                      Text(
                                          "Publié le : ${competition["competitionDate"]}",
                                          style: GoogleFonts.rubik(
                                              fontSize: 20
                                          )
                                      ),
                                      const SizedBox(height: 10),
                                      ParsedText(
                                          text: competition["competitionLink"].toString().replaceAll('[a]', ""),
                                          style:  GoogleFonts.rubik(
                                              fontSize: 20,
                                              color: Colors.grey
                                          ),
                                          parse: <MatchText>[
                                            MatchText(
                                                type: ParsedType.URL,
                                                style: GoogleFonts.rubik(
                                                    fontSize: 20,
                                                    color: Colors.blue
                                                )
                                            )
                                          ]
                                      ),
                                      const SizedBox(height: 10),
                                      Text(
                                          competition["competitionContacts"].toString(),
                                          style: GoogleFonts.rubik(
                                              fontSize: 20
                                          )
                                      ),
                                      const Divider(),
                                      const SizedBox(height: 10),
                                      Text(
                                          "DETAILS DU CONCOURS",
                                          style: GoogleFonts.rubik(
                                              fontSize: 20,
                                              fontWeight: FontWeight.bold
                                          )
                                      ),
                                      const SizedBox(height: 10),
                                      MarkDown().body(
                                          competition["competitionDescription"].replaceAll("[a]", "")
                                      )
                                    ]
                                )
                            )
                          ]
                      )
                  )
              ),
              Container(
                  color: Colors.white,
                  padding: const EdgeInsets.all(10),
                  child: Row(
                      children: [
                        Container(
                            height: 50,
                            width: 50,
                            decoration: BoxDecoration(
                                color: const Color(0xfff29200),
                                borderRadius: BorderRadius.circular(10)
                            ),
                            child: IconButton(
                                onPressed: (){
                                  /*
                                  String ad = "Tu prépares un concours, un examen, "
                                      "Télécharge  l'application prepa reussite en cliquant sur ce lien: "
                                      "https://play.google.com/store/apps/details?id=com.archetechnology.prepa_reussite "
                                      " pour une préparation en ligne efficace, anciens sujets et corrigés disponible, les informations "
                                      "pour postuler au concours disponible.";
                                  String id = concours["concourId"].toString();
                                  String name = concours["concourNom"].replaceAll(" ", "-");
                                  String text = concours["concourNom"] + " \nCliquez sur le lien ci-dessous pour plus d'informations. \n"
                                      "https://totale-reussite.com/concours/concours-view/"+
                                      id+"/"+name+"\n\n"+ad;
                                  SocialShare.shareOptions(text).then((data) {});

                                   */
                                },
                                icon: const Icon(
                                    Icons.share_rounded,
                                    color: Colors.white
                                )
                            )
                        ),
                        const SizedBox(width: 10),
                        Expanded(
                            child: SizedBox(
                                height: 50,
                                child: TextButton(
                                    onPressed: () async{
                                      String link = competition["competitionLink"].replaceAll("[a]", "");
                                      link = link.replaceAll("[/a]", "");

                                      if (!await launch(link)) throw 'Could not launch';
                                    },
                                    style: ButtonStyle(
                                        backgroundColor: MaterialStateProperty.all<Color>(const Color(0xff1f71ba)),
                                        shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                                            RoundedRectangleBorder(
                                                borderRadius: BorderRadius.circular(10)
                                            )
                                        )
                                    ),
                                    child: const Text(
                                      "Concourir",
                                      style: TextStyle(
                                          fontWeight: FontWeight.bold,
                                          color: Colors.white
                                      ),
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