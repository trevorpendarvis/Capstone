import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class MyDialog {
  static void progessStart(BuildContext context) {
    showDialog(
        context: context,
        builder: (context) => Center(
              child: CircularProgressIndicator(),
            ));
  }

  static void progessEnd(BuildContext context) {
    Navigator.pop(context);
  }

  static void info(BuildContext context, String title, String content) {}
}
