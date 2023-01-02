import '../../services/utilities.dart';
import 'package:flutter/material.dart';
import '../other/wait_payment_screen.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:social_share/social_share.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:cached_network_image/cached_network_image.dart';

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
            elevation: 1,
            centerTitle: true,
            iconTheme: const IconThemeData(
                color: Color(0xff0b65c2)
            ),
            title: Text(
                "Anale",
                style: GoogleFonts.quicksand(
                    textStyle: const TextStyle(
                        color: Color(0xff0b65c2),
                        fontWeight: FontWeight.bold
                    )
                )
            ),
            actions: [
              IconButton(
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
                  icon: const Icon(
                    Icons.share_rounded
                  )
              )
            ],
        ),
        backgroundColor: Colors.white,
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
                                  CachedNetworkImage(
                                      imageUrl: "https://www.archetechnology.com/totale-reussite/ressources/${product["productPicture"]}",
                                      imageBuilder: (context, imageProvider) =>
                                          Container(
                                              height: 250,
                                              decoration: BoxDecoration(
                                                  borderRadius: const BorderRadius.only(
                                                      topLeft: Radius.circular(10),
                                                      topRight: Radius.circular(10)
                                                  ),
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
                                      errorWidget: (context, url, error) => const Padding(
                                          padding: EdgeInsets.all(35),
                                          child: Icon(Icons.error)
                                      )
                                  ),
                                  Positioned(
                                      top: 5,
                                      right: 5,
                                      child: Column(
                                          children: [
                                            Container(
                                              width: 70,
                                              height: 70,
                                              decoration: BoxDecoration(
                                                  color: const Color(0xffececec),
                                                  borderRadius: BorderRadius.circular(10)
                                              ),
                                              child: CachedNetworkImage(
                                                  imageUrl: "https://www.archetechnology.com/totale-reussite/ressources/${product["productPicture"]}",
                                                  imageBuilder: (context, imageProvider) =>
                                                      Container(
                                                          height: 250,
                                                          decoration: BoxDecoration(
                                                              borderRadius: BorderRadius.circular(10),
                                                              image: DecorationImage(
                                                                  image: imageProvider,
                                                                  fit: BoxFit.fill
                                                              ),
                                                              boxShadow: [
                                                                BoxShadow(
                                                                    color: Colors.grey.shade600,
                                                                    spreadRadius: 1,
                                                                    blurRadius: 15
                                                                )
                                                              ]
                                                          )
                                                      ),
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
                                              ),
                                            ),
                                            const SizedBox(height: 10),
                                            Container(
                                                width: 70,
                                                height: 70,
                                                decoration: BoxDecoration(
                                                    color: const Color(0xffececec),
                                                    borderRadius: BorderRadius.circular(10)
                                                ),
                                                child: CachedNetworkImage(
                                                    imageUrl: "https://www.archetechnology.com/totale-reussite/ressources/${product["productPicture"]}",
                                                    imageBuilder: (context, imageProvider) =>
                                                        Container(
                                                            height: 250,
                                                            decoration: BoxDecoration(
                                                                borderRadius: BorderRadius.circular(10),
                                                                image: DecorationImage(
                                                                    image: imageProvider,
                                                                    fit: BoxFit.fill
                                                                ),
                                                                boxShadow: [
                                                                  BoxShadow(
                                                                      color: Colors.grey.shade600,
                                                                      spreadRadius: 1,
                                                                      blurRadius: 15
                                                                  )
                                                                ]
                                                            )
                                                        ),
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
                                          ]
                                      )
                                  )
                                ]
                            ),
                            Container(
                                padding: const EdgeInsets.all(15),
                                child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.center,
                                    children: [
                                      Text(
                                          product["productName"].toUpperCase(),
                                          textAlign: TextAlign.center,
                                          style: GoogleFonts.quicksand(
                                              fontSize: 24,
                                              color: Colors.black,
                                              fontWeight: FontWeight.bold
                                          )
                                      ),
                                      const SizedBox(height: 10),
                                      Text(
                                          product["productPrice"],
                                          style: GoogleFonts.rubik(
                                              fontSize: 20,
                                              color: Colors.black,
                                              fontWeight: FontWeight.bold
                                          )
                                      )
                                    ]
                                )
                            ),
                            const Divider(),
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
              ),
              const Divider(
                  height: 5,
                  thickness: 3,
                  color: Color(0xffebe6e0)
              ),
              Container(
                  color: Colors.white,
                  child: Padding(
                      padding: const EdgeInsets.symmetric(
                          vertical: 10,
                          horizontal: 15
                      ),
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
                              child: const Text(
                                  "Acheter",
                                  style: TextStyle(
                                      color: Colors.white,
                                      fontWeight: FontWeight.bold
                                  )
                              )
                          )
                      )
                  )
              )
            ]
        )
    );
  }
}

