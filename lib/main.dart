import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:monkey_management/view/auth_view/auth_screen.dart';
import 'package:monkey_management/view/main_screen.dart';
import 'package:monkey_management/view/auth_view/signin_screen.dart';
import 'package:monkey_management/view/splash_screen.dart';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:provider/provider.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {


  @override
  Widget build(BuildContext context) {
    final Future<FirebaseApp> _initialization = Firebase.initializeApp();

    // SystemChrome.setEnabledSystemUIOverlays([]);
    // SystemChrome.setEnabledSystemUIOverlays([SystemUiOverlay.top]);

    return FutureBuilder(
        future: _initialization,
        builder: (context, appSnapshot) {
          return MaterialApp(
            debugShowCheckedModeBanner: false,
            theme: ThemeData(
              // brightness: Brightness.dark,
              primaryColor: Colors.indigoAccent,
              accentColor: Colors.amber,
              primarySwatch: Colors.green,
              backgroundColor: Colors.pinkAccent,
              // accentColorBrightness: Brightness.dark,
              // buttonTheme: ButtonTheme.of(context).copyWith(
              //   buttonColor: Colors.amber,
              //   textTheme: ButtonTextTheme.primary,
              //   shape: RoundedRectangleBorder(
              //     borderRadius: BorderRadius.circular(20),
              //   ),
              // ),
            ),
            title: "Monkey Management",
            home: appSnapshot.connectionState != ConnectionState.done
                ? SplashScreen()
                : StreamBuilder(
                    stream: FirebaseAuth.instance.authStateChanges(),
                    builder: (ctx, userSnapshot) {
                      if (userSnapshot.connectionState == ConnectionState.waiting) {
                        return SplashScreen();
                      }
                      if (userSnapshot.hasData) {
                        return MainScreen();
                      }
                      return AuthScreen();
                    }),
            routes: {},
          );
        });
  }
}
