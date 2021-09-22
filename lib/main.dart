import 'package:flutter/material.dart';
import 'package:monkey_management/view/auth_view/signin_screen.dart';

import 'package:firebase_core/firebase_core.dart';
import 'package:monkey_management/view/auth_view/signup_screen.dart';
import 'package:monkey_management/view/client_view/client_screen.dart';
import 'package:monkey_management/view/store_view/store_screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        brightness: Brightness.dark,
        primaryColor: Colors.indigoAccent,
        primarySwatch: Colors.amber,
        accentColor: Colors.pinkAccent,
      ),
      initialRoute: SignInScreen.routeName,
      routes: {
        SignInScreen.routeName: (context) => SignInScreen(),
        SignUpScreen.routeName: (context) => SignUpScreen(),
        StoreScreen.routeName: (context) => StoreScreen(),
        ClientScreen.routeName: (context) => ClientScreen(),
        //ProfileScreen.routeName: (context) => ProfileScreen(),

      },
    );
  }
}




// nick testing