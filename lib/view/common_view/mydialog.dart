import 'package:flutter/material.dart';

class MyDialog {
  static void circularProgressStart(BuildContext context) {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => Center(
        child: CircularProgressIndicator(
          strokeWidth: 10.0,
        ),
      ),
    );
  }

  static void circularProgressStop(BuildContext context) {
    Navigator.pop(context);
  }

  static void info({
    @required BuildContext? context,
    @required String? title,
    @required String? content,
  }) async {
    showDialog(
        context: context!,
        barrierDismissible: false,
        builder: (context) {
          return AlertDialog(
            title: Text(title!),
            content: Text(content!),
            actions: [
              TextButton(
                onPressed: () => Navigator.of(context).pop(),
                child: Text(
                  "OK",
                  style: Theme.of(context).textTheme.button,
                ),
              ),
            ],
          );
        });
  }

  static void DeleteInfo({
    @required BuildContext? context,
    @required String? title,
    @required String? content,
    //@required bool? collectionId,
  }) async {
    showDialog(
        context: context!,
        barrierDismissible: false,
        builder: (context) {
          return AlertDialog(
            title: Text(title!),
            content: Text(content!),
            actions: [
              TextButton(
                onPressed: () => Navigator.of(context).pop(),
                child: Text(
                  "Cancel",
                  style: Theme.of(context).textTheme.button,
                ),
              ),
              TextButton(
                onPressed: () => print("Delete Button Pressed"),
                child: Text(
                  "Delete",
                  style: Theme.of(context).textTheme.button,
                ),
              ),
            ],
          );
        });
  }
}
