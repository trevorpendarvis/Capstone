import 'package:flutter/material.dart';
import 'package:monkey_management/controller/firebase_controller.dart';
import 'package:monkey_management/model/store.dart';
import 'package:monkey_management/view/client_view/add_update_appointment_screen.dart';

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
                            onTap: () => con!.handleStoreListTile(index),
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
  late Store selectedStore;
  List<Store> stores = [];
  bool isUpdated = false;

  /*
  * we should put all the fetching operations,
  * which take a lot of time to complete in this method
  */
  Future<void> fetchData() async {
    stores = await FirebaseController.fetchStores();
  }

  Future<void> profile() async {}

  Future<void> settings() async {}

  Future<void> signOut() async {}

  void handleStoreListTile(int index) {
    selectedStore = stores[index];
    Navigator.pushNamed(state.context, AddUpdateAppointmentScreen.routeName,
        arguments: {'isUpdate': isUpdated, 'store': selectedStore});
  }
}
