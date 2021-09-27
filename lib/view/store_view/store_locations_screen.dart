import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:monkey_management/model/location.dart';
import 'package:monkey_management/view/store_view/store_edit_location_screen.dart';

class StoreLocationsScreen extends StatefulWidget {
  static const routeName = "/store_locations_screen";

  @override
  _StoreLocationsScreenState createState() => _StoreLocationsScreenState();
}

class _StoreLocationsScreenState extends State<StoreLocationsScreen> {
  Controller? con;
  User? store;
  List<Location>? locations;

  @override
  void initState() {
    super.initState();
    con = Controller(this);
  }

  void render(fn) => setState(fn);

  @override
  Widget build(BuildContext context) {
    Map args = ModalRoute.of(context)!.settings.arguments as Map;
    locations = args["locations"];
    print(locations![0].StoreAddress);
    return Scaffold(
      appBar: AppBar(
        /*  */
        title: Text(
          'Store Locations',
          style: TextStyle(color: Colors.black),
        ),
        foregroundColor: Colors.black,
        backgroundColor: Colors.amber,
      ),
      floatingActionButton: FloatingActionButton(
        child: Icon(
          Icons.add,
          color: Colors.red,
        ),
        backgroundColor: Colors.blue[400],
        onPressed: () => con!.handleAddLocationButton(),
      ),
      body: Container(
        child: Column(
          children: [
            Text('List of store locations'),
            Expanded(
              child: ListView.builder(
                  itemCount: locations!.length,
                  itemBuilder: (context, index) => ListTile(
                        title: Text(locations![index].StoreName),
                      )),
            )
          ],
        ),
      ),
    );
  }
}

class Controller {
  _StoreLocationsScreenState state;

  Controller(this.state);

  void handleAddLocationButton() {
    Navigator.pushNamed(
      state.context, StoreEditLocationScreen.routeName,
      // arguments: {'isEdit': false}
    );
  }
}
