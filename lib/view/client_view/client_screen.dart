import 'package:flutter/material.dart';

class ClientScreen extends StatefulWidget {
  static const routeName = "/client_screen";

  const ClientScreen({Key? key}) : super(key: key);

  @override
  _ClientScreenState createState() => _ClientScreenState();
}

class _ClientScreenState extends State<ClientScreen> {
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
          title: Center(child: Text('Client Home')),
          backgroundColor: Colors.indigoAccent,
          automaticallyImplyLeading: false,
        ),
        body: Center(
          child: Text('This is the client screen'),
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
            render((index) {
              currentIndex = index;
            });
            if (index == 0) {
              //Action for homescrren
            } else if (index == 1) {
              //action for settings
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
  _ClientScreenState state;
  Controller(this.state);
}
