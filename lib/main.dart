import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'Helpers/flavou_config.dart';
import 'UIScreens/splash_screen.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  FlavorConfig(
      flavor: Flavor.dev,
      // ignore: prefer_single_quotes
      appVersion: '1.0.0',
      color: Colors.cyan,
      versionCode: 1);
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
      DeviceOrientation.portraitDown,
    ]);

    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Lokshakti',
      theme: ThemeData(
        primarySwatch: Colors.cyan,
      ),
      home: const SplashScreen(),
    );
  }
}
