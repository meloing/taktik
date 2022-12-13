import 'nav_screen.dart';
import 'package:flutter/material.dart';
import '../../services/local_data.dart';
import 'package:totale_reussite/screens/user/login_screen.dart';

class StartScreen extends StatefulWidget {
  const StartScreen({super.key});

  @override
  State<StartScreen> createState() => StartScreenState();
}

class StartScreenState extends State<StartScreen> {
  void isConnected(){
    WidgetsBinding.instance.addPostFrameCallback((_){
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
    });
  }
  @override
  initState() {
    super.initState();
    isConnected();
  }

  @override
  Widget build(BuildContext context) {

    return const Scaffold(
        backgroundColor: Colors.white,
        body: Center(
          child: CircularProgressIndicator(),
        )
    );
  }
}