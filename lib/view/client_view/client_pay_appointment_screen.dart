import 'package:flutter/material.dart';

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

  void render(fn) => setState(fn);

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Scaffold(
      appBar: AppBar(
        title: Padding(
          padding: const EdgeInsets.only(left: 70, right: 20),
          child: Text(
            'Appointment Payment',
            style: TextStyle(color: Colors.black),
          ),
        ),
        foregroundColor: Colors.black,
        backgroundColor: Colors.blue,
      ),
    );
  }
}

class Controller {
  _ClientPayAppointmentScreenState state;

  Controller(this.state);
}
