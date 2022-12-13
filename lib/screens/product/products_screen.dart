import '../../services/api.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:flutter_parsed_text/flutter_parsed_text.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:totale_reussite/screens/product/specific_product.dart';

import 'buy_product_screen.dart';

class ProductsScreen extends StatefulWidget {
  const ProductsScreen({super.key});

  @override
  State<ProductsScreen> createState() => ProductsScreenState();
}

class ProductsScreenState extends State<ProductsScreen> {
  List products = [];
  bool launchGetProducts = true;
  TextEditingController searchController = TextEditingController();

  Future addOrUpdateProduct(List values) async{
    // add or update course in local database

    for(Map value in values){
      List competition = await LocalDatabase().getProductById(value["productId"]);
      if(competition.isEmpty){
        await LocalDatabase().addProduct(
            value["productId"],
            value["productName"],
            value["productDescription"],
            value["productPicture"],
            value["productPlus"],
            value["productPrice"],
            value["productSubjects"],
            value["productDate"]
        );
      }
      else{
        await LocalDatabase().updateProduct(
            value["productId"],
            value["productName"],
            value["productDescription"],
            value["productPicture"],
            value["productPlus"],
            value["productPrice"],
            value["productSubjects"],
            value["productDate"]
        );
      }
    }
  }

  Future getProducts() async{
    late List values;
    String lastDate = "";
    String text = searchController.text;

    // Récupération de la dernière date de cours
    List val = await LocalDatabase().getLastProductDate();
    if(val.isNotEmpty){
      lastDate = val[0]["productDate"];
    }

    values = await LocalDatabase().getProducts(text);
    if(values.isEmpty){
      values = await ManageDatabase().getProducts(lastDate);
      await addOrUpdateProduct(values);
    }

    setState(() {
      products.addAll(values);
      launchGetProducts = false;
    });

    // Mise à jour des produits
    values = await ManageDatabase().getProducts(lastDate);
    await addOrUpdateProduct(values);
  }

  @override
  initState() {
    super.initState();
    getProducts();
  }

  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    double size = (width/2)-10;

    return Scaffold(
        backgroundColor: Colors.grey[200],
        body: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              const SizedBox(height: 10),
              Expanded(
                  child: launchGetProducts ?
                  const Center(child: CircularProgressIndicator()):
                  products.isEmpty ?
                  Center(
                      child: Text(
                          "Aucun produit trouvé",
                          style: GoogleFonts.rubik(
                              textStyle: const TextStyle(
                                  fontWeight: FontWeight.bold
                              )
                          )
                      )
                  ):
                  SingleChildScrollView(
                    child: Wrap(
                        spacing: 10,
                        children: products.map(
                                (product){
                              return GestureDetector(
                                  onTap: (){
                                    Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                            builder: (context) => SpecificProductScreen(
                                                product: product
                                            )
                                        )
                                    );
                                  },
                                  child: Container(
                                      width: size,
                                      decoration: BoxDecoration(
                                          color: Colors.white,
                                          borderRadius: BorderRadius.circular(10)
                                      ),
                                      margin: const EdgeInsets.only(bottom: 10),
                                      child: Column(
                                          crossAxisAlignment: CrossAxisAlignment.center,
                                          children: [
                                            Stack(
                                                children: [
                                                  SizedBox(
                                                      width: double.infinity,
                                                      height: 130,
                                                      child: CachedNetworkImage(
                                                          imageUrl: "https://www.archetechnology.com/totale-reussite/ressources/${product["productPicture"]}",
                                                          imageBuilder: (context, imageProvider) =>
                                                              Container(
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
                                                      )
                                                  ),
                                                  Positioned(
                                                      top: 0,
                                                      right: 0,
                                                      child: Container(
                                                          width: 80,
                                                          padding: const EdgeInsets.all(5),
                                                          decoration: BoxDecoration(
                                                              color: Colors.orange,
                                                              borderRadius: BorderRadius.circular(10),
                                                          ),
                                                          child: Text(
                                                              product["productPlus"].toLowerCase(),
                                                              overflow: TextOverflow.ellipsis,
                                                              textAlign: TextAlign.center,
                                                              style: GoogleFonts.quicksand(
                                                                  textStyle: const TextStyle(
                                                                      fontSize: 16,
                                                                      color: Colors.white
                                                                  )
                                                              )
                                                          )
                                                      )
                                                  )
                                                ]
                                            ),
                                            const SizedBox(height: 10),
                                            Text(
                                                product["productName"].toUpperCase(),
                                                textAlign: TextAlign.center,
                                                overflow: TextOverflow.ellipsis,
                                                style: GoogleFonts.rubik(
                                                    textStyle: const TextStyle(
                                                        fontSize: 14,
                                                        color: Colors.blue,
                                                        fontWeight: FontWeight.bold
                                                    )
                                                )
                                            ),
                                            const SizedBox(height: 5),
                                            Text(
                                                product["productPrice"],
                                                overflow: TextOverflow.ellipsis,
                                                style: GoogleFonts.rubik(
                                                    textStyle: const TextStyle(
                                                        fontSize: 16,
                                                        color: Color(0xff0e1b42),
                                                        fontWeight: FontWeight.bold
                                                    )
                                                )
                                            ),
                                            const SizedBox(height: 10)
                                          ]
                                      )
                                  )
                              );
                            }
                        ).toList()
                    )
                  )
              ),
              Container(
                  color: Colors.white,
                  padding: const EdgeInsets.all(2),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Expanded(
                        child: SizedBox(
                            height: 44,
                            child: TextField(
                                controller: searchController,
                                decoration: InputDecoration(
                                    filled: true,
                                    fillColor: Colors.transparent,
                                    prefixIcon: const Icon(Icons.search_rounded),
                                    border: const OutlineInputBorder(
                                        borderSide: BorderSide(color: Colors.transparent)
                                    ),
                                    labelText: "Recherche un produit",
                                    labelStyle: GoogleFonts.rubik(
                                        fontSize: 13
                                    )
                                ),
                                onChanged: (value){
                                  setState(() {
                                    products.clear();
                                    launchGetProducts = true;
                                  });
                                  getProducts();
                                }
                            )
                        )
                      ),
                      const SizedBox(width: 3),
                      GestureDetector(
                        onTap: (){
                          Navigator.of(context).push(
                              MaterialPageRoute(
                                  builder: (context) => const BuyProductScreen()
                              )
                          );
                        },
                        child: const Icon(
                            Icons.download_for_offline_rounded,
                            size: 55,
                            color: Colors.orange
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