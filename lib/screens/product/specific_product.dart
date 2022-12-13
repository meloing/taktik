import 'dart:math';
import 'package:get/get.dart';
import '../../services/api.dart';
import '../../services/utilities.dart';
import 'package:flutter/material.dart';
import 'package:cinetpay/cinetpay.dart';
import 'package:social_share/social_share.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:carousel_slider/carousel_slider.dart';
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
  String path = "";
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

  @override
  void initState(){
    super.initState();
    product = widget.product;
  }

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      theme: ThemeData(
          textTheme: GoogleFonts.robotoTextTheme(
              Theme.of(context).textTheme
          ),
          primarySwatch: Colors.blue
      ),
      debugShowCheckedModeBanner: false,
      home: Scaffold(
          appBar: AppBar(
              elevation: 0,
              centerTitle: true,
              backgroundColor: Colors.blue,
              iconTheme: const IconThemeData(
                  color: Colors.white
              ),
              title: Text(
                  product["productName"].toUpperCase(),
                  style: GoogleFonts.quicksand(
                      textStyle: const TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.bold
                      )
                  )
              )
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
                                            ),
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
                Container(
                    color: Colors.white,
                    child: Padding(
                        padding: const EdgeInsets.symmetric(
                            vertical: 10,
                            horizontal: 15
                        ),
                        child: Row(
                            children: [
                              Container(
                                  height: 50,
                                  decoration: BoxDecoration(
                                      color: const Color(0xfff29200),
                                      borderRadius: BorderRadius.circular(10)
                                  ),
                                  child: IconButton(
                                      icon: const Icon(
                                        Icons.share_rounded,
                                        color: Colors.white,
                                        size: 15,
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
                                      }
                                  )
                              ),
                              const SizedBox(width: 5),
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
                                            final String transactionId = Random().nextInt(100000000).toString();
                                            var response = await ManageDatabase().addCommand(product["productId"], transactionId);
                                            if(response != "error"){
                                              DateTime date = DateTime.now();
                                              String expireDate = DateTime(date.year, date.month, date.day+7).toString();

                                              LocalDatabase().updateProductKey(expireDate, transactionId, product["productId"]);
                                            }
                                            /*
                                            await Get.to(
                                                CinetPayCheckout(
                                                    title: 'Guichet de paiement',
                                                    configData: <String, dynamic> {
                                                      'apikey': "73147236563091f498f0446.67925916",
                                                      'site_id': "928463",
                                                      'notify_url': "https://www.archetechnology.com/gest_chap/controller/premium.php?key=gestchap2022@KINGMELO&uid=",
                                                      'mode': "PRODUCTION"
                                                    },
                                                    paymentData: <String, dynamic> {
                                                      'transaction_id': transactionId,
                                                      'amount': "250",
                                                      'currency': 'XOF',
                                                      'channels': 'ALL',
                                                      'description': 'Paiement premium GEST CHAP',
                                                      'customer_name':"Client",
                                                      'customer_surname':"Client",
                                                      'customer_email': "client@gmail.com",
                                                      'customer_phone_number': "0709263037",
                                                      'customer_address' : "BP 0024",
                                                      'customer_city': "Antananarivo",
                                                      'customer_country' : "CM",
                                                      'customer_state' : "CM",
                                                      'customer_zip_code' : "06510"
                                                    },
                                                    waitResponse: (data) async {
                                                      Navigator.pop(context);
                                                    },
                                                    onError: (data) {

                                                    }
                                                )
                                            );

                                             */
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
                            ]
                        )
                    )
                )
              ]
          )
      )
    );
  }
}

