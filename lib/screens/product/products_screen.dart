import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:totale_reussite/services/product_api.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:totale_reussite/screens/product/specific_product.dart';

class ProductsScreen extends StatefulWidget {
  const ProductsScreen({super.key});

  @override
  State<ProductsScreen> createState() => ProductsScreenState();
}

class ProductsScreenState extends State<ProductsScreen> {
  int offset = 0;
  List products = [];
  bool seeMore = false;
  List updateProducts = [];
  bool launchGetProducts = true;
  bool launchSynchronizeOnlineOffline = true;
  final ScrollController _controller = ScrollController();
  TextEditingController searchController = TextEditingController();

  Future getProducts() async{
    String text = searchController.text;
    List values = await ProductOfflineRequests().getProducts(text, offset);

    setState(() {
      if(offset == 0){
        products.clear();
      }

      if(values.length == 20){
        seeMore = true;
      }
      else{
        seeMore = false;
      }

      products.addAll(values);
      launchGetProducts = false;
    });
  }

  Future synchronizeOnlineOffline() async{
    updateProducts = await ProductOfflineRequests().synchronizeOnlineOffline();
    setState(() {
      launchSynchronizeOnlineOffline = false;
    });
  }

  @override
  initState() {
    super.initState();
    getProducts();
    synchronizeOnlineOffline();
    _controller.addListener(() {
      if(_controller.position.pixels == _controller.position.maxScrollExtent){
        if(seeMore){
          offset += 20;
          getProducts();
        }
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: const Color(0xffebe6e0),
        body: SingleChildScrollView(
            controller: _controller,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
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
                                  labelText: "Recherche un produit",
                                  labelStyle: GoogleFonts.rubik(
                                      fontSize: 13,
                                      color: Colors.black
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
                      ),
                      Padding(
                          padding: const EdgeInsets.symmetric(
                            vertical: 5,
                            horizontal: 10,
                          ),
                          child: launchSynchronizeOnlineOffline ?
                          Row(
                              children: [
                                const Icon(
                                    Icons.cloud_rounded,
                                    size: 40
                                ),
                                const SizedBox(width: 10),
                                Expanded(
                                    child: Column(
                                        crossAxisAlignment: CrossAxisAlignment.start,
                                        children: const [
                                          Text("Syncronisation en cours"),
                                          SizedBox(height: 10),
                                          LinearProgressIndicator(
                                            color: Color(0xff0b65c2),
                                          )
                                        ]
                                    )
                                )
                              ]
                          ) :
                          Visibility(
                            visible: updateProducts.isNotEmpty,
                            child: GestureDetector(
                                onTap: getProducts,
                                child: Row(
                                    children: [
                                      Expanded(
                                          child: Column(
                                              crossAxisAlignment: CrossAxisAlignment.start,
                                              children: [
                                                Text(
                                                    "${updateProducts.length} nouveau produit",
                                                    style: GoogleFonts.rubik(
                                                        fontSize: 13,
                                                        fontWeight: FontWeight.bold
                                                    )
                                                ),
                                                const SizedBox(height: 5),
                                                Text(
                                                    "Cliquez sur le bouton actualiser ci-contre pour voir.",
                                                    style: GoogleFonts.rubik(
                                                        fontSize: 13,
                                                        color: Colors.grey
                                                    )
                                                ),
                                                const SizedBox(height: 3)
                                              ]
                                          )
                                      ),
                                      const SizedBox(width: 10),
                                      const Icon(Icons.refresh_rounded)
                                    ]
                                )
                            ),
                          )
                      ),
                      launchGetProducts ?
                      const Center(
                          child: CircularProgressIndicator()
                      ):
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
                      Column(
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
                                        padding: const EdgeInsets.all(5),
                                        margin: const EdgeInsets.only(bottom: 3),
                                        decoration: const BoxDecoration(
                                            color: Colors.white
                                        ),
                                        child: Row(
                                            children: [
                                              CachedNetworkImage(
                                                  imageUrl: "https://www.archetechnology.com/totale-reussite/ressources/${product["productPicture"]}",
                                                  imageBuilder: (context, imageProvider) =>
                                                      Container(
                                                          width: 55,
                                                          height: 55,
                                                          decoration: BoxDecoration(
                                                              image: DecorationImage(
                                                                  image: imageProvider,
                                                                  fit: BoxFit.cover
                                                              ),
                                                            borderRadius: BorderRadius.circular(5)
                                                          )
                                                      ),
                                                  placeholder: (context, url) => const Center(
                                                      child: SizedBox(
                                                          width: 30,
                                                          height: 30,
                                                          child: CircularProgressIndicator()
                                                      )
                                                  ),
                                                  errorWidget: (context, url, error) => const SizedBox(
                                                      width: 55,
                                                      height: 55,
                                                      child: Icon(Icons.error)
                                                  )
                                              ),
                                              const SizedBox(width: 5),
                                              Expanded(
                                                  child: Column(
                                                      crossAxisAlignment: CrossAxisAlignment.start,
                                                      children: [
                                                        Text(
                                                            product["productName"].toUpperCase(),
                                                            overflow: TextOverflow.ellipsis,
                                                            style: GoogleFonts.quicksand(
                                                                textStyle: const TextStyle(
                                                                    fontSize: 14,
                                                                    color: Colors.black,
                                                                    fontWeight: FontWeight.bold
                                                                )
                                                            )
                                                        ),
                                                        Text(
                                                            product["productPrice"],
                                                            overflow: TextOverflow.ellipsis,
                                                            style: GoogleFonts.rubik(
                                                                textStyle: const TextStyle(
                                                                    fontSize: 16,
                                                                    color: Color(0xff0b65c2),
                                                                    fontWeight: FontWeight.bold
                                                                )
                                                            )
                                                        ),
                                                        Text(
                                                            product["productPlus"],
                                                            style: GoogleFonts.rubik(
                                                              color: Colors.grey
                                                            )
                                                        )
                                                      ]
                                                  )
                                              ),
                                              const Icon(
                                                  Icons.arrow_forward_ios_rounded,
                                                  size: 16
                                              )
                                            ]
                                        )
                                    )
                                );
                              }
                          ).toList()
                      ),
                      const SizedBox(height: 10),
                      Visibility(
                          visible: seeMore,
                          child: const Center(
                            child: SizedBox(
                                width: 30,
                                height: 30,
                                child: CircularProgressIndicator(
                                    color: Color(0xff0b65c2)
                                )
                            )
                          )
                      ),
                      const SizedBox(height: 10)
                    ]
                )
              ]
          )
        )
    );
  }
}