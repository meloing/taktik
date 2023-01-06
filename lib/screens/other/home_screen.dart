import 'package:shimmer/shimmer.dart';
import 'package:flutter/material.dart';
import '../../services/utilities.dart';
import '../article/article_screen.dart';
import '../../services/articles_api.dart';
import '../method/point_method_screen.dart';
import '../../services/point_method_api.dart';
import 'package:social_share/social_share.dart';
import 'package:google_fonts/google_fonts.dart';
import '../article/specific_article_screen.dart';
import '../method/specific_point_method_screen.dart';
import 'package:totale_reussite/screens/other/premium_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => HomeScreenState();
}

class HomeScreenState extends State<HomeScreen> {
  List articles = [];
  List pointsMethods = [];
  bool launchGetClubs = true;
  List clubs = [
    {
      "name": "Maths",
      "icon": "maths.png"
    },
    {
      "name": "Svt",
      "icon": "svt.png"
    },
    {
      "name": "Tic",
      "icon": "tic.png"
    },
    {
      "name": "Anglais",
      "icon": "ang.png"
    },
    {
      "name": "Philosophie",
      "icon": "philo.png"
    },
    {
      "name": "Physique Chimie",
      "icon": "pc.png"
    }
  ];

  void modal(){
    showDialog(
        context: context,
        barrierDismissible: false,
        builder: (context){
          return Dialog(
              shape: const RoundedRectangleBorder(
                  borderRadius: BorderRadius.all(Radius.circular(12))
              ),
              elevation: 0,
              backgroundColor: Colors.transparent,
              insetPadding: const EdgeInsets.all(10),
              child: Container(
                  decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(12)
                  ),
                  child: Column(
                      mainAxisSize: MainAxisSize.min,
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Container(
                            constraints: BoxConstraints.loose(const Size.fromHeight(60)),
                            child: Stack(
                                alignment: Alignment.topCenter,
                                clipBehavior: Clip.none,
                                children: [
                                  Positioned(
                                      top: -50,
                                      child: Image.asset(
                                          "assets/images/new.png",
                                          width: 100,
                                          height: 100,
                                          fit: BoxFit.fill
                                      )
                                  )
                                ]
                            )
                        ),
                        Padding(
                            padding: const EdgeInsets.all(10),
                            child: Text(
                                "Les clubs seront disponibles dans la version à venir. Revenez régulièrement pour ne pas rater. Les clubs vous permettront de poser des questions et d'échanger avec les autres membres.",
                                textAlign: TextAlign.justify,
                                style: GoogleFonts.rubik(
                                    textStyle: const TextStyle(
                                        fontSize: 16
                                    )
                                )
                            )
                        ),
                        Padding(
                            padding: const EdgeInsets.all(10),
                            child: SizedBox(
                                height: 56,
                                width: double.infinity,
                                child: TextButton(
                                    style: ButtonStyle(
                                        backgroundColor: MaterialStateProperty.all<Color>(Colors.black),
                                        shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                                            RoundedRectangleBorder(
                                              borderRadius: BorderRadius.circular(10),
                                            )
                                        )
                                    ),
                                    onPressed: (){
                                      Navigator.pop(context);
                                    },
                                    child: Text(
                                        "Fermer",
                                        style: GoogleFonts.rubik(
                                            fontSize: 16,
                                            color: Colors.white,
                                            fontWeight: FontWeight.w500
                                        )
                                    )
                                )
                            )
                        )
                      ]
                  )
              )
          );
        });
  }

  String returnDay(String date){
    DateTime newDate = DateTime.parse(date);
    List weekdayName = ["Lun", "Mar", "Mer", "Jeu", "Ven", "Sam", "Dim"];
    return weekdayName[newDate.weekday-1];
  }

  Future getArticles() async{
    List values = await ArticlesOfflineRequests().getArticles(0, 3, "");
    setState(() {
      articles.addAll(values);
    });
  }

  Future getPointMethods() async{
    List values = await PointMethodOfflineRequests().getPointMethods(0, 3, "");
    setState(() {
      pointsMethods.addAll(values);
    });
  }

  Future synchronizeOnlineOfflineArticles() async{
    List updateArticles = await ArticlesOfflineRequests().synchronizeOnlineOffline();
    setState(() {
      articles.insertAll(0, updateArticles);
    });
  }

  Future synchronizeOnlineOfflinePointMethod() async{
    await PointMethodOfflineRequests().synchronizeOnlineOffline();
  }

  @override
  initState() {
    super.initState();
    getArticles();
    getPointMethods();
    synchronizeOnlineOfflineArticles();
    synchronizeOnlineOfflinePointMethod();
  }

  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    double itemWidth = (width/3)-3.5;

    return Scaffold(
        backgroundColor: const Color(0xffebe6e0),
        body: SingleChildScrollView(
          child: Column(
             crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Padding(
                    padding: const EdgeInsets.all(10),
                    child: Row(
                        children: [
                          Expanded(
                              child: Text(
                                  "Points méthodes",
                                  style: GoogleFonts.rubik(
                                      textStyle: const TextStyle(
                                          fontSize: 17,
                                          color: Color(0xff0e1b42),
                                          fontWeight: FontWeight.w500
                                      )
                                  )
                              )
                          ),
                          GestureDetector(
                              onTap: (){
                                Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) => const PointMethodScreen()
                                    )
                                );
                              },
                              child: Row(
                                  children: [
                                    Text(
                                        "Tout voir",
                                        style: GoogleFonts.rubik(
                                            fontSize: 12,
                                            color: const Color(0xff6F7FAF)
                                        )
                                    ),
                                    const Icon(
                                        Icons.arrow_drop_down_rounded,
                                        color: Color(0xffB0BAD7)
                                    )
                                  ]
                              )
                          )
                        ]
                    )
                ),
                pointsMethods.isEmpty ?
                Container(
                  color: Colors.white,
                  child: Shimmer.fromColors(
                    baseColor: Colors.grey[300]!,
                    highlightColor: Colors.grey[100]!,
                    enabled: true,
                    child: Column(
                      children: List<Widget>.generate(
                          3,
                          (int index) => ListTile(
                              leading: Container(
                                width: 37,
                                height: 40,
                                color: Colors.white,
                              ),
                              title: Container(
                                width: double.infinity,
                                height: 10,
                                color: Colors.white,
                              ),
                              subtitle: Container(
                                width: double.infinity,
                                height: 10,
                                color: Colors.white,
                              ),
                              trailing: const Icon(
                                  Icons.arrow_forward_ios_rounded,
                                  size: 16
                              )
                          )
                      ).toList()
                    )
                  )
                ) :
                Column(
                    children: pointsMethods.map(
                            (e) => Container(
                            decoration: const BoxDecoration(color: Colors.white),
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

                Padding(
                  padding: const EdgeInsets.all(10),
                  child: Row(
                      children: [
                        Expanded(
                            child: Text(
                                "Nos articles",
                                style: GoogleFonts.rubik(
                                    textStyle: const TextStyle(
                                        fontSize: 17,
                                        color: Color(0xff0e1b42),
                                        fontWeight: FontWeight.w500
                                    )
                                )
                            )
                        ),
                        GestureDetector(
                            onTap: (){
                              Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) => const ArticleScreen()
                                  )
                              );
                            },
                            child: Row(
                                children: [
                                  Text(
                                      "Tout voir",
                                      style: GoogleFonts.rubik(
                                          fontSize: 12,
                                          color: const Color(0xff6F7FAF)
                                      )
                                  ),
                                  const Icon(
                                      Icons.arrow_drop_down_rounded,
                                      color: Color(0xffB0BAD7)
                                  )
                                ]
                            )
                        )
                      ]
                  )
                ),
                articles.isEmpty ?
                Container(
                    height: 150,
                    color: Colors.white,
                    child: Shimmer.fromColors(
                        baseColor: Colors.grey[300]!,
                        highlightColor: Colors.grey[100]!,
                        enabled: true,
                        child: ListView.builder(
                          scrollDirection: Axis.horizontal,
                          itemBuilder: (_, __) => Container(
                              width: 300,
                              padding: const EdgeInsets.all(10),
                              margin: const EdgeInsets.only(right: 5),
                              decoration: const BoxDecoration(
                                  border: Border(
                                      right: BorderSide(
                                        color: Color(0xffebe6e0),
                                        width: 5,
                                      )
                                  )
                              ),
                              child: Row(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: <Widget>[
                                    Container(
                                        width: 90,
                                        height: 119,
                                        decoration: BoxDecoration(
                                          color: Colors.white,
                                          borderRadius: BorderRadius.circular(10),
                                        )
                                    ),
                                    const Padding(
                                      padding: EdgeInsets.symmetric(horizontal: 8.0),
                                    ),
                                    Expanded(
                                        child: Column(
                                            crossAxisAlignment: CrossAxisAlignment.start,
                                            children: <Widget>[
                                              const SizedBox(height: 3),
                                              Container(
                                                width: double.infinity,
                                                height: 8.0,
                                                color: Colors.white,
                                              ),
                                              const SizedBox(height: 5),
                                              SizedBox(
                                                  height: 40,
                                                  child: Container(
                                                    width: double.infinity,
                                                    height: 8.0,
                                                    color: Colors.white,
                                                  )
                                              ),
                                              const SizedBox(height: 60),
                                              Align(
                                                  alignment: Alignment.centerRight,
                                                  child: Container(
                                                      width: 70.0,
                                                      height: 8.0,
                                                      color: Colors.white
                                                  )
                                              )
                                            ]
                                        )
                                    )
                                  ]
                              )
                          ),
                          itemCount: 3
                        )
                    )
                ):
                Container(
                    height: 141,
                    color: const Color(0xffebe6e0),
                    child: ListView(
                        scrollDirection: Axis.horizontal,
                        children: articles.map(
                                (e) => Container(
                                width: 300,
                                padding: const EdgeInsets.all(5),
                                margin: const EdgeInsets.only(right: 5),
                                decoration: const BoxDecoration(color: Colors.white),
                                child: Row(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      SizedBox(
                                          width: 90,
                                          height: 119,
                                          child: Padding(
                                            padding: const EdgeInsets.only(top: 6),
                                            child: ClipRRect(
                                                borderRadius: BorderRadius.circular(10),
                                                child: Image.network(
                                                    'https://archetechnology.com/public/assets/img/infographie.png',
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
                                                    overflow: TextOverflow.ellipsis,
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
                                                    height: 58,
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
                    )
                ),

                const SizedBox(height: 15),
                Container(
                    height: 138,
                    width: double.infinity,
                    padding: const EdgeInsets.symmetric(
                        horizontal: 10,
                        vertical: 30
                    ),
                    decoration: const BoxDecoration(
                        gradient: LinearGradient(
                            colors: [
                              Color(0xff57c0f6),
                              Color(0xff18242b)
                            ],
                            begin: FractionalOffset(0.5, 0),
                            end: FractionalOffset(0.5, 1),
                            stops: [0.0, 1.0],
                            tileMode: TileMode.clamp
                        )
                    ),
                    child: Center(
                        child: Text(
                            "Debloquer des cours!",
                            textAlign: TextAlign.center,
                            style: GoogleFonts.quicksand(
                                fontSize: 30,
                                color: Colors.white,
                                fontWeight: FontWeight.bold
                            )
                        )
                    )
                ),
                Container(
                    width: double.infinity,
                    decoration: const BoxDecoration(
                        color: Colors.white
                    ),
                    padding: const EdgeInsets.all(10),
                    child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                              "Partagez et invitez vos amis !",
                              style: GoogleFonts.rubik(
                                  fontSize: 15,
                                  fontWeight: FontWeight.bold
                              )
                          ),
                          const SizedBox(height: 5),
                          Text("Invitez des amis à s'inscrire sur notre application. "
                              "Pour chaque utilisateur que vous invitez, vous débloquez des "
                              "cours gratuitement.",
                              textAlign: TextAlign.justify,
                              style: GoogleFonts.rubik(
                                  fontSize: 14
                              )
                          ),
                          const SizedBox(height: 5),
                          SizedBox(
                              width: 170,
                              child: TextButton(
                                  style: ButtonStyle(
                                      backgroundColor: MaterialStateProperty.all<Color>(const Color(0xff178DC9)),
                                      shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                                          RoundedRectangleBorder(
                                            borderRadius: BorderRadius.circular(5),
                                          )
                                      )
                                  ),
                                  onPressed: ()async{
                                    String linkMessage = await Utilities().createDynamicLink();
                                    String text = "Télécharge  l'application TakTik en cliquant sur ce lien: "
                                        "$linkMessage";
                                    SocialShare.shareOptions(text).then((data) {});
                                  },
                                  child: Text(
                                      "Inviter maintenant",
                                      style: GoogleFonts.rubik(
                                          textStyle: const TextStyle(
                                              fontSize: 15,
                                              color: Colors.white,
                                              fontWeight: FontWeight.w500
                                          )
                                      )
                                  )
                              )
                          )
                        ]
                    )
                ),
                Padding(
                    padding: const EdgeInsets.all(10),
                    child: Row(
                        children: [
                          Expanded(
                              child: Text(
                                  "Nos Clubs",
                                  style: GoogleFonts.rubik(
                                      textStyle: const TextStyle(
                                          fontSize: 17,
                                          color: Color(0xff0e1b42),
                                          fontWeight: FontWeight.w500
                                      )
                                  )
                              )
                          )
                        ]
                    )
                ),
                GestureDetector(
                  onTap: modal,
                  child: Container(
                      color: const Color(0xffebe6e0),
                      child: Wrap(
                          spacing: 5,
                          runSpacing: 5,
                          children: clubs.map(
                                  (e) => Container(
                                  width: itemWidth,
                                  padding: const EdgeInsets.all(5),
                                  decoration: const BoxDecoration(
                                      color: Colors.white
                                  ),
                                  child: Column(
                                      mainAxisAlignment: MainAxisAlignment.center,
                                      crossAxisAlignment: CrossAxisAlignment.center,
                                      children: [
                                        SizedBox(
                                            height: 60,
                                            width: 60,
                                            child: Padding(
                                                padding: const EdgeInsets.only(top: 6),
                                                child: Image.asset(
                                                    'assets/images/${e["icon"]}',
                                                    height: 60,
                                                    width: 60,
                                                    fit: BoxFit.fill
                                                )
                                            )
                                        ),
                                        const SizedBox(height: 10),
                                        Text(
                                            e["name"],
                                            textAlign: TextAlign.center,
                                            style: GoogleFonts.quicksand(
                                                textStyle: const TextStyle(
                                                    fontSize: 14,
                                                    color: Color(0xff6f7faf),
                                                    fontWeight: FontWeight.bold
                                                )
                                            )
                                        )
                                      ]
                                  )
                              )
                          ).toList()
                      )
                  )
                ),
                Align(
                  alignment: Alignment.centerRight,
                  child: TextButton(
                      onPressed: modal,
                      child: Text(
                          "Tout voir",
                          style: GoogleFonts.rubik(
                              fontSize: 12,
                              color: const Color(0xff6F7FAF)
                          )
                      )
                  )
                ),
                Container(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 10,
                        vertical: 30
                    ),
                    decoration: const BoxDecoration(
                        gradient: LinearGradient(
                            colors: [
                              Color(0xffff951a),
                              Color(0xffffd79d)
                            ],
                            begin: FractionalOffset(0.5, - 0.8),
                            end: FractionalOffset(0.5, 1),
                            stops: [0.0, 1.0],
                            tileMode: TileMode.clamp
                        )
                    ),
                    child: Row(
                        children: [
                          Expanded(
                              child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                        "Devenir premium",
                                        style: GoogleFonts.rubik(
                                            fontSize: 27,
                                            fontWeight: FontWeight.bold
                                        )
                                    ),
                                    Text(
                                        "pour avoir accès aux cours en illimité!",
                                        style: GoogleFonts.rubik(
                                            fontSize: 13
                                        )
                                    )
                                  ]
                              )
                          ),
                          SizedBox(
                              height: 42,
                              width: 104,
                              child: TextButton(
                                  style: ButtonStyle(
                                      backgroundColor: MaterialStateProperty.all<Color>(Colors.black),
                                      shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                                          RoundedRectangleBorder(
                                            borderRadius: BorderRadius.circular(10),
                                          )
                                      )
                                  ),
                                  onPressed: (){
                                    Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                            builder: (context) => const PremiumScreen()
                                        )
                                    );
                                  },
                                  child: Text(
                                      "S'abonner",
                                      style: GoogleFonts.rubik(
                                          textStyle: const TextStyle(
                                              fontSize: 16,
                                              color: Colors.white,
                                              fontWeight: FontWeight.w500
                                          )
                                      )
                                  )
                              )
                          )
                        ]
                    )
                ),
                const SizedBox(height: 15)
              ]
          )
        )
    );
  }
}