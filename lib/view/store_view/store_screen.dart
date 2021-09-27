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
          backgroundColor: Colors.pinkAccent[400],
          automaticallyImplyLeading: false,
        ),
        body: Center(
          child: Text('This is the store screen'),
        ),
        bottomNavigationBar: BottomNavigationBar(
          currentIndex: currentIndex,
          items: [
            BottomNavigationBarItem(
                icon: Icon(Icons.home),
                label: 'Home',
                backgroundColor: Colors.blueGrey),
            BottomNavigationBarItem(
                icon: Icon(Icons.settings),
                label: 'Settings',
                backgroundColor: Colors.blueGrey),
            BottomNavigationBarItem(
                icon: Icon(Icons.exit_to_app),
                label: 'Logout',
                backgroundColor: Colors.blueGrey),
          ],
          onTap: (index) {
            render(() => currentIndex = index);
            if (index == 0) {
              //Action for homescrren
            } else if (index == 1) {
              //action for settings
              Navigator.pushNamed(context, StoreSettingsScreen.routeName);
            } else if (index == 2) {
              //action for logout
            } else {
              print('error');
            }
          },
        ),
      ),
    );
  }
}

class Controller {
  _StoreScreenState state;
  Controller(this.state);
}
