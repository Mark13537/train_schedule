import 'package:another_flushbar/flushbar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'AppConstants.dart';
import 'LayoutHelper.dart';

void showCustomDialog(BuildContext context, String title, String message,
    Function? okPressed) async {
  showDialog(
    context: context,
    barrierDismissible: false,
    builder: (BuildContext context) {
      // return object of type Dialog

      return AlertDialog(
        shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.all(Radius.circular(10.0))),
        title: new Text(
          title,
          style: TextStyle(),
        ),
        content: new Text(
          message,
          style: TextStyle(),
        ),
        actions: <Widget>[
          new TextButton(
            child: new Text("OK", style: TextStyle()),
            onPressed: () => okPressed,
          ),
        ],
      );
    },
  );
}

void showInFlushBar(BuildContext context, String value) {
  FocusScope.of(context).requestFocus(new FocusNode());

  Flushbar(
    forwardAnimationCurve: Curves.fastLinearToSlowEaseIn,
    reverseAnimationCurve: Curves.fastOutSlowIn,
    animationDuration: Duration(milliseconds: 500),
    messageText: Text(
      value,
      textAlign: TextAlign.center,
      style: TextStyle(
        color: COLOR_PRIMARY,
        fontSize: LayoutHelper.instance.fontSize,
      ),
    ),
    duration: Duration(seconds: 3),
    backgroundColor: COLOR_WHITE,
  )..show(context);
}

void showInFlushBarWithColor(BuildContext context, String value, Color color) {
  FocusScope.of(context).requestFocus(new FocusNode());

  Flushbar(
    forwardAnimationCurve: Curves.fastLinearToSlowEaseIn,
    reverseAnimationCurve: Curves.fastOutSlowIn,
    animationDuration: Duration(milliseconds: 500),
    messageText: Text(
      value,
      textAlign: TextAlign.center,
      style: TextStyle(
        color: color,
        fontSize: LayoutHelper.instance.fontSize,
      ),
    ),
    duration: Duration(seconds: 3),
    backgroundColor: COLOR_WHITE,
  )..show(context);
}

void showLoadingDialog(BuildContext context, String title) {
  final spinkit = SpinKitPulse(
    color: Colors.white,
    size: 50.0,
    duration: Duration(milliseconds: 1000),
  );
  showDialog(
      context: context,
      barrierDismissible: false,
      builder: (_) => WillPopScope(
            onWillPop: () {
              return Future.value(false);
            },
            child: Material(
              type: MaterialType.transparency,
              child: Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    spinkit,
                    Text(
                      "\n " + title + "...",
                      style: TextStyle(
                          color: Colors.white,
                          fontFamily: 'WorkSansRegular',
                          fontSize: LayoutHelper.instance.fontSize),
                    )
                  ],
                ),
              ),
            ),
          ));
}
