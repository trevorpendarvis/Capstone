import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:monkey_management/controller/firebase_controller.dart';
import 'package:monkey_management/model/client.dart';
import 'package:monkey_management/model/store.dart';
import 'package:monkey_management/view/client_view/client_general_info_screen.dart';
import 'package:monkey_management/view/common_view/mydialog.dart';

class ClientScreen extends StatefulWidget {
  static const routeName = "/client_screen";

  const ClientScreen({Key? key}) : super(key: key);

  @override
  _ClientScreenState createState() => _ClientScreenState();
}

class _ClientScreenState extends State<ClientScreen> {
  int currentIndex = 0;
  Controller? con;

  //CAITLYN
  //User? user;
  //Client? clientProfile;

  @override
  void initState() {
    super.initState();
    con = Controller(this);
  }

  void render(fn) => setState(fn);

  @override
  Widget build(BuildContext context) {

    //CAITLYN
    //Map? args = ModalRoute.of(context)!.settings.arguments as Map?; //Do I need cast?
    // user ??= args!["user"];
    //clientProfile ??= args!["one_clientProfile"];


    /*
    * FutureBuilder will build something in the future
    * while future: con!.fetchData() is running in the background,
    * it displays CircularProgressIndicator() at ConnectionState.waiting
    * After done with fetching all the data, it builds the body for us
    * Therefore, we should put all the fetching operations,
    * which take a lot of time to complete in controller > fetchData()
    * */

    return FutureBuilder(
        future: con!.fetchData(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting)
            return CircularProgressIndicator();
          if (snapshot.connectionState == ConnectionState.done)
            return WillPopScope(
              onWillPop: () => Future.value(false),
              child: Scaffold(
                appBar: AppBar(
                  title: Center(child: Text('Client Home')),
                  backgroundColor: Colors.indigoAccent,
                ),
                drawer: Drawer(
                  child: ListView(
                    children: [
                      ListTile(
                        leading: Icon(Icons.people_outline),
                        title: Text("Account Settings"),
                        onTap: () => con?.accountSettings(FirebaseAuth.instance.currentUser!.uid),
                      ),
                      // ListTile(
                      //   leading: Icon(Icons.settings),
                      //   title: Text("Settings"),
                      //   onTap: con?.settings,
                      // ),
                      ListTile(
                        leading: Icon(Icons.exit_to_app),
                        title: Text("Sign Out"),
                        onTap: con?.signOut,
                      ),
                    ],
                  ),
                ),
                body: Container(
                  child: Column(
                    children: [
                      Text('List of stores'),
                      Expanded(
                        child: ListView.builder(
                          itemCount: con!.stores.length,
                          itemBuilder: (context, index) => ListTile(
                            title: Text(con!.stores[index].name),
                            subtitle: Text(con!.stores[index].email),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            );
          else
            return Text('error');
        });
  }
}

class Controller {
  _ClientScreenState state;

  Controller(this.state);

  List<Store> stores = [];

  late Client clientProfile;
  late bool isNewUser; //Do I need late? 

  /*
  * we should put all the fetching operations,
  * which take a lot of time to complete in this method
  */
  Future<void> fetchData() async {
    stores = await FirebaseController.fetchStores();
    clientProfile = await FirebaseController.getClientProfile(FirebaseAuth.instance.currentUser!.uid);
  }

  Future<void> accountSettings(String? uid) async {

    await Navigator.pushNamed(state.context, ClientGeneralInfoScreen.routeName,
        arguments: {
          // "user": state.user,
          "one_clientProfile": clientProfile,
          'isNewUser': false,
        }
      );
    Navigator.pop(state.context); //pop the drawer
    state.render(() {});
  }

  //Future<void> settings() async {}

  Future<void> signOut() async {
    try {
      await FirebaseController.signOut();
    } catch (e) {
      //do nothing
    }
    Navigator.of(state.context).pop(); //close the drawer
    Navigator.of(state.context).pop(); //pop UserHome screen
  }
}
