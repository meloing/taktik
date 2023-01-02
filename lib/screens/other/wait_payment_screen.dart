import 'dart:math';
import 'package:get/get.dart';
import 'package:flutter/material.dart';
import 'package:cinetpay/cinetpay.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:totale_reussite/services/local_data.dart';
import 'package:totale_reussite/services/product_api.dart';
import 'package:get/get_navigation/src/root/get_material_app.dart';

import '../../services/user_api.dart';

class WaitPaymentScreen extends StatefulWidget {
  const WaitPaymentScreen({
    super.key,
    required this.part,
    required this.value
  });

  final Map value;
  final String part;

  @override
  State<WaitPaymentScreen> createState() => WaitPaymentScreenState();
}

class WaitPaymentScreenState extends State<WaitPaymentScreen> {
  Map value = {};
  String part = "";

  Future init() async{
    String price = "";
    if(part == "product"){
      var data = await ProductOnlineRequests().getProductById(value["productId"]);
      price = data["productPrice"].split(" ")[0];
    }
    else{
      price = value["price"];
    }

    price = "100";
    final String transactionId = Random().nextInt(100000000).toString();

    await Get.to(
        CinetPayCheckout(
            title: 'Guichet de paiement',
            configData: <String, dynamic> {
              'mode': "PRODUCTION",
              'site_id': "928463",
              'apikey': "73147236563091f498f0446.67925916",
              'notify_url': "https://www.archetechnology.com/totale-reussite/add-command.php?firestoreId=${value["productId"]}&key=$transactionId",

            },
            paymentData: <String, dynamic> {
              'transaction_id': transactionId,
              'amount': price,
              'currency': 'XOF',
              'channels': 'ALL',
              'description': 'Paiement premium TAKTIK',
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
                DateTime date = DateTime.now();
                if(part == "product"){
                  String expireDate = DateTime(date.year, date.month, date.day+7).toString();
                  await ProductOfflineRequests().updateProductKey(expireDate, transactionId, value["productId"]);
                }
                else{
                  String finishDate = "";
                  if(value["type"] == "day"){
                    finishDate = DateTime(date.year, date.month, date.day+1,
                        date.hour, date.minute, date.second).toString();
                  }
                  else if(value["type"] == "month"){
                    finishDate = DateTime(date.year, date.month+1, date.day,
                        date.hour, date.minute, date.second).toString();
                  }
                  else{
                    finishDate = DateTime(date.year+1, date.month, date.day,
                        date.hour, date.minute, date.second).toString();
                  }

                  String uid = LocalData().getUid();
                  List val = await UserOnlineRequests().getUserById(uid);
                  if(val.isNotEmpty){
                    String docId = val[0]["docId"];
                    await UserOnlineRequests().addPremium(docId, "yes", finishDate);
                  }

                  LocalData().setPremium("yes");
                  LocalData().setPremiumFinish(finishDate);
                }

                if(!mounted) return;
                Navigator.pop(context, transactionId);
              },
              onError: (data) {

              })
      );
  }

  @override
  initState() {
    super.initState();
    part = widget.part;
    value = widget.value;
    WidgetsBinding.instance.addPostFrameCallback((_) { init(); });
  }

  @override
  Widget build(BuildContext context) {
    return const GetMaterialApp(
        debugShowCheckedModeBanner: false,
        home: Scaffold(
          body: Center(
            child: CircularProgressIndicator(),
          )
        )
    );
  }
}