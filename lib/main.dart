import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:monkey_management/view/signin_screen.dart';

void main() {
  runApp(MonkeyManagement());
}

class MonkeyManagement extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      initialRoute: SignInScreen.routeName,
      routes: {
        SignInScreen.routeName: (context) => SignInScreen(),
      },
    );
  }
}
