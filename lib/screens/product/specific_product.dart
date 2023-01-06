import '../../services/utilities.dart';
import 'package:flutter/material.dart';
import '../other/wait_payment_screen.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:social_share/social_share.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';

class SpecificProductScreen extends StatefulWidget {
  const SpecificProductScreen({
    Key? key,
    required this.product
  }) : super(key: key);

  final Map product;

  @override
  SpecificProductScreenState createState() => SpecificProductScreenState();
}

class SpecificProductScreenState extends State<SpecificProductScreen> {
  String key = "";
  late Map product;
  bool launch = false;
  bool existFile = false;
  bool launchButton = false;
  bool activeEnPapier = false;
  List temoignages = [
    {
      "icon": "2",
      "name": "Loukou",
      "message": "J'ai pu télécharger mon document, je vous le recommande."
    },
    {
      "icon": "1",
      "name": "Desirée",
      "message": "Rapide et fiable."
    },
    {
      "icon": "3",
      "name": "Ouattara",
      "message": "Merci."
    },
    {
      "icon": "4",
      "name": "Emmanuelle",
      "message": "C'est super."
    },
    {
      "icon": "7",
      "name": "Dexter",
      "message": "Merci pour les documents de qualités."
    }
  ];

  void successModal(){
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
                                      top: -45,
                                      child: Image.asset(
                                          "assets/images/success.png",
                                          width: 100,
                                          height: 100,
                                          fit: BoxFit.fill
                                      )
                                  )
                                ]
                            )
                        ),
                        const SizedBox(height: 10),
                        Text(
                            "Félicitations !!!",
                            style: GoogleFonts.rubik(
                                fontSize: 18,
                                fontWeight: FontWeight.bold
                            )
                        ),
                        const SizedBox(height: 20),
                        Text(""" Merci de nous avoir choisi, votre document à été acheter avec succès. Veuillez cliquer sur le bouton ouvrir le lien de téléchargement pour le télécharger. """,
                            textAlign: TextAlign.center,
                            style: GoogleFonts.rubik(
                                fontSize: 14
                            )
                        ),
                        const SizedBox(height: 30),
                        Padding(
                            padding: const EdgeInsets.all(10),
                            child: SizedBox(
                                height: 56,
                                width: double.infinity,
                                child: TextButton(
                                    style: ButtonStyle(
                                        backgroundColor: MaterialStateProperty.all<Color>(Colors.blue),
                                        shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                                            RoundedRectangleBorder(
                                              borderRadius: BorderRadius.circular(10),
                                            )
                                        )
                                    ),
                                    onPressed: ()async{
                                      Navigator.pop(context);
                                      Uri url = Uri.parse(
                                          "https://www.archetechnology.com/totale-reussite/download-document.php?"
                                              "key=$key"
                                      );
                                      if(!await launchUrl(
                                        url,
                                        mode: LaunchMode.externalApplication)
                                      ) {}
                                    },
                                    child: Text(
                                        "Ouvrir le lien de téléchargement",
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
                        )
                      ]
                  )
              )
          );
        });
  }

  @override
  void initState(){
    super.initState();
    product = widget.product;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
            elevation: 0,
            centerTitle: true,
            iconTheme: const IconThemeData(
                color: Colors.white
            ),
            title: Text(
                "Anale",
                style: GoogleFonts.quicksand(
                    textStyle: const TextStyle(
                        fontWeight: FontWeight.bold
                    )
                )
            ),
            flexibleSpace: Container(
                decoration: const BoxDecoration(
                    gradient: LinearGradient(
                        colors: [
                          Colors.black38,
                          Colors.black38,
                        ],
                        begin: FractionalOffset(1.0, 1.0),
                        end: FractionalOffset(0.0, 1),
                        stops: [0,  1],
                        tileMode: TileMode.clamp
                    )
                )
            ),
        ),
        backgroundColor: Colors.grey[200],
        body: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                  child: SingleChildScrollView(
                      child: Column(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Stack(
                              children: [
                                Container(
                                    height: 210,
                                    width: double.infinity,
                                    decoration: BoxDecoration(
                                      image: DecorationImage(
                                          image: NetworkImage("https://www.archetechnology.com/totale-reussite/ressources/${product["productPicture"]}"),
                                          fit: BoxFit.cover
                                      ),
                                    ),
                                    child: Container(
                                        decoration: const BoxDecoration(
                                            gradient: LinearGradient(
                                                colors: [
                                                  Colors.black38,
                                                  Colors.black38,
                                                ],
                                                begin: FractionalOffset(1.0, 1.0),
                                                end: FractionalOffset(0.0, 1),
                                                stops: [0,  1],
                                                tileMode: TileMode.clamp
                                            )
                                        )
                                    )
                                ),
                                Container(
                                    margin: const EdgeInsets.only(top: 200),
                                    decoration: const BoxDecoration(
                                        color: Colors.white,
                                        borderRadius: BorderRadius.only(
                                          topLeft: Radius.circular(15),
                                          topRight: Radius.circular(15),
                                        )
                                    ),
                                    child: Column(
                                        crossAxisAlignment: CrossAxisAlignment.start,
                                        children: [
                                          const SizedBox(height: 5),
                                          Center(
                                            child: Container(
                                              height: 5,
                                              width: 30,
                                              decoration: BoxDecoration(
                                                color: Colors.grey,
                                               borderRadius: BorderRadius.circular(10)
                                              )
                                            )
                                          ),
                                          const SizedBox(height: 10),
                                          Padding(
                                            padding: const EdgeInsets.all(10),
                                            child: Column(
                                                crossAxisAlignment: CrossAxisAlignment.start,
                                                children: [
                                                  Row(
                                                      children: [
                                                        Expanded(
                                                            child: Text(
                                                                product["productName"].toUpperCase(),
                                                                style: GoogleFonts.quicksand(
                                                                    fontSize: 20,
                                                                    color: Colors.black,
                                                                    fontWeight: FontWeight.bold
                                                                )
                                                            )
                                                        ),
                                                        const Icon(
                                                          Icons.verified_rounded,
                                                          color: Colors.green,
                                                        )
                                                      ]
                                                  ),
                                                  const SizedBox(height: 5),
                                                  Text(
                                                      product["productPrice"],
                                                      style: GoogleFonts.rubik(
                                                          fontSize: 20,
                                                          color: Colors.grey
                                                      )
                                                  ),
                                                  const SizedBox(height: 5),
                                                  RatingBar.builder(
                                                      initialRating: 4.5,
                                                      minRating: 1,
                                                      itemSize: 15,
                                                      glow: false,
                                                      direction: Axis.horizontal,
                                                      allowHalfRating: false,
                                                      itemCount: 5,
                                                      itemBuilder: (context, _) => const Icon(
                                                          Icons.star,
                                                          color: Colors.amber
                                                      ),
                                                      onRatingUpdate: (_) {}
                                                  ),
                                                  const SizedBox(height: 20),
                                                  Row(
                                                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                    children: [
                                                      Row(
                                                          children: [
                                                            const Icon(
                                                                Icons.bookmark_border_rounded,
                                                                color: Colors.black,
                                                                size: 20
                                                            ),
                                                            const SizedBox(width: 2),
                                                            Text(
                                                                product["productPlus"],
                                                                style: GoogleFonts.rubik(
                                                                    color: Colors.grey
                                                                )
                                                            )
                                                          ]
                                                      ),
                                                      Row(
                                                          children: [
                                                            const Icon(
                                                                Icons.subject_rounded,
                                                                color: Colors.grey,
                                                                size: 20
                                                            ),
                                                            const SizedBox(width: 2),
                                                            Text(
                                                                product["productSubjects"],
                                                                style: GoogleFonts.rubik(
                                                                    color: Colors.grey
                                                                )
                                                            )
                                                          ]
                                                      )
                                                    ],
                                                  ),
                                                  const SizedBox(height: 20),
                                                  Row(
                                                      children: [
                                                        Expanded(
                                                            child: GestureDetector(
                                                                onTap: (){},
                                                                child: Column(
                                                                  crossAxisAlignment: CrossAxisAlignment.center,
                                                                  children: [
                                                                    Text(
                                                                        "DETAILS",
                                                                        style: GoogleFonts.rubik(
                                                                            color: const Color(0xff0b65c2),
                                                                            fontWeight: FontWeight.w500
                                                                        )
                                                                    ),
                                                                    const SizedBox(height: 5),
                                                                    Container(
                                                                      height: 3,
                                                                      decoration: BoxDecoration(
                                                                          color: const Color(0xff0b65c2),
                                                                          borderRadius: BorderRadius.circular(10)
                                                                      ),
                                                                    )
                                                                  ],
                                                                )
                                                            )
                                                        ),
                                                        const SizedBox(width: 5),
                                                        Expanded(
                                                            child: GestureDetector(
                                                                onTap: (){},
                                                                child: Column(
                                                                  crossAxisAlignment: CrossAxisAlignment.center,
                                                                  children: [
                                                                    Text(
                                                                        "PHOTOS",
                                                                        style: GoogleFonts.rubik(
                                                                            color: const Color(0xff0b65c2),
                                                                            fontWeight: FontWeight.w500
                                                                        )
                                                                    ),
                                                                    const SizedBox(height: 5),
                                                                    Container(
                                                                      height: 3,
                                                                      decoration: BoxDecoration(
                                                                          color: const Color(0xff0b65c2),
                                                                          borderRadius: BorderRadius.circular(10)
                                                                      ),
                                                                    )
                                                                  ],
                                                                )
                                                            )
                                                        ),
                                                        const SizedBox(width: 5),
                                                        Expanded(
                                                            child: GestureDetector(
                                                                onTap: (){},
                                                                child: Column(
                                                                  crossAxisAlignment: CrossAxisAlignment.center,
                                                                  children: [
                                                                    Text(
                                                                        "COMMENTAIRES",
                                                                        style: GoogleFonts.rubik(
                                                                            color: const Color(0xff0b65c2),
                                                                            fontWeight: FontWeight.w500
                                                                        )
                                                                    ),
                                                                    const SizedBox(height: 5),
                                                                    Container(
                                                                      height: 3,
                                                                      decoration: BoxDecoration(
                                                                          color: const Color(0xff0b65c2),
                                                                          borderRadius: BorderRadius.circular(10)
                                                                      ),
                                                                    )
                                                                  ],
                                                                )
                                                            )
                                                        )
                                                      ]
                                                  )
                                                ]
                                            ),
                                          ),
                                          const Divider(height: 10, thickness: 5),
                                          MarkDown().body(
                                              product["productDescription"]
                                          ),
                                          Padding(
                                              padding: const EdgeInsets.all(10),
                                              child: Text("Cliquez sur le bouton acheter ci-dessous pour "
                                                  "vous en procurer. Une fois le paiement effectué, "
                                                  "vous recevrez le lien de téléchargement du document.",
                                                  textAlign: TextAlign.justify,
                                                  style: GoogleFonts.rubik(
                                                      fontSize: 16
                                                  )
                                              )
                                          ),
                                          const Divider(height: 50),
                                          Text(
                                              "COMMENTAIRES",
                                              style: GoogleFonts.quicksand(
                                                  color: Colors.black,
                                                  fontWeight: FontWeight.bold
                                              )
                                          ),
                                          const SizedBox(height: 10),
                                          Column(
                                              children: temoignages.map(
                                                      (e) => Container(
                                                      margin: const EdgeInsets.only(bottom: 5),
                                                      color: Colors.white,
                                                      child: ListTile(
                                                          leading: ClipRRect(
                                                              borderRadius: BorderRadius.circular(100),
                                                              child: Image.asset(
                                                                  'assets/images/avatar-${e["icon"]}.png',
                                                                  width: 50,
                                                                  height: 50
                                                              )
                                                          ),
                                                          title: Text(
                                                              e["name"],
                                                              style: GoogleFonts.quicksand(
                                                                  fontSize: 16,
                                                                  fontWeight: FontWeight.bold
                                                              )
                                                          ),
                                                          subtitle: Text(
                                                              e["message"],
                                                              style: GoogleFonts.rubik(
                                                                  fontSize: 14
                                                              )
                                                          )
                                                      )
                                                  )
                                              ).toList()
                                          ),
                                          const SizedBox(height: 20)
                                        ]
                                    )
                                )
                              ]
                            )
                          ]
                      )
                  )
              ),
              Container(
                  color: Colors.white,
                  child: Padding(
                      padding: const EdgeInsets.symmetric(
                          vertical: 10,
                          horizontal: 15
                      ),
                      child: Row(
                        children: [
                          Expanded(
                            child: SizedBox(
                                width: double.infinity,
                                height: 50,
                                child: TextButton(
                                    style: ButtonStyle(
                                        backgroundColor: MaterialStateProperty.all<Color>(const Color(0xff1f71ba)),
                                        shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                                            RoundedRectangleBorder(
                                                borderRadius: BorderRadius.circular(10)
                                            )
                                        )
                                    ),
                                    onPressed: ()async{
                                      var value = await Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                              builder: (context) => WaitPaymentScreen(
                                                  part: 'product',
                                                  value: product
                                              )
                                          )
                                      );

                                      if(value != null){
                                        key = value;
                                        successModal();
                                      }
                                    },
                                    child: Text(
                                        "Acheter",
                                        style: TextStyle(
                                            color: Colors.white,
                                            fontWeight: FontWeight.bold
              !                          )
                                    )
                                )
                            )
                          ),
                          const SizedBox(width: 10),
                          SizedBox(
                              width: 50,
                              height: 50,
                              child: TextButton(
                                style: ButtonStyle(
                                    backgroundColor: MaterialStateProperty.all<Color>(Colors.grey[200]!),
                                    shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                                        RoundedRectangleBorder(
                                            borderRadius: BorderRadius.circular(10)
                                        )
                                    )
                                ),
                                onPressed: (){
                                  String ad = "Tu prépares un concours, un examen, "
                                      "Télécharge  l'application prepa reussite en cliquant sur ce lien: "
                                      "https://play.google.com/store/apps/details?id=com.archetechnology.prepa_reussite "
                                      " pour une préparation en ligne efficace, anciens sujets et corrigés disponible, les informations "
                                      "pour postuler au concours disponible.";
                                  String id = product["productId"].toString();
                                  String name = product["productName"].replaceAll(" ", "-");
                                  String text = product["productName"] + " \nCliquez sur le lien ci-dessous pour vous en procurer. \n"
                                      "https://totale-reussite.com/products/product-view/"+
                                      id+"/"+name+"\n\n"+ad;
                                  SocialShare.shareOptions(text).then((data) {});
                                },
                                child: const Icon(
                                    Icons.share_rounded,
                                    color: Color(0xff1f71ba)
                                )
                            )
                          ),
                          const SizedBox(width: 10),
                          SizedBox(
                              width: 50,
                              height: 50,
                              child: TextButton(
                                  style: ButtonStyle(
                                      backgroundColor: MaterialStateProperty.all<Color>(Colors.grey[200]!),
                                      shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                                          RoundedRectangleBorder(
                                              borderRadius: BorderRadius.circular(10)
                                          )
                                      )
                                  ),
                                  onPressed: (){
                                  },
                                  child: const Icon(
                                      Icons.bookmark_border_rounded,
                                      color: Color(0xff1f71ba)
                                  )
                              )
                          )
                        ]
                      )
                  )
              )
            ]
        )
    );
  }
}

