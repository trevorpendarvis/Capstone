import 'package:flutter/material.dart';
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
    return WillPopScope(
      onWillPop: () => Future.value(false),
      child: Scaffold(
        appBar: AppBar(
          title: Center(
              child: Text(
            'Store Home',
            style: TextStyle(color: Colors.black),
          )),
          backgroundColor: Colors.amber,
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

  Future<void> profile() async {}

  Future<void> settings() async {}

  Future<void> signOut() async {}
}
