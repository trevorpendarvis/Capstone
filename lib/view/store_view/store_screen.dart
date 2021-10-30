import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:monkey_management/controller/firebase_controller.dart';
import 'package:monkey_management/model/appointment.dart';
import 'package:monkey_management/model/location.dart';
import 'package:monkey_management/view/auth_view/signin_screen.dart';
import 'package:monkey_management/view/common_view/message_screen.dart';
import 'package:monkey_management/view/store_view/store_locations_screen.dart';
import 'package:monkey_management/view/store_view/store_settings_screen.dart';
import 'package:intl/intl.dart';

import 'options_screen.dart';

class StoreScreen extends StatefulWidget {
  static const routeName = "/store_screen";

  const StoreScreen({Key? key}) : super(key: key);

  @override
  _StoreScreenState createState() => _StoreScreenState();
}

class _StoreScreenState extends State<StoreScreen> {
  int currentIndex = 0;
  Controller? con;
  bool? isSorted = false;

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
          title: Padding(
            padding: const EdgeInsets.only(left: 80, right: 20),
            child: Text(
              'Store Home',
              style: TextStyle(color: Colors.black),
            ),
          ),
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
              DrawerHeader(
                child: Container(
                  width: 500.0,
                  height: 10.0,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: Colors.pink[400],
                    image: DecorationImage(
                      image: AssetImage("assets/images/MonkeyLogo.png"),
                      fit: BoxFit.fitHeight,
                    ),
                  ),
                ),
              ),
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
                leading: Icon(Icons.add_shopping_cart_rounded),
                title: Text("Options"),
                onTap: con?.handleOptionsButton,
              ),
              ListTile(
                leading: Icon(Icons.location_on_rounded),
                title: Text("Locations"),
                onTap: con?.handleLocationsButton,
              ),
              ListTile(
                leading: Icon(Icons.exit_to_app),
                title: Text("Sign Out"),
                onTap: con?.signOut,
              ),
            ],
          ),
        ),
        floatingActionButton: FloatingActionButton(
          child: Icon(
            Icons.swap_vert_outlined,
            color: Colors.red,
            size: 30,
          ),
          backgroundColor: Colors.blue[400],
          onPressed: () => con!.onSort(context),
        ),
        body: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text('Filter: '),
                Padding(
                  padding: EdgeInsets.only(right: 8.0),
                  child: ElevatedButton(
                    child: Text('All'),
                    onPressed: () => con!.onRemoveFilter(),
                  ),
                ),
                Padding(
                  padding: EdgeInsets.only(right: 8.0),
                  child: ElevatedButton(
                    child: Text('Completed'),
                    onPressed: () => con!.onCompletedFilter(),
                  ),
                ),
                // Padding(
                //   padding: EdgeInsets.only(right: 8.0),
                //   child: ElevatedButton(
                //     child: Text('Time'),
                //     onPressed: () => con!.onTimeFilter(),
                //   ),
                // ),
              ],
            ),
            Expanded(
              child: StreamBuilder<QuerySnapshot<Map<String, dynamic>>>(
                  stream: FirebaseController.appointmentsStreamForStore(),
                  builder: (BuildContext context,
                      AsyncSnapshot<QuerySnapshot<Map<String, dynamic>>>
                          appointmentsStreamSnapshot) {
                    if (appointmentsStreamSnapshot.connectionState ==
                        ConnectionState.waiting) {
                      return Center(
                        child: CircularProgressIndicator(),
                      );
                    }

                    if (appointmentsStreamSnapshot.hasData) {
                      if (appointmentsStreamSnapshot.data!.docs.length == 0)
                        return Center(
                          child: Text(
                            'Empty',
                            style: TextStyle(
                              color: Colors.black12,
                              fontSize: 75,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        );

                      con!.appointmentsSnapshot =
                          appointmentsStreamSnapshot.data!;

                      return Container(
                        child: Column(
                          children: [
                            Text(
                                'Blue: Pending | Green: Completed | Red: Canceled'),
                            Expanded(
                              child: ListView.builder(
                                  itemCount:
                                      con!.filteredAppointmentsSnapshot.length,
                                  itemBuilder: (context, index) =>
                                      FutureBuilder<Appointment>(
                                          future: Appointment.deserialize(
                                              con!.filteredAppointmentsSnapshot
                                                  .elementAt(index)
                                                  .data(),
                                              con!.filteredAppointmentsSnapshot
                                                  .elementAt(index)
                                                  .id),
                                          builder:
                                              (context, appointmentSnapshot) {
                                            if (appointmentSnapshot
                                                    .connectionState ==
                                                ConnectionState.waiting) {
                                              return ListTile(
                                                title: Text('Loading...'),
                                              );
                                            }
                                            if (appointmentSnapshot.hasData) {
                                              // print(appointmentSnapshot.data!.clientId);
                                              Appointment appointment =
                                                  appointmentSnapshot.data
                                                      as Appointment;
                                              return GestureDetector(
                                                child: Container(
                                                  // shape: RoundedRectangleBorder(
                                                  //   borderRadius: BorderRadius.circular(15),
                                                  // ),
                                                  decoration: BoxDecoration(
                                                    color: Colors.black12,
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            33),
                                                  ),

                                                  margin: const EdgeInsets.only(
                                                      top: 8.0,
                                                      right: 8.0,
                                                      left: 8.0),
                                                  padding:
                                                      const EdgeInsets.only(
                                                          top: 8.0,
                                                          right: 8.0,
                                                          left: 15.0,
                                                          bottom: 8.0),
                                                  height: 65.0,
                                                  child: Row(
                                                    mainAxisAlignment:
                                                        MainAxisAlignment
                                                            .spaceBetween,
                                                    children: [
                                                      Row(
                                                        children: [
                                                          Text(
                                                            '${DateFormat('MMM dd').format(appointment.appointmentTime)}\n${DateFormat('h:mm aa').format(appointment.appointmentTime)}',
                                                            style: TextStyle(
                                                              fontWeight:
                                                                  FontWeight
                                                                      .w500,
                                                              // color: Colors.black54,
                                                            ),
                                                          ),
                                                          Container(
                                                            height: 40.0,
                                                            margin:
                                                                EdgeInsets.only(
                                                                    right: 10.0,
                                                                    left: 10.0),
                                                            decoration:
                                                                BoxDecoration(
                                                              color: appointment
                                                                      .isCompleted
                                                                  ? Colors.green
                                                                  : appointment
                                                                          .isCanceled
                                                                      ? Colors
                                                                          .deepOrange
                                                                      : Colors
                                                                          .blue,
                                                              borderRadius:
                                                                  BorderRadius
                                                                      .circular(
                                                                          5),
                                                            ),
                                                            child: Text(' '),
                                                          ),
                                                          Column(
                                                            crossAxisAlignment:
                                                                CrossAxisAlignment
                                                                    .start,
                                                            mainAxisAlignment:
                                                                MainAxisAlignment
                                                                    .center,
                                                            children: [
                                                              Text(
                                                                '${appointment.client.firstName!} ${appointment.client.lastName!}',
                                                                style:
                                                                    TextStyle(
                                                                  fontWeight:
                                                                      FontWeight
                                                                          .bold,
                                                                  color: Colors
                                                                      .blue,
                                                                  fontSize:
                                                                      16.0,
                                                                ),
                                                              ),
                                                              Text(
                                                                '${appointment.option.name} | ${appointment.option.price}',
                                                                style:
                                                                    TextStyle(
                                                                  fontWeight:
                                                                      FontWeight
                                                                          .w500,
                                                                  // color: Colors.black54,
                                                                ),
                                                              ),
                                                            ],
                                                          ),
                                                        ],
                                                      ),
                                                      Row(
                                                        children: [
                                                          TextButton(
                                                              onPressed: () {},
                                                              child: Text(
                                                                '${appointment.isCanceled ? 'Revert' : 'Cancel'}',
                                                                style:
                                                                    TextStyle(
                                                                  // fontWeight: FontWeight.bold,
                                                                  color: Colors
                                                                      .red,
                                                                  // fontSize: 16.0,
                                                                ),
                                                              )),
                                                          TextButton(
                                                              onPressed: () {},
                                                              child: Text(
                                                                '${appointment.isCompleted ? 'Revert' : 'Done'}',
                                                                style:
                                                                    TextStyle(
                                                                  // fontWeight: FontWeight.bold,
                                                                  color: Colors
                                                                      .blue,
                                                                  // fontSize: 16.0,
                                                                ),
                                                              )),
                                                          TextButton(
                                                            onPressed: () {
                                                              Navigator.pushNamed(
                                                                  context,
                                                                  MessageScreen
                                                                      .routeName,
                                                                  arguments: {
                                                                    'my_name':
                                                                        appointment
                                                                            .store
                                                                            .name,
                                                                    'other_name':
                                                                        appointment
                                                                            .client
                                                                            .firstName,
                                                                    'other_id':
                                                                        appointment
                                                                            .client
                                                                            .docId,
                                                                  });
                                                            },
                                                            child: Text(
                                                              'Message',
                                                              style: TextStyle(
                                                                // fontWeight: FontWeight.bold,
                                                                color:
                                                                    Colors.blue,
                                                                // fontSize: 16.0,
                                                              ),
                                                            ),
                                                          ),
                                                        ],
                                                      )
                                                    ],
                                                  ),
                                                ),
                                                onTap: () {},
                                              );
                                            }
                                            print(appointmentSnapshot.error);
                                            return Text('error!!!');
                                          })),
                            )
                          ],
                        ),
                      );
                    }

                    print(appointmentsStreamSnapshot.error);
                    return Text('error');
                  }),
            ),
          ],
        ),
      ),
    );
  }
}

class Controller {
  _StoreScreenState state;

  Controller(this.state);

  late QuerySnapshot<Map<String, dynamic>> appointmentsSnapshot;
  late Iterable<QueryDocumentSnapshot<Map<String, dynamic>>>
      filteredAppointmentsSnapshot = appointmentsSnapshot.docs;

  void onCompletedFilter() {
    state.setState(() {
      filteredAppointmentsSnapshot = appointmentsSnapshot.docs
          .where((element) => element.data()[Appointment.IS_COMPLETED] == true);
    });
  }

  void onSort(BuildContext context) {
    String text = "";
    if (!state.isSorted!) {
      state.setState(() {
        filteredAppointmentsSnapshot = appointmentsSnapshot.docs
          ..sort((a, b) => a
              .data()[Appointment.CLIENT_ID]
              .compareTo(b.data()[Appointment.CLIENT_ID]));
      });
      state.isSorted = true;
      text = "You have sorted by client ID!";
    } else {
      state.setState(() {
        filteredAppointmentsSnapshot = appointmentsSnapshot.docs
          ..sort((a, b) => a
              .data()[Appointment.APPOINTMENT_TIME]
              .compareTo(b.data()[Appointment.APPOINTMENT_TIME]));
      });
      state.isSorted = false;
      text = "You have sorted by appointment time!";
    }

    final snackBar = SnackBar(
      content: Text(
        text,
        style: TextStyle(fontSize: 25),
      ),
      backgroundColor: Colors.pink,
      behavior: SnackBarBehavior.fixed,
    );

    ScaffoldMessenger.of(context).showSnackBar(snackBar);
  }

  void onTimeFilter() {
    state.setState(() {
      filteredAppointmentsSnapshot = appointmentsSnapshot.docs
        ..sort((a, b) => b
            .data()[Appointment.APPOINTMENT_TIME]
            .compareTo(a.data()[Appointment.APPOINTMENT_TIME]));
    });
  }

  void onRemoveFilter() {
    state.setState(() {
      filteredAppointmentsSnapshot = appointmentsSnapshot.docs;
    });
  }

  Future<void> profile() async {}

  Future<void> settings() async {
    Navigator.pushNamed(state.context, StoreSettingsScreen.routeName);
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

  List<Location> locations = [];

  // Place for all the fectching operations.
  Future<void> fetchData() async {
    try {
      locations = await FirebaseController.fetchLocations();
    } catch (e) {
      print(e);
    }
  }

  void handleOptionsButton() {
    Navigator.pushNamed(state.context, StoreOptionsScreen.routeName);
  }

  void handleLocationsButton() {
    Navigator.pushNamed(
      state.context,
      StoreLocationsScreen.routeName,
    );
    // arguments: {"locations": state.locations});
  }
}
