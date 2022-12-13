import '../../services/api.dart';
import 'package:flutter/material.dart';
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
  List competition = [];
  bool launchGetCompetition = true;
  TextEditingController searchController = TextEditingController();

  Future addOrUpdateCompetition(List values) async{
    // add or update course in local database

    for(Map value in values){
      List competition = await LocalDatabase().getCompetitionById(value["competitionId"]);
      if(competition.isEmpty){
        await LocalDatabase().addCompetition(
            value["competitionId"],
            value["competitionContacts"],
            value["competitionCountry"],
            value["competitionDate"],
            value["competitionDescription"],
            value["competitionLink"],
            value["competitionName"],
            value["competitionPicture"]
        );
      }
      else{
        await LocalDatabase().updateCompetition(
            value["competitionId"],
            value["competitionContacts"],
            value["competitionCountry"],
            value["competitionDate"],
            value["competitionDescription"],
            value["competitionLink"],
            value["competitionName"],
            value["competitionPicture"]
        );
      }
    }
  }

  Future getCompetition() async{
    late List values;
    String lastDate = "";
    String text = searchController.text;

    // Récupération de la dernière date de cours
    List val = await LocalDatabase().getLastCompetitionDate();
    if(val.isNotEmpty){
      lastDate = val[0]["competitionDate"];
    }

    values = await LocalDatabase().getCompetition(text);
    if(values.isEmpty){
      values = await ManageDatabase().getCompetition(lastDate);
      await addOrUpdateCompetition(values);
    }

    setState(() {
      competition.addAll(values);
      launchGetCompetition = false;
    });

    // Mise à jour des competitions
    values = await ManageDatabase().getCompetition(lastDate);
    await addOrUpdateCompetition(values);
  }

  @override
  initState() {
    super.initState();
    getCompetition();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          elevation: 0,
          centerTitle: true,
          title: Text(
              "Concours",
              style: GoogleFonts.quicksand(
                fontWeight: FontWeight.bold
              )
          )
        ),
        body: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Padding(
                  padding: const EdgeInsets.all(10),
                  child: TextField(
                      controller: searchController,
                      decoration: InputDecoration(
                          filled: true,
                          fillColor: Colors.white,
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
              ),
              Expanded(
                  child:
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
                  ListView.separated(
                      itemCount: competition.length,
                      itemBuilder: (BuildContext context,int index){
                        String text = "";
                        return Container(
                            margin: const EdgeInsets.only(bottom: 10),
                            decoration: const BoxDecoration(
                                color: Colors.white
                            ),
                            child: Column(
                                children: [
                                  Row(
                                      children: [
                                        Expanded(
                                            child: text == "" ? Text(
                                                competition[index]["competitionName"].toUpperCase(),
                                                overflow: TextOverflow.ellipsis,
                                                style: const TextStyle(
                                                  color: Colors.black,
                                                  fontWeight: FontWeight.bold,
                                                  fontSize: 18,
                                                )
                                            ):
                                            ParsedText(
                                                text: competition[index]["competitionName"].toUpperCase(),
                                                overflow: TextOverflow.ellipsis,
                                                style:  const TextStyle(
                                                  color: Colors.black,
                                                  fontSize: 18,
                                                  fontWeight: FontWeight.bold
                                                ),
                                                parse: <MatchText>[
                                                  MatchText(
                                                      pattern: r""+text.toUpperCase(),
                                                      style: const TextStyle(
                                                        color: Colors.blue
                                                      )
                                                  )
                                                ]
                                            )
                                        )
                                      ]
                                  ),
                                  const SizedBox(height: 5),
                                  Row(
                                      children: [
                                        ClipRRect(
                                            borderRadius: const BorderRadius.all(Radius.circular(5.0)),
                                            child: SizedBox(
                                                width: 100,
                                                height: 140,
                                                child: CachedNetworkImage(
                                                    imageUrl: "https://www.archetechnology.com/totale-reussite/ressources/${competition[index]["competitionPicture"]}",
                                                    placeholder: (context, url) => const Center(
                                                        child: SizedBox(
                                                            width: 30,
                                                            height: 30,
                                                            child: CircularProgressIndicator()
                                                        )
                                                    ),
                                                    errorWidget: (context, url, error) => const Padding(
                                                        padding: EdgeInsets.all(35),
                                                        child: Icon(Icons.error)
                                                    )
                                                )
                                            )
                                        ),
                                        const SizedBox(width: 15),
                                        Expanded(
                                            child: Column(
                                                children: [
                                                  const SizedBox(height: 5),
                                                  Row(
                                                      children: [
                                                        const Icon(Icons.flag_rounded, color: Color(0xFFA0A5BD)),
                                                        const SizedBox(width: 10),
                                                        Expanded(
                                                            child: Text(
                                                                competition[index]["competitionCountry"],
                                                                style: const TextStyle(
                                                                    fontSize: 17,
                                                                    color: Colors.grey,
                                                                    fontWeight: FontWeight.bold
                                                                )
                                                            )
                                                        )
                                                      ]
                                                  ),
                                                  const SizedBox(height: 5),
                                                  Row(
                                                      children: [
                                                        const Icon(
                                                            Icons.perm_contact_calendar_rounded,
                                                            color: Color(0xFFA0A5BD)
                                                        ),
                                                        const SizedBox(width: 10),
                                                        Expanded(
                                                            child: Text(
                                                                competition[index]["competitionContacts"],
                                                                overflow: TextOverflow.ellipsis,
                                                                style: const TextStyle(
                                                                    fontSize: 17,
                                                                    color: Colors.grey,
                                                                    fontWeight: FontWeight.bold
                                                                )
                                                            )
                                                        )
                                                      ]
                                                  ),
                                                  const SizedBox(height: 5),
                                                  Row(
                                                      children: [
                                                        const Icon(Icons.link_rounded, color: Color(0xFFA0A5BD), size: 30),
                                                        const SizedBox(width: 5),
                                                        Expanded(
                                                            child: ParsedText(
                                                                text: competition[index]["competitionLink"].toString(),
                                                                overflow: TextOverflow.ellipsis,
                                                                style:  const TextStyle(
                                                                    fontSize: 17,
                                                                    color: Colors.grey,
                                                                    fontWeight: FontWeight.bold
                                                                ),
                                                                parse: <MatchText>[
                                                                  MatchText(
                                                                      type: ParsedType.URL,
                                                                      style: const TextStyle(
                                                                          fontSize: 17,
                                                                          color: Colors.blue
                                                                      ),
                                                                      onTap: (url) async{
                                                                        if (!await launch(url)) throw '';
                                                                      }
                                                                  )
                                                                ]
                                                            )
                                                        )
                                                      ]
                                                  ),
                                                  const SizedBox(height: 5),
                                                  Row(
                                                      children: <Widget>[
                                                        Container(
                                                            height: 40,
                                                            decoration: BoxDecoration(
                                                                color: const Color(0xfff29200),
                                                                borderRadius: BorderRadius.circular(100)
                                                            ),
                                                            child: IconButton(
                                                                onPressed: (){
                                                                  /*
                                                                          String ad = "Tu prépares un concours, un examen, "
                                                                              "Télécharge  l'application prepa reussite en cliquant sur ce lien: "
                                                                              "https://play.google.com/store/apps/details?id=com.archetechnology.prepa_reussite "
                                                                              " pour une préparation en ligne efficace, anciens sujets et corrigés disponible, les informations "
                                                                              "pour postuler au concours disponible.";
                                                                          String id = concours[index]["concourId"].toString();
                                                                          String name = concours[index]["concourNom"].replaceAll(" ", "-");
                                                                          String text = concours[index]["concourNom"] + " \nCliquez sur le lien ci-dessous pour plus d'informations. \n"
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
                                                                height: 40,
                                                                child: TextButton(
                                                                    style: ButtonStyle(
                                                                        backgroundColor: MaterialStateProperty.all<Color>(const Color(0xff1f71ba)),
                                                                        shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                                                                            RoundedRectangleBorder(
                                                                                borderRadius: BorderRadius.circular(100)
                                                                            )
                                                                        )
                                                                    ),
                                                                    onPressed: (){
                                                                      Navigator.push(
                                                                        context,
                                                                        MaterialPageRoute(
                                                                            builder: (context) => SpecificCompetitionScreen(
                                                                              competition: competition[index],
                                                                            )
                                                                        )
                                                                      );
                                                                    },
                                                                    child: const Text("Voir",
                                                                        style: TextStyle(
                                                                          color: Colors.white,
                                                                          fontWeight: FontWeight.bold,
                                                                        )
                                                                    )
                                                                )
                                                            )
                                                        ),
                                                        const SizedBox(width: 10)
                                                      ]
                                                  ),
                                                  const SizedBox(height: 5)
                                                ]
                                            )
                                        )
                                      ]
                                  )
                                ]
                            )
                        );
                      },
                    separatorBuilder: (BuildContext context, int index){
                      return const Divider(thickness: 5, color: Colors.grey);
                    }
                  )
              )
            ]
        )
    );
  }
}