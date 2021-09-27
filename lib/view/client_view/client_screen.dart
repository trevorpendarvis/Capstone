import 'package:flutter/material.dart';
import 'package:monkey_management/controller/firebase_controller.dart';
import 'package:monkey_management/model/store.dart';

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
          if (snapshot.connectionState == ConnectionState.waiting) return CircularProgressIndicator();
          if (snapshot.connectionState == ConnectionState.done)
            return WillPopScope(
              onWillPop: () => Future.value(false),
              child: Scaffold(
                appBar: AppBar(
                  title: Center(child: Text('Client Home')),
                  backgroundColor: Colors.indigoAccent,
                  automaticallyImplyLeading: false,
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
                                ),),
                      ),
                    ],
                  ),
                ),
                bottomNavigationBar: BottomNavigationBar(
                  currentIndex: currentIndex,
                  items: [
                    BottomNavigationBarItem(icon: Icon(Icons.home), label: 'Home', backgroundColor: Colors.blueGrey),
                    BottomNavigationBarItem(
                        icon: Icon(Icons.settings), label: 'Settings', backgroundColor: Colors.blueGrey),
                    BottomNavigationBarItem(
                        icon: Icon(Icons.exit_to_app), label: 'Logout', backgroundColor: Colors.blueGrey),
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
          else
            return Text('error');
        });
  }
}

class Controller {
  _ClientScreenState state;

  Controller(this.state);

  List<Store> stores = [];

  /*
  * we should put all the fetching operations,
  * which take a lot of time to complete in this method
  */
  Future<void> fetchData() async {
    stores = await FirebaseController.fetchStores();

  }
}
