import 'dart:async';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:train_schedule/UIScreens/HomeScreen.dart';

import '../Helpers/LayoutHelper.dart';
import '../Helpers/NetworkHelper.dart';
import '../Helpers/ShowNotificationHelper.dart';

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
    Timer(Duration(seconds: 1), () async {
      Navigator.pushReplacement(
          context, MaterialPageRoute(builder: (context) => HomeScreen()));
    });
  }

  void checkInternetConnection() async {
    if (!await checkInternet()) {
      showCustomDialog(
          context, "No Internet", "Please connect to internet to proceed.", () {
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
          child: Stack(children: <Widget>[
            Center(
                child: Column(mainAxisSize: MainAxisSize.min, children: [
              SizedBox(height: 10.0),
              Text("Lokshakti",
                  textAlign: TextAlign.justify,
                  style: TextStyle(
                    fontSize: 30.0,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFFF000000),
                  ))
            ]))
          ]),
        ),
      ),
    );
  }
}
