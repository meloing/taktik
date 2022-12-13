/*
import 'dart:async';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_dynamic_links/firebase_dynamic_links.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:url_launcher/url_launcher.dart';

import '../firebase_options.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  runApp(
    MaterialApp(
      title: 'Dynamic Links Example',
      routes: <String, WidgetBuilder>{
        '/': (BuildContext context) => _MainScreen(),
        '/melo': (BuildContext context) => _DynamicLinkScreen(),
      }
    )
  );
}

class _MainScreen extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => _MainScreenState();
}

class _MainScreenState extends State<_MainScreen> {
  String? _linkMessage;
  bool _isCreatingLink = false;
  FirebaseDynamicLinks dynamicLinks = FirebaseDynamicLinks.instance;

  @override
  void initState() {
    super.initState();
    initDynamicLinks();
  }

  Future<void> initDynamicLinks() async {
    dynamicLinks.onLink.listen((dynamicLinkData) {
      print(dynamicLinkData.link.path);
    }).onError((_) {});
  }

  Future<void> _createDynamicLink(String pseudo) async {
    setState(() {
      _isCreatingLink = true;
    });

    final DynamicLinkParameters parameters = DynamicLinkParameters(
      uriPrefix: 'https://archetechnology.page.link/',
      link: Uri.parse('https://archetechnology.page.link/$pseudo'),
      androidParameters: const AndroidParameters(
        packageName: 'com.archetechnology.totale_reussite',
        minimumVersion: 0,
      ),
      iosParameters: const IOSParameters(
        bundleId: 'com.archetechnology.totale_reussite',
        minimumVersion: '0'
      )
    );

    Uri url;
    final ShortDynamicLink shortLink = await dynamicLinks.buildShortLink(parameters);
    url = shortLink.shortUrl;

    setState(() {
      _linkMessage = url.toString();
      _isCreatingLink = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Material(
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Dynamic Links Example'),
        ),
        body: Builder(
          builder: (BuildContext context){
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  ButtonBar(
                    alignment: MainAxisAlignment.center,
                    children: <Widget>[
                      ElevatedButton(
                        onPressed: !_isCreatingLink ?
                            () => _createDynamicLink("kingmelo") : null,
                        child: const Text('Get Short Link')
                      )
                    ]
                  ),
                  InkWell(
                    onTap: () async {
                      if(_linkMessage != null){
                        await launchUrl(Uri.parse(_linkMessage!));
                      }
                    },
                    onLongPress: () {
                      Clipboard.setData(ClipboardData(text: _linkMessage));
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(content: Text('Copied Link!')),
                      );
                    },
                    child: Text(
                      _linkMessage ?? '',
                      style: const TextStyle(color: Colors.blue)
                    )
                  )
                ]
              )
            );
          }
        )
      )
    );
  }
}

class _DynamicLinkScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Material(
      child: Scaffold(
        appBar: AppBar(
          title: const Text('cool melo'),
        ),
        body: const Center(
          child: Text('Hello, World!'),
        ),
      ),
    );
  }
}
*/

import 'firebase_options.dart';
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:totale_reussite/services/api.dart';
import 'package:totale_reussite/services/local_data.dart';
import 'package:totale_reussite/screens/other/start_screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await LocalData().init();

  // Création des tables de la base de données locale
  await LocalDatabase().createAllTable();

  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        title: 'Flutter Demo',
        theme: ThemeData(
          primarySwatch: Colors.blue,
        ),
        home: const StartScreen(),
        debugShowCheckedModeBanner: false
    );
  }
}