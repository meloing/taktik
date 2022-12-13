import 'home_screen.dart';
import '../user/profil_screen.dart';
import '../courses/cours_screen.dart';
import '../product/products_screen.dart';
import '../../services/local_data.dart';
import 'package:flutter/material.dart';
import 'package:totale_reussite/screens/topics/topics_screen.dart';

class NavScreen extends StatefulWidget {
  const NavScreen({super.key});

  @override
  State<NavScreen> createState() => NavScreenState();
}

class NavScreenState extends State<NavScreen> with TickerProviderStateMixin{
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 4, vsync: this);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
          elevation: 0,
          actions: [
            TextButton(
                onPressed: (){
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => const ProfileScreen()
                      )
                  );
                },
                child: ClipRRect(
                    borderRadius: BorderRadius.circular(100),
                    child: Image.asset(
                        'assets/images/avatar-${LocalData().getAvatar()}.png',
                        width: 50,
                        height: 50
                    )
                )
            )
          ],
          bottom: TabBar(
            controller: _tabController,
            tabs: const <Widget>[
              Tab(
                height: 40,
                text: "Home",
                iconMargin: EdgeInsets.zero,
                icon: Icon(Icons.home_rounded)
              ),
              Tab(
                  height: 40,
                  text: "Bosser",
                  iconMargin: EdgeInsets.zero,
                  icon: Icon(Icons.lightbulb_rounded)
              ),
              Tab(
                  height: 40,
                  text: "Anales",
                  iconMargin: EdgeInsets.zero,
                  icon: Icon(Icons.copy_rounded)
              ),
              Tab(
                  height: 40,
                  text: "Sujets",
                  iconMargin: EdgeInsets.zero,
                  icon: Icon(Icons.keyboard_command_key_rounded)
              )
          ]
        )
      ),
      body: TabBarView(
          physics: const NeverScrollableScrollPhysics(),
        controller: _tabController,
        children: const <Widget>[
          HomeScreen(),
          CoursesScreen(),
          ProductsScreen(),
          TopicsScreen()
        ]
      )
    );
  }
}
