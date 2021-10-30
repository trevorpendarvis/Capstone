import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:monkey_management/controller/firebase_controller.dart';
import 'package:monkey_management/model/appointment.dart';
import 'package:monkey_management/model/client.dart';
import 'package:monkey_management/model/store.dart';
import 'package:monkey_management/view/client_view/client_appointment_history_screen.dart';
import 'package:monkey_management/view/client_view/client_appointments_screen.dart';
import 'package:monkey_management/view/client_view/client_general_info_screen.dart';
import 'package:monkey_management/view/client_view/store_info_screen.dart';
import 'package:monkey_management/view/common_view/loading_screen.dart';
import 'package:monkey_management/view/common_view/message_screen.dart';
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
          if (snapshot.connectionState == ConnectionState.waiting) return LoadingScreen();
          if (snapshot.connectionState == ConnectionState.done)
            return WillPopScope(
              onWillPop: () => Future.value(false),
              child: Scaffold(
                appBar: AppBar(
                  title: Text('Home'),
                  backgroundColor: Colors.indigoAccent,
                  actions: [
                    StreamBuilder<QuerySnapshot<Map<String, dynamic>>>(
                        stream: FirebaseController.appointmentsStreamForClient(),
                        builder: (BuildContext context,
                            AsyncSnapshot<QuerySnapshot<Map<String, dynamic>>> appointmentsStreamSnapshot) {
                          if (appointmentsStreamSnapshot.connectionState == ConnectionState.waiting) {
                            return Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: ElevatedButton(
                                style: ButtonStyle(
                                  backgroundColor: MaterialStateProperty.all(Colors.white),
                                  foregroundColor: MaterialStateProperty.all(Colors.indigo),
                                  textStyle: MaterialStateProperty.all(
                                    TextStyle(color: Colors.indigo, fontWeight: FontWeight.bold),
                                  ),
                                ),
                                onPressed: () => con!.handleMyAppointmentButton(),
                                child: Text('... appointment'),
                              ),
                            );
                          }

                          if (appointmentsStreamSnapshot.hasData) {
                            int numOfAppointments = appointmentsStreamSnapshot.data!.docs.length;
                            return Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: ElevatedButton(
                                style: ButtonStyle(
                                  backgroundColor: MaterialStateProperty.all(Colors.white),
                                  foregroundColor: MaterialStateProperty.all(Colors.indigo),
                                  textStyle: MaterialStateProperty.all(
                                    TextStyle(color: Colors.indigo, fontWeight: FontWeight.bold),
                                  ),
                                ),
                                onPressed: () => con!.handleMyAppointmentButton(),
                                child: Row(
                                  children: [
                                    Stack(
                                      children: [
                                        Icon(
                                          Icons.circle,
                                          color: numOfAppointments > 0 ? Colors.deepOrange : null,
                                          size: 25,
                                        ),
                                        Container(
                                          margin: EdgeInsets.only(top: 4.0, left: 8.0),
                                          child: Text(
                                            '$numOfAppointments',
                                            style: TextStyle(color: Colors.white),
                                          ),
                                        ),
                                      ],
                                    ),
                                    Text(' appointment'),
                                  ],
                                ),
                              ),
                            );
                          }

                          print(appointmentsStreamSnapshot.error);
                          return Text('error');
                        }),
                  ],
                ),
                drawer: Drawer(
                  child: ListView(
                    children: [
                      DrawerHeader(
                        child: Container(
                          width: 500.0,
                          height: 10.0,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            color: Colors.blue[300],
                            image: DecorationImage(
                              image: AssetImage("assets/images/MonkeyLogo.png"),
                              fit: BoxFit.fitHeight,
                            ),
                          ),
                        ),
                      ),
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
                        leading: Icon(Icons.calendar_today),
                        title: Text("Past Appointments"),
                        onTap: () => con!.appointmentHistory(),
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
                            itemBuilder: (context, index) => GestureDetector(
                                  child: Container(
                                    // shape: RoundedRectangleBorder(
                                    //   borderRadius: BorderRadius.circular(15),
                                    // ),
                                    decoration: BoxDecoration(
                                      color: Colors.black12,
                                      borderRadius: BorderRadius.circular(33),
                                    ),

                                    margin: const EdgeInsets.only(top: 8.0, right: 8.0, left: 8.0),
                                    padding: const EdgeInsets.only(top: 8.0, right: 8.0, left: 15.0, bottom: 8.0),
                                    height: 65.0,
                                    child: Row(
                                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                      children: [
                                        Row(
                                          children: [
                                            Column(
                                              crossAxisAlignment: CrossAxisAlignment.start,
                                              mainAxisAlignment: MainAxisAlignment.center,
                                              children: [
                                                Text(
                                                  '${con!.stores[index].name}',
                                                  style: TextStyle(
                                                    fontWeight: FontWeight.bold,
                                                    color: Colors.blue,
                                                    fontSize: 16.0,
                                                  ),
                                                ),
                                                Text(
                                                  '${con!.stores[index].email}',
                                                  style: TextStyle(
                                                    fontWeight: FontWeight.w500,
                                                    // color: Colors.black54,
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ],
                                        ),
                                        Row(
                                          children: [
                                            IconButton(
                                              icon: Icon(Icons.message_outlined),
                                              onPressed: () {
                                                Navigator.pushNamed(context, MessageScreen.routeName, arguments: {
                                                  'my_name': con?.clientProfile.firstName,
                                                  'other_name': con!.stores[index].name,
                                                  'other_id': con!.stores[index].id,
                                                });
                                              },
                                              color: Colors.black54,
                                            ),
                                          ],
                                        )
                                      ],
                                    ),
                                  ),
                                  onTap: () => con?.handleStoreOnTap(con!.stores[index]),
                                )),
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

    // Appointment appointment = Appointment();
    // await FirebaseController.addAppointment(appointment);
  }

  Future<void> accountSettings(String? uid) async {
    await Navigator.pushNamed(state.context, ClientGeneralInfoScreen.routeName, arguments: {
      // "user": state.user,
      "one_clientProfile": clientProfile,
      'isNewUser': false,
    });
    Navigator.pop(state.context); //pop the drawer
    state.render(() {});
  }

  Future<void> handleStoreOnTap(Store store) async {
    await Navigator.pushNamed(state.context, StoreInfoScreen.routeName, arguments: {
      "store": store,
    });
  }

  Future<void> accountSettingsUsingNavigator(String? uid) async {
    await Navigator.pushNamed(state.context, ClientGeneralInfoScreen.routeName, arguments: {
      // "user": state.user,
      "one_clientProfile": clientProfile,
      'isNewUser': false,
    });
    //Navigator.pop(state.context); //pop the drawer
    state.render(() {});
  }

  Future<void> signOut() async {
    FirebaseController.signOut();
  }

  void handleMyAppointmentButton() {
    Navigator.pushNamed(state.context, ClientAppointmentsScreen.routeName);
  }

  void appointmentHistory() {
    Navigator.pushNamed(state.context, ClientAppointmentHistoryScreen.routeName);
  }
}
