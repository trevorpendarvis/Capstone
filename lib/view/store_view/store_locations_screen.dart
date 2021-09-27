import 'package:flutter/material.dart';
import 'package:monkey_management/view/store_view/store_edit_location_screen.dart';

class StoreLocationsScreen extends StatefulWidget {
  static const routeName = "/store_locations_screen";

  @override
  _StoreLocationsScreenState createState() => _StoreLocationsScreenState();
}

class _StoreLocationsScreenState extends State<StoreLocationsScreen> {
  Controller? con;

  @override
  void initState() {
    super.initState();
    con = Controller(this);
  }

  void render(fn) => setState(fn);

  @override
  Widget build(BuildContext context) {
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
      body: Container(
        child: Row(
          children: [
            Text('Place holder for a list of store locations'),
            ElevatedButton(
              onPressed: () => con!.handleAddLocationButton(),
              child: Text('Add New Location'),
            ),
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
