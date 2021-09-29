import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:monkey_management/controller/firebase_controller.dart';
import 'package:monkey_management/model/location.dart';
import 'package:monkey_management/view/common_view/splash_screen.dart';
import 'package:monkey_management/view/store_view/store_edit_location_screen.dart';

class StoreLocationsScreen extends StatefulWidget {
  static const routeName = "/store_locations_screen";

  @override
  _StoreLocationsScreenState createState() => _StoreLocationsScreenState();
}

class _StoreLocationsScreenState extends State<StoreLocationsScreen> {
  Controller? con;
  User? store;

  @override
  void initState() {
    super.initState();
    con = Controller(this);
  }

  void render(fn) => setState(fn);

  @override
  Widget build(BuildContext context) {
    // Map args = ModalRoute.of(context)!.settings.arguments as Map;
    // locations = args["locations"];
    // print(locations![0].StoreAddress);
    return Scaffold(
      appBar: AppBar(
        /*  */
        title: Text(
          'Store Locations',
          style: TextStyle(color: Colors.black),
        ),
        foregroundColor: Colors.black,
        backgroundColor: Colors.pinkAccent[400],
      ),
      floatingActionButton: FloatingActionButton(
        child: Icon(
          Icons.add,
          color: Colors.red,
        ),
        backgroundColor: Colors.blue[400],
        onPressed: () => con!.handleAddLocationButton(),
      ),
      body: StreamBuilder<QuerySnapshot<Map<String, dynamic>>>(
          stream: FirebaseController.locationsStream(),
          builder: (BuildContext context, AsyncSnapshot<QuerySnapshot<Map<String, dynamic>>> locationsSnapshot) {
            if (locationsSnapshot.connectionState == ConnectionState.waiting) {
              return Center(
                child: CircularProgressIndicator(),
              );
            }

            if (locationsSnapshot.hasData) {
              List<Location> locations = Location.deserializeToList(locationsSnapshot.data!);
              return Container(
                child: Column(
                  children: [
                    Text('List of store locations'),
                    Expanded(
                      child: ListView.builder(
                          itemCount: locations.length,
                          itemBuilder: (context, index) => ListTile(
                                leading: Icon(Icons.settings),
                                title: Text(locations[index].StoreName),
                                onTap: () => con?.locationSettings(locations[index]),
                              )),
                    )
                  ],
                ),
              );
            }

            print(locationsSnapshot.error);
            return Text('error');
          }),
    );
  }
}

class Controller {
  _StoreLocationsScreenState state;

  Controller(this.state);

  List<Location>? locations;

  void handleAddLocationButton() {
    Navigator.pushNamed(state.context, StoreEditLocationScreen.routeName, arguments: {
      "locationName": "",
      "locationAddress": "",
      "isNewLocation": true,
    });
  }

  Future<void> locationSettings(Location? location) async {
    await Navigator.pushNamed(state.context, StoreEditLocationScreen.routeName, arguments: {
      "locationName": location!.StoreName,
      "locationAddress": location.StoreAddress,
      'isNewLocation': false,
    });
  }
}
