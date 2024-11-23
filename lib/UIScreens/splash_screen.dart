import 'dart:async';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:train_schedule/UIScreens/home_screen.dart';

import '../Helpers/layout_helper.dart';
import '../Helpers/network_helper.dart';
import '../Helpers/notification_helper.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({Key? key}) : super(key: key);

  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  bool isInternetPresent = false;
  double width = 0, height = 0;

  @override
  void initState() {
    super.initState();
    checkInternetConnection();
  }

  void goToHomeScreen() {
    Timer(const Duration(seconds: 1), () async {
      Navigator.pushReplacement(
          context, MaterialPageRoute(builder: (context) => const HomeScreen()));
    });
  }

  // TODO: Change the below code to flag checking of network instead of domain check
  void checkInternetConnection() async {
    if (!await checkInternet()) {
      showCustomDialog(
          context, 'No Internet', 'Please connect to internet to proceed.', () {
        exit(0);
      });
    } else {
      goToHomeScreen();
    }
  }

  @override
  Widget build(BuildContext context) {
    LayoutHelper();
    width = MediaQuery.of(context).size.width;
    height = MediaQuery.of(context).size.height;

    LayoutHelper.instance.width = width;
    LayoutHelper.instance.height = height;
    LayoutHelper.instance.fontSize = width < 400
        ? 16
        : (width > 400 && width < 600)
            ? 18
            : 22;
    LayoutHelper.instance.titleFontSize = width < 400
        ? 20
        : (width > 400 && width < 600)
            ? 22
            : 28;
    LayoutHelper.instance.appBarTitleSize = width < 400
        ? 32
        : (width > 400 && width < 600)
            ? 24
            : 28;

    return SafeArea(
      child: Scaffold(
        backgroundColor: Colors.white,
        body: Container(
          height: height,
          decoration: BoxDecoration(
              gradient: LinearGradient(
            colors: [Colors.blue.shade500, Colors.blue.shade900],
          )),
          child: const Stack(children: <Widget>[
            Center(
                child: Column(mainAxisSize: MainAxisSize.min, children: [
              SizedBox(height: 10.0),
              Text('Lokshakti',
                  textAlign: TextAlign.justify,
                  style: TextStyle(
                    fontSize: 30.0,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFF000000),
                  ))
            ]))
          ]),
        ),
      ),
    );
  }
}
