import 'package:flutter/material.dart';
import 'package:monkey_management/view/auth_view/signin_screen.dart';

import 'package:firebase_core/firebase_core.dart';
import 'package:provider/provider.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {


  @override
  Widget build(BuildContext context) {
    WidgetsFlutterBinding.ensureInitialized();
    final Future<FirebaseApp> _initialization = Firebase.initializeApp();


    // SystemChrome.setEnabledSystemUIOverlays([]);
    // SystemChrome.setEnabledSystemUIOverlays([SystemUiOverlay.top]);

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
      initialRoute: SignInScreen.routeName,
      routes: {
        SignInScreen.routeName: (context) => SignInScreen(),
      },
    );
  }
}
