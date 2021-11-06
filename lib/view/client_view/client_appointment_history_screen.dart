import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:monkey_management/controller/firebase_controller.dart';
import 'package:monkey_management/model/appointment.dart';
import 'package:intl/intl.dart';
import 'package:monkey_management/model/option.dart';
import 'package:monkey_management/model/store.dart';
import 'package:monkey_management/view/common_view/mydialog.dart';

class ClientAppointmentHistoryScreen extends StatefulWidget {
  static const routeName = "/client_appointment_history_screen";

  @override
  State<StatefulWidget> createState() {
    return _ClientAppointmentHistoryScreenState();
  }
}

class _ClientAppointmentHistoryScreenState
    extends State<ClientAppointmentHistoryScreen> {
  late _Controller controller;
  late List<Option> storeOptions;
  late Store selctedStore;
  late DateTime pickedDate;

  @override
  void initState() {
    super.initState();
    controller = _Controller(this);
  }

  void render(fn) => setState(fn);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[300],
      appBar: AppBar(
        title: Padding(
          padding: const EdgeInsets.only(left: 50, right: 20),
          child: Text(
            "Past Appointments",
            style: TextStyle(
              color: Colors.black,
              fontSize: 20,
            ),
          ),
        ),
        backgroundColor: Colors.grey[250],
      ),
      body: StreamBuilder<QuerySnapshot<Map<String, dynamic>>>(
          stream: FirebaseController.appointmentHistoryStreamForClient(),
          builder: (BuildContext context,
              AsyncSnapshot<QuerySnapshot<Map<String, dynamic>>>
                  appointmentHistoryStreamSnapshot) {
            if (appointmentHistoryStreamSnapshot.connectionState ==
                ConnectionState.waiting) {
              return Center(
                child: CircularProgressIndicator(),
              );
            }

            if (appointmentHistoryStreamSnapshot.hasData) {
              // List<Appointment> appointments = Appointment.deserializeToList(appointmentsSnapshot.data!) as List<Appointment>;
              if (appointmentHistoryStreamSnapshot.data!.docs.length == 0)
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
                    //Text('Blue: Pending | Green: Completed | Red: Canceled'),
                    Expanded(
                      child: ListView.builder(
                          itemCount:
                              appointmentHistoryStreamSnapshot.data!.size,
                          itemBuilder: (context, index) => FutureBuilder<
                                  Appointment>(
                              future: Appointment.deserialize(
                                  appointmentHistoryStreamSnapshot
                                      .data!.docs[index]
                                      .data(),
                                  appointmentHistoryStreamSnapshot
                                      .data!.docs[index].id),
                              builder: (context, appointmentHistorySnapshot) {
                                if (appointmentHistorySnapshot
                                        .connectionState ==
                                    ConnectionState.waiting) {
                                  return ListTile(
                                    title: Text('Loading...'),
                                  );
                                }
                                if (appointmentHistorySnapshot.hasData) {
                                  // print(appointmentSnapshot.data!.clientId);
                                  Appointment appointment =
                                      appointmentHistorySnapshot.data
                                          as Appointment;
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
                                                  color: Colors.green,
                                                  //appointment.isCompleted
                                                  //     ? Colors.green
                                                  //     : appointment.isCanceled
                                                  //         ? Colors.deepOrange
                                                  //         : Colors.blue,
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
                                              TextButton(
                                                  onPressed: () async =>
                                                      await controller
                                                          .makeAppointment(
                                                              context,
                                                              appointment),
                                                  child: Text(
                                                    'Reschedule Appointment',
                                                    style: TextStyle(
                                                      // fontWeight: FontWeight.bold,
                                                      color: Colors.blue,
                                                      // fontSize: 16.0,
                                                    ),
                                                  )),
                                            ],
                                          )
                                        ],
                                      ),
                                    ),
                                    onTap: () {},
                                  );
                                }
                                print(appointmentHistorySnapshot.error);
                                return Text('error!!!');
                              })),
                    )
                  ],
                ),
              );
            }
            print(appointmentHistoryStreamSnapshot.error);
            return Text('error');
          }),
    );
  }
}

class _Controller {
  _ClientAppointmentHistoryScreenState state;

  _Controller(this.state);
  DateTime? date;
  bool isUpdate = false;
  late Store store;
  TimeOfDay? timeOfDay = new TimeOfDay(hour: 7, minute: 15);

  Future<void> makeAppointment(
      BuildContext context, Appointment selectedAppointment) async {
    state.pickedDate = DateTime.now();
    return await showDialog(
        context: context,
        builder: (context) {
          return StatefulBuilder(builder: (context, setState) {
            return AlertDialog(
              content: Center(
                child: Column(
                  children: [
                    Container(
                      decoration: BoxDecoration(
                          border: Border.all(color: Colors.black87)),
                      child: ListTile(
                        title: Text('Select Date'),
                        subtitle: Text(
                            'Date: ${state.pickedDate.month}/${state.pickedDate.day}/${state.pickedDate.year}'),
                        trailing: Icon(Icons.calendar_today_rounded),
                        onTap: () async {
                          date = await showDatePicker(
                              context: context,
                              initialDate: state.pickedDate,
                              firstDate: DateTime.now(),
                              lastDate: DateTime(DateTime.now().year + 5));

                          if (date != null) {
                            setState(() {
                              state.pickedDate = date!;
                            });
                          }
                        },
                      ),
                    ),
                    Container(
                      decoration: BoxDecoration(
                          border: Border.all(color: Colors.black87)),
                      child: ListTile(
                        title: Text('Select a Time'),
                        subtitle:
                            Text('${timeOfDay!.hour}:${timeOfDay!.minute}'),
                        trailing: Icon(Icons.access_time),
                        onTap: () async {
                          final TimeOfDay? tempTime = await showTimePicker(
                              context: state.context,
                              initialTime: TimeOfDay(hour: 7, minute: 15));

                          if (tempTime != null) {
                            setState(() {
                              timeOfDay = tempTime;
                            });
                          }
                        },
                      ),
                    ),
                  ],
                ),
              ),
              actions: <Widget>[
                TextButton(
                    onPressed: () async {
                      Navigator.of(context).pop();
                      await handelAppointment(selectedAppointment);
                    },
                    child: Text('Confirm')),
                TextButton(
                    onPressed: () => Navigator.of(context).pop(),
                    child: Text('Cancel'))
              ],
            );
          });
        });
  }

  Future<void> handelAppointment(Appointment selectedAppointment) async {
    MyDialog.circularProgressStart(state.context);
    try {
      Appointment app = new Appointment();
      app.client = selectedAppointment.client;
      app.store = selectedAppointment.store;
      app.option = selectedAppointment.option;
      app.createdBy = selectedAppointment.client.docId!;
      DateTime timeAppointment = new DateTime(
          state.pickedDate.year,
          state.pickedDate.month,
          state.pickedDate.day,
          timeOfDay!.hour,
          timeOfDay!.minute);
      app.appointmentTime = timeAppointment;
      await FirebaseController.addAppointment(app);
      MyDialog.circularProgressStop(state.context);
      MyDialog.info(
          context: state.context,
          title: 'Successful',
          content:
              'Appointment made for ${state.pickedDate.month}/${state.pickedDate.day}/${state.pickedDate.year}  At: ${timeOfDay!.hour}:${timeOfDay!.minute}');
    } catch (e) {
      MyDialog.circularProgressStop(state.context);
      MyDialog.info(
          context: state.context,
          title: 'handel appointment failed',
          content: e.toString());
    }
  }
}
