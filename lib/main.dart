import 'package:flutter/material.dart';
import 'package:monkey_management/view/auth_view/signin_screen.dart';

import 'package:firebase_core/firebase_core.dart';
import 'package:monkey_management/view/auth_view/signup_screen.dart';
import 'package:monkey_management/view/client_view/client_general_info_screen.dart';
import 'package:monkey_management/view/client_view/client_screen.dart';

import 'package:monkey_management/view/store_view/store_edit_location_screen.dart';
//import 'package:monkey_management/view/store_view/store_edit_option_screen.dart';

import 'package:monkey_management/view/store_view/add_update_option_screen.dart';

import 'package:monkey_management/view/store_view/store_general_info_screen.dart';
import 'package:monkey_management/view/store_view/store_locations_screen.dart';
import 'package:monkey_management/view/store_view/options_screen.dart';
import 'package:monkey_management/view/store_view/store_screen.dart';
import 'package:monkey_management/view/store_view/store_settings_screen.dart';

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
        // brightness: Brightness.dark,
        primaryColor: Colors.indigoAccent,
        primarySwatch: Colors.pink,
        accentColor: Colors.pinkAccent,
        elevatedButtonTheme: ElevatedButtonThemeData(
            style: ElevatedButton.styleFrom(
          primary: Colors.blue, // background
          onPrimary: Colors.white, // foreground
          // elevation: 0.0,
          // textStyle: TextStyle(fontSize: 18.0, fontWeight: FontWeight.bold),
          shape: StadiumBorder(),
        )),
      ),
      initialRoute: SignInScreen.routeName,
      routes: {
        SignInScreen.routeName: (context) => SignInScreen(),
        SignUpScreen.routeName: (context) => SignUpScreen(),
        StoreScreen.routeName: (context) => StoreScreen(),
        ClientScreen.routeName: (context) => ClientScreen(),
        ClientGeneralInfoScreen.routeName: (context) =>
            ClientGeneralInfoScreen(),
        StoreGeneralInfoScreen.routeName: (context) => StoreGeneralInfoScreen(),
        StoreSettingsScreen.routeName: (context) => StoreSettingsScreen(),
        StoreOptionsScreen.routeName: (context) => StoreOptionsScreen(),
        AddUpdateOptionScreen.routeName: (context) => AddUpdateOptionScreen(),
        StoreLocationsScreen.routeName: (context) => StoreLocationsScreen(),
        StoreEditLocationScreen.routeName: (context) =>
            StoreEditLocationScreen(),
      },
    );
  }
}




// nick testing