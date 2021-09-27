import 'package:flutter/material.dart';
import 'package:monkey_management/model/store.dart';

class AddUpdateAppointmentScreen extends StatefulWidget {

  static const routeName = "/add_update_appointment_screen";

  const AddUpdateAppointmentScreen({Key? key}) : super(key: key);

  @override
  _AddAppointmentScreenState createState() => _AddAppointmentScreenState();
}

class _AddAppointmentScreenState extends State<AddUpdateAppointmentScreen> {

  late _Controller controller;

  @override
  void initState() {
    super.initState();
    controller = _Controller(this);
  }

  void render(fn) => setState(fn);

  @override
  Widget build(BuildContext context) {
    Map? args = ModalRoute.of(context)!.settings.arguments as Map?;
    controller.isUpdate = args!['isUpdate'];
    controller.store = args['store'];

    return Scaffold(
      appBar: AppBar(),
      body: Text('appointment screen'),
    );
  }

}


class _Controller {
  _AddAppointmentScreenState state;
  _Controller(this.state);

  bool isUpdate = false;
  late Store store;
}