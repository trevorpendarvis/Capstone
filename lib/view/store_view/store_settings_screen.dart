import 'package:flutter/material.dart';
import 'package:monkey_management/model/location.dart';
import 'package:monkey_management/view/store_view/options_screen.dart';
import 'package:monkey_management/view/store_view/store_locations_screen.dart';

class StoreSettingsScreen extends StatefulWidget {
  static const routeName = "/store_settings_screen";

  @override
  _StoreSettingsScreenState createState() => _StoreSettingsScreenState();
}

class _StoreSettingsScreenState extends State<StoreSettingsScreen> {
  Controller? con;
  List<Location>? locations = [];
  @override
  void initState() {
    super.initState();
    con = Controller(this);
  }

  void render(fn) => setState(fn);

  @override
  Widget build(BuildContext context) {
    // Map args = ModalRoute.of(context)!.settings.arguments as Map;
    // locations = args["locations"] ?? [];
    return Scaffold(
      appBar: AppBar(
        title: Padding(
          padding: const EdgeInsets.only(left: 70, right: 20),
          child: Text(
            'Store Settings',
            style: TextStyle(color: Colors.black),
          ),
        ),
        foregroundColor: Colors.black,
        backgroundColor: Colors.pinkAccent[400],
      ),
      body: Container(
        width: MediaQuery.of(context).size.width,
        child: ListView(
          children: [
            ListTile(
              title: Text('Options'),
              trailing: Icon(Icons.arrow_forward_ios_rounded),
              onTap: () => con!.handleOptionsButton(),
            ),
            ListTile(
              title: Text('Locations'),
              trailing: Icon(Icons.arrow_forward_ios_rounded),
              onTap: () => con!.handleLocationsButton(),
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
    Navigator.pushNamed(
      state.context,
      StoreLocationsScreen.routeName,
    );
    // arguments: {"locations": state.locations});
  }
}
