import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:monkey_management/controller/firebase_controller.dart';
import 'package:monkey_management/model/option.dart';
import 'package:monkey_management/model/store.dart';
import 'package:maps_launcher/maps_launcher.dart';
import 'package:monkey_management/view/client_view/add_update_appointment_screen.dart';
import 'package:monkey_management/view/common_view/mydialog.dart';

class StoreInfoScreen extends StatefulWidget {
  static const routeName = '/storeInfoScreen';

  @override
  State<StatefulWidget> createState() {
    return StoreInfoState();
  }
}

class StoreInfoState extends State<StoreInfoScreen> {
  Controller? con;
  late Store selctedStore;

  @override
  void initState() {
    super.initState();
    con = Controller(this);
  }

  void render(fn) => setState(fn);

  @override
  Widget build(BuildContext context) {
    Map args = ModalRoute.of(context)!.settings.arguments as Map;
    selctedStore = args['store'];
    return Scaffold(
      appBar: AppBar(
        title: Text('StoreInfo'),
      ),
      body: ListView(
        children: [
          Center(child: Text('Store Info')),
          Center(
            child: Card(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  ListTile(
                    leading: Icon(Icons.store),
                    title: Text(selctedStore.name),
                  ),
                  ListTile(
                    leading: Icon(Icons.phone),
                    title: Text(selctedStore.phone),
                  ),
                  ListTile(
                    leading: Icon(Icons.email),
                    title: Text(selctedStore.email),
                  ),
                  ListTile(
                    leading: Icon(Icons.location_on_outlined),
                    title: Text(selctedStore.address),
                  ),
                  ElevatedButton(onPressed: () => con!.handelOptions(), child: Text('View Options')),
                  ElevatedButton(onPressed: () => con!.openMaps(selctedStore.address), child: Text('Directions')),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class Controller {
  StoreInfoState state;

  Controller(this.state);

  Future<bool?> openMaps(value) async {
    await MapsLauncher.launchQuery(value);
  }

  Future<void> handelOptions() async {
    List<Option>? options;
    try {
      options = await FirebaseController.getOptions(state.selctedStore.id);
    } catch (e) {
      MyDialog.info(context: state.context, title: 'handel options failed', content: e.toString());
    }

    await Navigator.pushNamed(state.context, AddUpdateAppointmentScreen.routeName,
        arguments: {'storeOptions': options, 'selctedStore': state.selctedStore});
  }
}
