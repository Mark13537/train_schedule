import 'package:another_flushbar/flushbar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:train_schedule/Helpers/app_constants.dart';
import 'layout_helper.dart';

void showCustomDialog(BuildContext context, String title, String message,
    Function? okPressed) async {
  showDialog(
    context: context,
    barrierDismissible: false,
    builder: (BuildContext context) {
      // return object of type Dialog

      return AlertDialog(
        shape: const RoundedRectangleBorder(
            borderRadius: BorderRadius.all(Radius.circular(10.0))),
        title: Text(
          title,
          style: const TextStyle(),
        ),
        content: Text(
          message,
          style: const TextStyle(),
        ),
        actions: <Widget>[
          TextButton(
            child: const Text('OK', style: TextStyle()),
            onPressed: () => okPressed,
          ),
        ],
      );
    },
  );
}

void showInFlushBar(BuildContext context, String value) {
  FocusScope.of(context).requestFocus(FocusNode());

  Flushbar(
    forwardAnimationCurve: Curves.fastLinearToSlowEaseIn,
    reverseAnimationCurve: Curves.fastOutSlowIn,
    animationDuration: const Duration(milliseconds: 500),
    messageText: Text(
      value,
      textAlign: TextAlign.center,
      style: TextStyle(
        color: colorPrimary,
        fontSize: LayoutHelper.instance.fontSize,
      ),
    ),
    duration: const Duration(seconds: 3),
    backgroundColor: colorWhite,
  ).show(context);
}

void showInFlushBarWithColor(BuildContext context, String value, Color color) {
  FocusScope.of(context).requestFocus(FocusNode());

  Flushbar(
    forwardAnimationCurve: Curves.fastLinearToSlowEaseIn,
    reverseAnimationCurve: Curves.fastOutSlowIn,
    animationDuration: const Duration(milliseconds: 500),
    messageText: Text(
      value,
      textAlign: TextAlign.center,
      style: TextStyle(
        color: color,
        fontSize: LayoutHelper.instance.fontSize,
      ),
    ),
    duration: const Duration(seconds: 3),
    backgroundColor: colorWhite,
  ).show(context);
}

void showLoadingDialog(BuildContext context, String title) {
  const spinkit = SpinKitPulse(
    color: Colors.white,
    size: 50.0,
    duration: Duration(milliseconds: 1000),
  );
  showDialog(
      context: context,
      barrierDismissible: false,
      builder: (_) => PopScope(
            canPop: false,
            child: Material(
              type: MaterialType.transparency,
              child: Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    spinkit,
                    Text(
                      '\n $title...',
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
