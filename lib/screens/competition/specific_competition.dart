import '../../services/utilities.dart';
import 'package:flutter/material.dart';
import 'package:social_share/social_share.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:external_path/external_path.dart';
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
            elevation: 0,
            centerTitle: true,
            backgroundColor: Colors.blue,
            title: Text(
                competition["competitionName"].toUpperCase(),
                style: const TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold
                )
            )
        ),
        backgroundColor: Colors.grey[100],
        body: start ?
        Column(
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
                                    placeholder: (context, url) => const Center(
                                    child: SizedBox(
                                        width: 30,
                                        height: 30,
                                        child: CircularProgressIndicator()
                                    )
                                ),
                                    errorWidget: (context, url, error) => Container(
                                        color: Colors.grey,
                                        height: 200,
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
                            Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                      competition["competitionName"].toString().toUpperCase(),
                                      style: const TextStyle(
                                          fontSize: 20,
                                          color: Color(0xfff29200),
                                          fontWeight: FontWeight.bold
                                      )
                                  ),
                                  const SizedBox(height: 15),
                                  Text(
                                      competition["competitionCountry"].toString(),
                                      style: const TextStyle(
                                          fontSize: 20,
                                          color: Colors.grey
                                      )
                                  ),
                                  Text(
                                      competition["competitionContacts"].toString(),
                                      style: const TextStyle(
                                          fontSize: 20,
                                          color: Colors.grey
                                      )
                                  ),
                                  const SizedBox(height: 10),
                                  const Divider(),
                                  Row(
                                      children: [
                                        const Icon(Icons.add_location_alt_rounded, color: Colors.grey, size: 30),
                                        const SizedBox(width: 15),
                                        Expanded(
                                            child: Text(
                                                competition["competitionCountry"].toString(),
                                                style: const TextStyle(
                                                    fontSize: 20
                                                )
                                            )
                                        )
                                      ]
                                  ),
                                  const SizedBox(height: 10),
                                  Row(
                                      children: [
                                        const Icon(Icons.date_range_rounded, color: Colors.grey, size: 30),
                                        const SizedBox(width: 15),
                                        Expanded(
                                            child: Text(
                                                "Publié le : ${competition["competitionDate"]}",
                                                style: const TextStyle(
                                                    fontSize: 20
                                                )
                                            )
                                        )
                                      ]
                                  ),
                                  const SizedBox(height: 10),
                                  Row(
                                      children: [
                                        const Icon(Icons.link_rounded, color: Colors.grey, size: 30),
                                        const SizedBox(width: 15),
                                        Expanded(
                                            child: ParsedText(
                                                text: competition["competitionLink"].toString().replaceAll('[a]', ""),
                                                style:  const TextStyle(
                                                    fontSize: 20,
                                                    color: Colors.grey
                                                ),
                                                parse: <MatchText>[
                                                  MatchText(
                                                      type: ParsedType.URL,
                                                      style: const TextStyle(
                                                          fontSize: 20,
                                                          color: Colors.blue
                                                      ),
                                                      onTap: (url) async{
                                                        if (!await canLaunch(url)) throw '';
                                                      }
                                                  )
                                                ]
                                            )
                                        )
                                      ]
                                  ),
                                  const SizedBox(height: 10),
                                  Row(
                                      children: [
                                        const Icon(Icons.perm_contact_calendar_rounded, color: Colors.grey, size: 30),
                                        const SizedBox(width: 15),
                                        Expanded(
                                            child: Text(
                                                competition["competitionContacts"].toString(),
                                                style: const TextStyle(
                                                    fontSize: 20
                                                )
                                            )
                                        )
                                      ]
                                  ),
                                  const Divider(),
                                  const SizedBox(height: 10),
                                  const Text(
                                      "DETAILS DU CONCOURS",
                                      style: TextStyle(
                                          fontSize: 20,
                                          color: Color(0xfff29200),
                                          fontWeight: FontWeight.bold
                                      )
                                  ),
                                  const SizedBox(height: 10),
                                  MarkDown().body(
                                      competition["competitionDescription"].replaceAll("[a]", "")
                                  )
                                ]
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
        ) :
        const Center(
            child: CircularProgressIndicator()
        )
    );
  }
}