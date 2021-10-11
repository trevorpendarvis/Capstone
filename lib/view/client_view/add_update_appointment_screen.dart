import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:monkey_management/controller/firebase_controller.dart';
import 'package:monkey_management/model/appointment.dart';
import 'package:monkey_management/model/client.dart';
import 'package:monkey_management/model/option.dart';
import 'package:monkey_management/model/store.dart';
import 'package:monkey_management/view/common_view/mydialog.dart';

class AddUpdateAppointmentScreen extends StatefulWidget {
  static const routeName = "/add_update_appointment_screen";

  const AddUpdateAppointmentScreen({Key? key}) : super(key: key);

  @override
  State<StatefulWidget> createState() {
    return _AddAppointmentScreenState();
  }
}

class _AddAppointmentScreenState extends State<AddUpdateAppointmentScreen> {
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
    Map? args = ModalRoute.of(context)!.settings.arguments as Map?;
    storeOptions = args!['storeOptions'];
    selctedStore = args['selctedStore'];
    return Scaffold(
      appBar: AppBar(
        title: Text('Store Options'),
      ),
      body: ListView.builder(
        itemCount: storeOptions.length,
        itemBuilder: (context, index) => GestureDetector(
          child: Container(
            decoration:
                BoxDecoration(border: Border.all(color: Colors.black38)),
            child: ListTile(
              title: Center(child: Text(storeOptions[index].name)),
              subtitle: Center(
                  child: Text("${storeOptions[index].price.toString()}")),
              tileColor: Colors.grey[200],
              onTap: () async => await controller.makeAppointment(
                  context, storeOptions[index]),
            ),
          ),
        ),
      ),
    );
  }
}

class _Controller {
  _AddAppointmentScreenState state;

  _Controller(this.state);
  DateTime? date;
  bool isUpdate = false;
  late Store store;
  TimeOfDay? timeOfDay = new TimeOfDay(hour: 7, minute: 15);

  Future<void> makeAppointment(
      BuildContext context, Option selectedOption) async {
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
                      await handelAppointment(selectedOption);
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

  Future<void> handelAppointment(Option selectedOption) async {
    Client c = new Client();
    MyDialog.circularProgressStart(state.context);
    try {
      c = await FirebaseController.getClientProfile(
          FirebaseAuth.instance.currentUser!.uid);
      Appointment app = new Appointment();
      app.client = c;
      app.store = state.selctedStore;
      app.option = selectedOption;
      app.createdBy = c.docId!;
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
