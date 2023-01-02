import 'firebase_options.dart';
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:totale_reussite/services/api.dart';
import 'package:onesignal_flutter/onesignal_flutter.dart';
import 'package:totale_reussite/services/local_data.dart';
import 'package:totale_reussite/screens/other/start_screen.dart';
import 'package:firebase_dynamic_links/firebase_dynamic_links.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  await LocalData().init();
  await LocalDatabase().createAllTable();

  final PendingDynamicLinkData? initialLink = await FirebaseDynamicLinks.instance.getInitialLink();
  if(initialLink != null) {
    LocalData().setReferralCode(initialLink.link.path.replaceAll("/", ""));
  }

  runApp(const MyAppScreen());
}

class MyAppScreen extends StatefulWidget {
  const MyAppScreen({super.key});

  @override
  State<StatefulWidget> createState() => MyAppScreenState();
}

class MyAppScreenState extends State<MyAppScreen> {
  FirebaseDynamicLinks dynamicLinks = FirebaseDynamicLinks.instance;

  @override
  void initState() {
    super.initState();
    initDynamicLinks();
    initPlatformState();
  }

  Future<void> initDynamicLinks() async {
    dynamicLinks.onLink.listen((dynamicLinkData) async{
      LocalData().setReferralCode(dynamicLinkData.link.path.replaceAll("/", ""));
    }).onError((_) {});
  }

  Future<void> initPlatformState() async {

    OneSignal.shared.setAppId("d6cf1332-39d7-47e5-9bd8-f921a5a99d15");

    OneSignal.shared.promptUserForPushNotificationPermission().then((accepted) {});

    OneSignal.shared.setNotificationWillShowInForegroundHandler((OSNotificationReceivedEvent event) {
      event.complete(event.notification);
    });

    OneSignal.shared.setNotificationOpenedHandler((OSNotificationOpenedResult result) {});

    OneSignal.shared.setPermissionObserver((OSPermissionStateChanges changes) {});

    OneSignal.shared.setSubscriptionObserver((OSSubscriptionStateChanges changes) {});

    OneSignal.shared.setEmailSubscriptionObserver((OSEmailSubscriptionStateChanges emailChanges) {});
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        title: 'TAKTIK',
        theme: ThemeData(
            splashColor: Colors.white,
            colorScheme: const ColorScheme.light(
              primary: Colors.white
          )
        ),
        home: const StartScreen(),
        debugShowCheckedModeBanner: false
    );
  }
}