import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
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

    SystemChrome.setEnabledSystemUIOverlays([]);
    // SystemChrome.setEnabledSystemUIOverlays([SystemUiOverlay.top]);

    // Future<void> _fetchInitialData() async {
    //   print('fetching initial data...');
    //   // await FirebaseController.initStaffList();
    //   await FirebaseController.fetchPermanentStaffList();
    //   await FirebaseController.fetchWorkDay(Data.currentWorkDay);
    //   await FirebaseController.fetchServices();
    // }

    return FutureBuilder(

      // Initialize FlutterFire:
        future: _initialization,
        builder: (context, appSnapshot) {
          return MultiProvider(
            providers: [
            ],
            child: MaterialApp(
              debugShowCheckedModeBanner: false,
              title: "Monkey Management",
              theme: ThemeData(
                // brightness: Brightness.dark,
                primaryColor: Colors.blue,
                accentColor: Colors.blue,
                primarySwatch: Colors.blue,
                // backgroundColor: Colors.blue,
                // accentColor: Colors.amber,
                // accentColorBrightness: Brightness.dark,
                // buttonTheme: ButtonTheme.of(context).copyWith(
                //   buttonColor: Colors.amber,
                //   textTheme: ButtonTextTheme.primary,
                //   shape: RoundedRectangleBorder(
                //     borderRadius: BorderRadius.circular(20),
                //   ),
                // ),
              ),
              home:

              // SplashScreen(),

              appSnapshot.connectionState != ConnectionState.done
                  ? SplashScreen()
                  : StreamBuilder(
                  stream: FirebaseAuth.instance.authStateChanges(),
                  builder: (ctx, userSnapshot) {
                    if (userSnapshot.connectionState == ConnectionState.waiting) {
                      return SplashScreen();
                    }
                    if (userSnapshot.hasData) {
                      // print('hello');
                      return MainScreen();
                      // return FutureBuilder(
                      //   future: _fetchInitialData(),
                      //   builder: (context, snapshot) => TicketsScreen(),
                      // );
                    }
                    return SignInScreen();
                  }),
              routes: {

              },
            ),
          );
        });
  }
}
