import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:monkey_management/model/store.dart';
import 'package:maps_launcher/maps_launcher.dart';

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
                  ElevatedButton(
                      onPressed: null, child: Text('Make Appointment')),
                  ElevatedButton(
                      onPressed: () => con!.openMaps(selctedStore.address),
                      child: Text('Directions')),
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
    bool test = await MapsLauncher.launchQuery(value);
  }
}
