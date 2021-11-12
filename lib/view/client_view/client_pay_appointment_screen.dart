import 'package:flutter/material.dart';
import 'package:monkey_management/controller/firebase_controller.dart';
import 'package:monkey_management/model/appointment.dart';
import 'package:monkey_management/view/common_view/mydialog.dart';

class ClientPayAppointmentScreen extends StatefulWidget {
  static const routeName = "/client_pay_appointment_screen";

  @override
  _ClientPayAppointmentScreenState createState() =>
      _ClientPayAppointmentScreenState();
}

class _ClientPayAppointmentScreenState
    extends State<ClientPayAppointmentScreen> {
  Controller? con;
  void initState() {
    super.initState();
    con = Controller(this);
  }

  var formKey = GlobalKey<FormState>();
  bool? isPaid;
  String? appointmentName;
  String? appointmentPrice;
  String? appointmentID;

  void render(fn) => setState(fn);

  @override
  Widget build(BuildContext context) {
    Map? args = ModalRoute.of(context)!.settings.arguments as Map?;
    appointmentName = args!['appointmentName'];
    appointmentPrice = args['appointmentPrice'];
    appointmentID = args['appointmentID'];
    isPaid = args['isPaid'];

    // isPaid = args!['isPaid'] ?? true;

    return Scaffold(
      appBar: AppBar(
        title: Padding(
          padding: const EdgeInsets.only(left: 50, right: 20),
          child: Text(
            'Appointment Payment',
            style: TextStyle(color: Colors.black),
          ),
        ),
        foregroundColor: Colors.black,
        backgroundColor: Colors.blue,
      ),
      body: Container(
        padding: EdgeInsets.all(8.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            SingleChildScrollView(
              child: !isPaid!
                  ? // If this is a new location
                  Form(
                      key: formKey,
                      child: Column(
                        children: [
                          Container(
                            margin: EdgeInsets.fromLTRB(0, 10.0, 0, 10.0),
                            child: TextFormField(
                              decoration: InputDecoration(
                                hintText: appointmentName,
                                border: OutlineInputBorder(),
                                enabled: false,
                              ),
                              //validator: con?.validateStoreName,
                              //onSaved: con?.saveStoreName,
                            ),
                          ),
                          Container(
                            margin: EdgeInsets.fromLTRB(0, 10.0, 0, 10.0),
                            child: TextFormField(
                              decoration: InputDecoration(
                                hintText: appointmentPrice,
                                border: OutlineInputBorder(),
                                enabled: false,
                              ),
                              //validator: con?.validateStoreAddress,
                              //onSaved: con?.saveStoreAddress,
                            ),
                          ),
                        ],
                      ),
                    )
                  : // If it's an existing location
                  Column(
                      children: [
                        SizedBox(
                          height: 50.0,
                        ),
                        Text(
                          "Would you look at that!",
                          style: TextStyle(
                              color: Colors.black,
                              fontSize: 20,
                              fontWeight: FontWeight.bold),
                        ),
                        SizedBox(
                          height: 50.0,
                        ),
                        Image.asset(
                          'assets/images/MonkeyLogo.png',
                          height: 100.0,
                          width: 100.0,
                        ),
                        SizedBox(
                          height: 50.0,
                        ),
                        Text(
                          "This appoinment has already been paid for!",
                          style: TextStyle(
                              color: Colors.black,
                              fontSize: 20,
                              fontWeight: FontWeight.bold),
                        )
                      ],
                    ),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                ElevatedButton(
                  onPressed: () => con!.payAppointment(appointmentID),
                  child: Text("Pay", style: Theme.of(context).textTheme.button),
                ),
              ],
            )
          ],
        ),
      ),
      backgroundColor: Colors.grey[200],
    );
  }
}

class Controller {
  _ClientPayAppointmentScreenState state;

  Controller(this.state);

  void payAppointment(String? appointmentID) async {
    Map<String, dynamic> updateInfo = {};
    updateInfo[Appointment.IS_PAID] = true;
    try {
      await FirebaseController.updateAppointment(appointmentID, updateInfo);
      MyDialog.info(
          context: state.context,
          title: 'Transaction Successful',
          content: "Thank you for your payment! Enjoy your appointment!");
    } catch (e) {
      MyDialog.info(
          context: state.context,
          title: 'Transaction error',
          content: e.toString());
    }
  }
}
