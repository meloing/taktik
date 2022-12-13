import 'package:url_launcher/url_launcher.dart';

import '../../services/api.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class BuyProductScreen extends StatefulWidget {
  const BuyProductScreen({super.key});

  @override
  State<BuyProductScreen> createState() => BuyProductScreenState();
}

class BuyProductScreenState extends State<BuyProductScreen> {
  bool launch = false;
  List myProducts = [];

  Future getMyProducts() async{
    setState(() {
      launch = true;
    });

    List values = await LocalDatabase().getMyProducts();
    setState(() {
      myProducts.addAll(values);
    });

    setState(() {
      launch = false;
    });
  }

  @override
  initState() {
    super.initState();
    getMyProducts();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          elevation: 0,
          title: Text(
              "Vos documents",
              style: GoogleFonts.quicksand(
                fontWeight: FontWeight.bold
              )
          ),
          centerTitle: true
        ),
        backgroundColor: Colors.white,
        body: Column(
          children: [
            Expanded(
                child: ListView(
                  children: myProducts.map(
                          (e) => ListTile(
                            onTap: ()async{
                              Uri url = Uri.parse(
                                  "https://www.archetechnology.com/totale-reussite/download-document.php?"
                                      "key=${e["productBuyKey"]}"
                              );
                              if(!await launchUrl(
                                  url,
                                  mode: LaunchMode.externalApplication
                                )
                              ) {}
                            },
                            title: Text(
                                e["productName"],
                                style: GoogleFonts.quicksand(
                                  fontWeight: FontWeight.bold
                                )
                            ),
                            subtitle: Text(
                                e["productDescription"],
                                overflow: TextOverflow.ellipsis,
                                style: GoogleFonts.rubik()
                            )
                          )
                  ).toList()
                )
            ),
            Center(
                child: Text(
                    "Vos documents achétés apparaitront ici durant 7 jours, pour vous "
                        "permettre de le retélécharger",
                    textAlign: TextAlign.center,
                    style: GoogleFonts.rubik()
                )
            )
          ]
        )
    );
  }
}