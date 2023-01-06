import 'package:flutter/material.dart';
import '../../services/point_method_api.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:totale_reussite/screens/method/specific_point_method_screen.dart';

class PointMethodScreen extends StatefulWidget {
  const PointMethodScreen({super.key});

  @override
  State<PointMethodScreen> createState() => PointMethodScreenState();
}

class PointMethodScreenState extends State<PointMethodScreen> {
  int offset = 0;
  bool seeMore = false;
  List pointMethods = [];
  bool launchGetPointMethods = false;
  final ScrollController _controller = ScrollController();
  TextEditingController searchController = TextEditingController();

  String returnDay(String date){
    DateTime newDate = DateTime.parse(date);
    List weekdayName = ["Lun", "Mar", "Mer", "Jeu", "Ven", "Sam", "Dim"];
    return weekdayName[newDate.weekday-1];
  }

  Future getPointMethods() async{
    String text = searchController.text;
    List values = await PointMethodOfflineRequests().getPointMethods(offset, 20, text);
    setState(() {
      if(offset == 0){
        pointMethods.clear();
      }

      if(values.length == 20){
        seeMore = true;
      }
      else{
        seeMore = false;
      }

      pointMethods.addAll(values);
      launchGetPointMethods = false;
    });
  }

  @override
  initState() {
    super.initState();
    getPointMethods();
    _controller.addListener(() {
      if(_controller.position.pixels == _controller.position.maxScrollExtent){
        if(seeMore){
          offset += 20;
          getPointMethods();
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
                "Points Méthodes",
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
            child: Column(
              children: [
                Container(
                    margin: const EdgeInsets.symmetric(
                        horizontal: 7,
                        vertical: 5
                    ),
                    height: 44,
                    child: TextField(
                        cursorColor: Colors.black,
                        controller: searchController,
                        decoration: InputDecoration(
                            filled: true,
                            fillColor: Colors.transparent,
                            prefixIcon: const Icon(
                                Icons.search_rounded,
                                color: Colors.black
                            ),
                            border: const OutlineInputBorder(
                                borderSide: BorderSide(color: Colors.grey)
                            ),
                            focusedBorder: const OutlineInputBorder(
                                borderSide: BorderSide(color: Colors.grey)
                            ),
                            labelText: "Recherche un point methode",
                            labelStyle: GoogleFonts.rubik(
                                fontSize: 13,
                                color: Colors.black
                            )
                        ),
                        onChanged: (value){
                          setState(() {
                            offset = 0;
                            launchGetPointMethods = true;
                          });
                          getPointMethods();
                        }
                    )
                ),
                launchGetPointMethods ?
                const Center(
                  child: CircularProgressIndicator(
                      color: Color(0xff0b65c2)
                  )
                ) :
                pointMethods.isEmpty ?
                Center(
                  child: Padding(
                    padding: const EdgeInsets.only(top: 20),
                    child: Text(
                        "Aucun résultat",
                        style: GoogleFonts.rubik(
                            fontWeight: FontWeight.bold
                        )
                    )
                  )
                ):
                Column(
                    children: pointMethods.map(
                            (e) => Container(
                            margin: const EdgeInsets.only(bottom: 5),
                            decoration: const BoxDecoration(
                                color: Colors.white
                            ),
                            child: ListTile(
                                onTap: (){
                                  Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                          builder: (context) => SpecificPointMethodScreen(
                                              method: e
                                          )
                                      )
                                  );
                                },
                                leading: Column(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    crossAxisAlignment: CrossAxisAlignment.center,
                                    children: [
                                      Text(
                                          returnDay(e["date"].split(" ")[0]),
                                          textAlign: TextAlign.center,
                                          style: GoogleFonts.rubik(
                                              fontSize: 12,
                                              color: const Color(0xff6F7FAF)
                                          )
                                      ),
                                      Text(
                                          e["date"].split(" ")[0].split("-")[2],
                                          textAlign: TextAlign.center,
                                          style: GoogleFonts.rubik(
                                              fontSize: 16,
                                              fontWeight: FontWeight.w500,
                                              color: const Color(0xff0E1B42)
                                          )
                                      )
                                    ]
                                ),
                                title: Text(
                                    e["title"],
                                    overflow: TextOverflow.ellipsis,
                                    style: GoogleFonts.quicksand(
                                        fontWeight: FontWeight.bold
                                    )
                                ),
                                subtitle: Text(
                                    e["subtitle"],
                                    textAlign: TextAlign.justify,
                                    overflow: TextOverflow.ellipsis,
                                    style: GoogleFonts.quicksand()
                                ),
                                trailing: const Icon(
                                    Icons.arrow_forward_ios_rounded,
                                    size: 16
                                )
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