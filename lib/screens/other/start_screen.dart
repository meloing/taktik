import 'nav_screen.dart';
import 'app_new_version_screen.dart';
import 'package:flutter/material.dart';
import '../../services/local_data.dart';
import 'package:totale_reussite/services/utilities.dart';
import 'package:totale_reussite/screens/user/login_screen.dart';

class StartScreen extends StatefulWidget {
  const StartScreen({super.key});

  @override
  State<StartScreen> createState() => StartScreenState();
}

class StartScreenState extends State<StartScreen> {
  void isConnected(){
    WidgetsBinding.instance.addPostFrameCallback((_)async{
      String appLocalVersion = LocalData().getAppLocalVersion();
      String appRemoteVersion = await Utilities().remoteConfigValue("appVersion");

      if(!mounted) return;
      if(appLocalVersion != appRemoteVersion){
        Navigator.push(
            context,
            MaterialPageRoute(
                builder: (context) => const AppNewVersionScreen()
            )
        );
      }
      else{
        if(LocalData().isConnected()){
          Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (context) => const NavScreen()
              )
          );
        }
        else{
          Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (context) => const LoginScreen()
              )
          );
        }
      }
    });
  }

  @override
  initState() {
    super.initState();
    isConnected();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Colors.white,
        body: Center(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Image.asset(
                  "assets/images/taktik_logo.jpeg",
                  width: 130
              ),
              const SizedBox(
                width: 0,
                child: CircularProgressIndicator(color: Colors.white)
              )
            ]
          )
        )
    );
  }
}