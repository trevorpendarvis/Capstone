import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:monkey_management/view/auth_view/signin_screen.dart';

import 'package:firebase_core/firebase_core.dart';
import 'package:monkey_management/view/auth_view/signup_screen.dart';
import 'package:monkey_management/view/client_view/add_update_appointment_screen.dart';
import 'package:monkey_management/view/client_view/client_appointments_screen.dart';
import 'package:monkey_management/view/client_view/client_appointment_history_screen.dart';
import 'package:monkey_management/view/client_view/client_general_info_screen.dart';
import 'package:monkey_management/view/client_view/client_payment_screen.dart';
import 'package:monkey_management/view/client_view/client_screen.dart';
import 'package:monkey_management/view/client_view/store_info_screen.dart';
import 'package:monkey_management/view/common_view/loading_screen.dart';
import 'package:monkey_management/view/common_view/message_screen.dart';

import 'package:monkey_management/view/store_view/store_edit_location_screen.dart';

import 'package:monkey_management/view/store_view/add_update_option_screen.dart';

import 'package:monkey_management/view/store_view/store_general_info_screen.dart';
import 'package:monkey_management/view/store_view/store_locations_screen.dart';
import 'package:monkey_management/view/store_view/options_screen.dart';
import 'package:monkey_management/view/store_view/store_screen.dart';
import 'package:monkey_management/view/store_view/store_settings_screen.dart';

import 'controller/firebase_controller.dart';
import 'model/data.dart';

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
      home: StreamBuilder(
          stream: FirebaseAuth.instance.authStateChanges(),
          builder: (ctx, userSnapshot) {
            if (userSnapshot.connectionState == ConnectionState.waiting) {
              return LoadingScreen();
            }
            if (userSnapshot.hasData) {
              return FutureBuilder(
                  future: FirebaseController.getAccountType(),
                  builder: (context,
                      AsyncSnapshot<AccountType> asyncSnapshotAccountType) {
                    if (asyncSnapshotAccountType.connectionState ==
                        ConnectionState.waiting)
                      return LoadingScreen();
                    else {
                      if (asyncSnapshotAccountType.data == AccountType.STORE) {
                        return StoreScreen();
                      } else if (asyncSnapshotAccountType.data ==
                          AccountType.CLIENT) {
                        return ClientScreen();
                      } else {
                        print('error');
                      }
                    }
                    return LoadingScreen();
                  });
            }
            return SignInScreen();
          }),
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
        // StoreEditOptionScreen.routeName: (context) => StoreEditOptionScreen(),
        AddUpdateOptionScreen.routeName: (context) => AddUpdateOptionScreen(),
        StoreLocationsScreen.routeName: (context) => StoreLocationsScreen(),
        StoreEditLocationScreen.routeName: (context) =>
            StoreEditLocationScreen(),
        StoreInfoScreen.routeName: (context) => StoreInfoScreen(),
        ClientAppointmentsScreen.routeName: (context) => ClientAppointmentsScreen(),
        ClientAppointmentHistoryScreen.routeName: (context) => ClientAppointmentHistoryScreen(),
        AddUpdateAppointmentScreen.routeName: (context) =>
            AddUpdateAppointmentScreen(),
        MessageScreen.routeName: (context) => MessageScreen(),
        ClientPaymentScreen.routeName: (context) => ClientPaymentScreen(),
      },
    );
  }
}




// nick testing