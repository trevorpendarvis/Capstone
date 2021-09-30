import 'package:flutter/material.dart';
import 'package:monkey_management/controller/firebase_controller.dart';
import 'package:monkey_management/model/location.dart';
import 'package:monkey_management/view/auth_view/signin_screen.dart';
import 'package:monkey_management/view/store_view/store_settings_screen.dart';

class StoreScreen extends StatefulWidget {
  static const routeName = "/store_screen";
  const StoreScreen({Key? key}) : super(key: key);

  @override
  _StoreScreenState createState() => _StoreScreenState();
}

class _StoreScreenState extends State<StoreScreen> {
  int currentIndex = 0;
  Controller? con;

  @override
  void initState() {
    super.initState();
    con = Controller(this);
  }

  void render(fn) => setState(fn);

  @override
  Widget build(BuildContext context) {
    con!.fetchData();
    return WillPopScope(
      onWillPop: () => Future.value(false),
      child: Scaffold(
        appBar: AppBar(
          title: Center(
              child: Text(
            'Store Home',
            style: TextStyle(color: Colors.black),
          )),
          // backgroundColor: Colors.amber,

//           title: Padding(
//             padding: const EdgeInsets.only(left: 80, right: 5),
//             child: Text(
//               'Store Home',
//               style: TextStyle(color: Colors.black),
//             ),
//           ),
          backgroundColor: Colors.pinkAccent[400],
        ),
        drawer: Drawer(
          child: ListView(
            children: [
              ListTile(
                leading: Icon(Icons.people_outline),
                title: Text("Profile"),
                onTap: con?.profile,
              ),
              ListTile(
                leading: Icon(Icons.settings),
                title: Text("Settings"),
                onTap: con?.settings,
              ),
              ListTile(
                leading: Icon(Icons.exit_to_app),
                title: Text("Sign Out"),
                onTap: con?.signOut,
              ),
            ],
          ),
        ),
        body: Center(
          child: Text('This is the store screen'),
        ),
      ),
    );
  }
}

class Controller {
  _StoreScreenState state;
  Controller(this.state);
  List<Location> locations = [];

  Future<void> profile() async {}

  Future<void> settings() async {
    Navigator.pushNamed(state.context, StoreSettingsScreen.routeName, arguments: {'locations': locations});
  }

  Future<void> signOut() async {
    FirebaseController.signOut();
//     try {
//       await FirebaseController.signOut();
//     } catch (e) {
//       //do nothing
//     }
//     Navigator.of(state.context).pop(); //close the drawer
//     Navigator.of(state.context).pop(); //pop home screen
  }


  // Place for all the fectching operations.
  Future<void> fetchData() async {
    try {
      locations = await FirebaseController.fetchLocations();
    } catch (e) {
      print(e);
    }
  }
}
