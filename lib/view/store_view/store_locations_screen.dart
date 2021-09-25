import 'package:flutter/material.dart';

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
        backgroundColor: Colors.amber,
      ),
      body: Container(
        child: Row(
          children: [
            Text('Place holder for a list of store locations'),
            /* ElevatedButton(
              onPressed: () => con!.handleAddOptionButton(),
              child: Text('Add New Option'),
            ), */
          ],
        ),
      ),
    );
  }
}

class Controller {
  _StoreLocationsScreenState state;

  Controller(this.state);

  /*  void handleAddOptionButton() {
    Navigator.pushNamed(
      state.context, StoreEditOptionScreen.routeName,
      // arguments: {'isEdit': false}
    );
  } */
}
