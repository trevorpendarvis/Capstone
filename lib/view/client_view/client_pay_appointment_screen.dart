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

  var formKey = GlobalKey<FormState>();
  bool? isPaid;

  void render(fn) => setState(fn);

  @override
  Widget build(BuildContext context) {
    // Map? args = ModalRoute.of(context)!.settings.arguments as Map?;

    // isPaid = args!['isPaid'] ?? true;

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
      body: Container(
        padding: EdgeInsets.all(8.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            SingleChildScrollView(
              child: true
                  ? // If this is a new location
                  Form(
                      key: formKey,
                      child: Column(
                        children: [
                          Container(
                            margin: EdgeInsets.fromLTRB(0, 10.0, 0, 10.0),
                            child: TextFormField(
                              decoration: InputDecoration(
                                hintText: "Appointment Name",
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
                                hintText: "Cost",
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
                  Form(
                      key: formKey,
                      child: Column(
                        children: [
                          Container(
                            margin: EdgeInsets.fromLTRB(0, 10.0, 0, 10.0),
                            child: TextFormField(
                              initialValue: "appointmentName",
                              decoration: InputDecoration(
                                // hintText: locationName,
                                border: OutlineInputBorder(),
                              ),
                              //validator: con?.validateStoreName,
                              //onSaved: con?.saveStoreName,
                            ),
                          ),
                          Container(
                            margin: EdgeInsets.fromLTRB(0, 10.0, 0, 10.0),
                            child: TextFormField(
                              initialValue: "appointmentCost",
                              decoration: InputDecoration(
                                // hintText: locationAddress,
                                border: OutlineInputBorder(),
                              ),
                              //validator: con?.validateStoreAddress,
                              //onSaved: con?.saveStoreAddress,
                            ),
                          ),
                        ],
                      ),
                    ),
            ),
          ],
        ),
      ),
    );
  }
}

class Controller {
  _ClientPayAppointmentScreenState state;

  Controller(this.state);
}
