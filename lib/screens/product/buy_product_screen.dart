import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:totale_reussite/services/product_api.dart';

class BuyProductScreen extends StatefulWidget {
  const BuyProductScreen({super.key});

  @override
  State<BuyProductScreen> createState() => BuyProductScreenState();
}

class BuyProductScreenState extends State<BuyProductScreen> {
  bool launch = true;
  List myProducts = [];

  Future getMyProducts() async{
    List values = await ProductOfflineRequests().getMyProducts();
    setState(() {
      launch = false;
      myProducts.addAll(values);
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
            iconTheme: const IconThemeData(
                color: Color(0xff0b65c2)
            ),
            title: Text(
              "Vos documents",
                style: GoogleFonts.quicksand(
                    textStyle: const TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 18,
                        color: Color(0xff0b65c2)
                    )
                )
          ),
          centerTitle: true
        ),
        backgroundColor: Colors.grey[100],
        body: Column(
          children: [
            Expanded(
                child: launch ?
                const Center(
                  child: CircularProgressIndicator(
                    color: Color(0xff0b65c2)
                  )
                ) :
                myProducts.isEmpty ?
                Center(
                  child: Text(
                      "Aucun document",
                      style: GoogleFonts.rubik(
                        fontWeight: FontWeight.bold
                      ),
                  )
                ):
                ListView(
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
            Container(
              padding: const EdgeInsets.all(10),
              color: Colors.white,
              child: Row(
                  children: [
                    const Icon(
                        Icons.warning_rounded,
                        color: Colors.orange
                    ),
                    const SizedBox(width: 10),
                    Expanded(
                        child: Text(
                            "Vos documents achétés apparaitront ici durant 7 jours, pour vous "
                                "permettre de le retélécharger",
                            textAlign: TextAlign.justify,
                            style: GoogleFonts.rubik()
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