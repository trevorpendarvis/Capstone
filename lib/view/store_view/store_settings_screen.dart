import 'package:flutter/material.dart';
import 'package:monkey_management/view/store_view/store_options_screen.dart';
import 'package:monkey_management/view/store_view/store_locations_screen.dart';

class StoreSettingsScreen extends StatefulWidget {
  static const routeName = "/store_settings_screen";

  @override
  _StoreSettingsScreenState createState() => _StoreSettingsScreenState();
}

class _StoreSettingsScreenState extends State<StoreSettingsScreen> {
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
        title: Text(
          'Store Settings',
          style: TextStyle(color: Colors.black),
        ),
        foregroundColor: Colors.black,
        backgroundColor: Colors.amber,
      ),
      body: Container(
        child: Column(
          children: [
            Text('Place holder for a list of settings'),
            ElevatedButton(
              onPressed: () => con!.handleOptionsButton(),
              child: Text('Options'),
            ),
            Text('Place holder for store locations'),
            ElevatedButton(
              onPressed: () => con!.handleLocationsButton(),
              child: Text('Locations'),
            ),
          ],
        ),
      ),
    );
  }
}

class Controller {
  _StoreSettingsScreenState state;

  Controller(this.state);

  void handleOptionsButton() {
    Navigator.pushNamed(state.context, StoreOptionsScreen.routeName);
  }

  void handleLocationsButton() {
    Navigator.pushNamed(state.context, StoreLocationsScreen.routeName);
  }
}
