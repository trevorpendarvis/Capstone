import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:monkey_management/controller/firebase_controller.dart';
import 'package:monkey_management/model/appointment.dart';
import 'package:intl/intl.dart';
import 'package:monkey_management/view/client_view/client_pay_appointment_screen.dart';
import 'package:monkey_management/view/common_view/mydialog.dart';

class ClientAppointmentsScreen extends StatefulWidget {
  static const routeName = "/client_appointments_screen";

  @override
  _ClientAppointmentsScreenState createState() =>
      _ClientAppointmentsScreenState();
}

class _ClientAppointmentsScreenState extends State<ClientAppointmentsScreen> {
  late Controller con;
  String selectedChoice = '';

  @override
  void initState() {
    super.initState();
    con = Controller(this);
  }

  void render(fn) => setState(fn);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Padding(
          padding: const EdgeInsets.only(left: 50, right: 20),
          child: Text(
            'My Appointments',
            style: TextStyle(
              color: Colors.black,
            ),
          ),
        ),
      ),
      body: StreamBuilder<QuerySnapshot<Map<String, dynamic>>>(
          stream: FirebaseController.appointmentsStreamForClient(),
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
              // List<Appointment> appointments = Appointment.deserializeToList(appointmentsSnapshot.data!) as List<Appointment>;
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

              return Container(
                child: Column(
                  children: [
                    Text('Blue: Pending | Red: Canceled | Yellow: in Route'),
                    Expanded(
                      child: ListView.builder(
                          itemCount: appointmentsStreamSnapshot.data!.size,
                          itemBuilder: (context, index) => FutureBuilder<
                                  Appointment>(
                              future: Appointment.deserialize(
                                  appointmentsStreamSnapshot.data!.docs[index]
                                      .data(),
                                  appointmentsStreamSnapshot
                                      .data!.docs[index].id),
                              builder: (context, appointmentSnapshot) {
                                if (appointmentSnapshot.connectionState ==
                                    ConnectionState.waiting) {
                                  return ListTile(
                                    title: Text('Loading...'),
                                  );
                                }
                                if (appointmentSnapshot.hasData) {
                                  // print(appointmentSnapshot.data!.clientId);
                                  Appointment appointment =
                                      appointmentSnapshot.data as Appointment;
                                  return GestureDetector(
                                    child: Container(
                                      // shape: RoundedRectangleBorder(
                                      //   borderRadius: BorderRadius.circular(15),
                                      // ),
                                      decoration: BoxDecoration(
                                        color: Colors.black12,
                                        borderRadius: BorderRadius.circular(33),
                                      ),

                                      margin: const EdgeInsets.only(
                                          top: 8.0, right: 8.0, left: 8.0),
                                      padding: const EdgeInsets.only(
                                          top: 8.0,
                                          right: 8.0,
                                          left: 15.0,
                                          bottom: 8.0),
                                      height: 65.0,
                                      child: Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                        children: [
                                          Row(
                                            children: [
                                              Text(
                                                '${DateFormat('MMM dd').format(appointment.appointmentTime)}\n${DateFormat('h:mm aa').format(appointment.appointmentTime)}',
                                                style: TextStyle(
                                                  fontWeight: FontWeight.w500,
                                                  // color: Colors.black54,
                                                ),
                                              ),
                                              Container(
                                                height: 40.0,
                                                margin: EdgeInsets.only(
                                                    right: 10.0, left: 10.0),
                                                decoration: BoxDecoration(
                                                  color: appointment.inRoute
                                                      ? Colors.yellowAccent
                                                      : appointment.isCanceled
                                                          ? Colors.deepOrange
                                                          : Colors.blue,
                                                  borderRadius:
                                                      BorderRadius.circular(5),
                                                ),
                                                child: Text(' '),
                                              ),
                                              Column(
                                                crossAxisAlignment:
                                                    CrossAxisAlignment.start,
                                                mainAxisAlignment:
                                                    MainAxisAlignment.center,
                                                children: [
                                                  Text(
                                                    '${appointment.store.name}',
                                                    style: TextStyle(
                                                      fontWeight:
                                                          FontWeight.bold,
                                                      color: Colors.blue,
                                                      fontSize: 16.0,
                                                    ),
                                                  ),
                                                  Text(
                                                    '${appointment.option.name} | ${appointment.option.price}',
                                                    style: TextStyle(
                                                      fontWeight:
                                                          FontWeight.w500,
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
                                                  onPressed: () => {
                                                        con.handlePayment(
                                                            appointment)
                                                      },
                                                  icon:
                                                      Icon(Icons.credit_card)),
                                              PopupMenuButton(
                                                child: Icon(Icons.list),
                                                itemBuilder: (context) {
                                                  List<String> options =
                                                      !appointment.isCanceled
                                                          ? [
                                                              '${appointment.isCanceled ? 'Undo Cancel' : 'Cancel Appointment'}',
                                                              '${appointment.isCanceled ? '' : 'Complete Appointment'}',
                                                              '${appointment.inRoute ? 'Cancel in Route' : 'On my way'}'
                                                            ]
                                                          : ['Undo Cancel'];
                                                  return options
                                                      .map((choice) =>
                                                          PopupMenuItem(
                                                            child: Text(choice),
                                                            value: choice,
                                                          ))
                                                      .toList();
                                                },
                                                onSelected: (String value) {
                                                  selectedChoice = value;
                                                  con.handelOptions(
                                                      appointment);
                                                },
                                                onCanceled: () {
                                                  selectedChoice = '';
                                                },
                                              ),
                                              /*TextButton(
                                                  onPressed: () {},
                                                  child: Text(
                                                    '${appointment.isCanceled ? 'Revert' : 'Cancel'}',
                                                    style: TextStyle(
                                                      // fontWeight: FontWeight.bold,
                                                      color: Colors.red,
                                                      // fontSize: 16.0,
                                                    ),
                                                  )),
                                              appointment.inRoute
                                                  ? TextButton(
                                                      onPressed: () => con
                                                          .completeAppointment(
                                                              appointment),
                                                      child: Text(
                                                        '${appointment.isCompleted ? 'Revert' : 'Done'}',
                                                        style: TextStyle(
                                                          // fontWeight: FontWeight.bold,
                                                          color: Colors.blue,
                                                          // fontSize: 16.0,
                                                        ),
                                                      ))
                                                  : TextButton(
                                                      onPressed: () =>
                                                          con.updateRoute(
                                                              appointment),
                                                      child: Text(
                                                          '${appointment.inRoute ? 'Revert' : 'On my way'}'),
                                                    ),*/
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
    );
  }
}

class Controller {
  _ClientAppointmentsScreenState state;
  Controller(this.state);

  void updateRoute(Appointment appointment) async {
    Map<String, dynamic> updateInfo = {};
    updateInfo[Appointment.IN_ROUTE] = !appointment.inRoute;
    try {
      await FirebaseController.updateAppointment(appointment.docId, updateInfo);
    } catch (e) {
      MyDialog.info(
          context: state.context,
          title: 'Update appointment error',
          content: e.toString());
    }
  }

  void completeAppointment(Appointment appointment) async {
    Map<String, dynamic> updateInfo = {};
    updateInfo[Appointment.IS_COMPLETED] = true;
    try {
      await FirebaseController.updateAppointment(appointment.docId, updateInfo);
    } catch (e) {
      MyDialog.info(
          context: state.context,
          title: 'Update appointment error',
          content: e.toString());
    }
  }

  void cancelAppointment(Appointment appointment) async {
    Map<String, dynamic> updateInfo = {};
    updateInfo[Appointment.IS_CANCELED] = !appointment.isCanceled;
    try {
      await FirebaseController.updateAppointment(appointment.docId, updateInfo);
    } catch (e) {
      MyDialog.info(
          context: state.context,
          title: 'Update appointment error',
          content: e.toString());
    }
  }

  void handelOptions(Appointment appointment) {
    if (state.selectedChoice == 'Cancel Appointment' ||
        state.selectedChoice == 'Undo Cancel') {
      cancelAppointment(appointment);
    } else if (state.selectedChoice == 'On my way' ||
        state.selectedChoice == 'Cancel in Route') {
      updateRoute(appointment);
    } else if (state.selectedChoice == 'Complete Appointment') {
      completeAppointment(appointment);
    }
  }

  void handlePayment(Appointment appointment) {
    Navigator.pushNamed(
      state.context,
      ClientPayAppointmentScreen.routeName,
    );
  }
}
