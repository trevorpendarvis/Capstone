import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:monkey_management/controller/firebase_controller.dart';
import 'package:monkey_management/model/location.dart';
import 'package:monkey_management/model/option.dart';
import 'package:monkey_management/view/common_view/loading_screen.dart';
import 'package:monkey_management/view/store_view/store_edit_location_screen.dart';
import 'package:monkey_management/view/store_view/store_edit_options_screen.dart';

class StoreOptionsScreen extends StatefulWidget {
  static const routeName = "/options_screen";

  @override
  _StoreOptionsScreenState createState() {
    return _StoreOptionsScreenState();
  }
}

class _StoreOptionsScreenState extends State<StoreOptionsScreen> {
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
        title: Padding(
          padding: const EdgeInsets.only(left: 60, right: 20),
          child: Text(
            'Store Options',
            style: TextStyle(color: Colors.black),
          ),
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
          stream: FirebaseController.optionsStream(),
          builder: (BuildContext context,
              AsyncSnapshot<QuerySnapshot<Map<String, dynamic>>> optionsSnapshot) {
            if (optionsSnapshot.connectionState == ConnectionState.waiting) {
              return Center(
                child: CircularProgressIndicator(),
              );
            }

            if (optionsSnapshot.hasData) {
              List<Option> options = Option.deserializeToList(optionsSnapshot.data!);
              return Container(
                child: Column(
                  children: [
                    Text('List of store products/services'),
                    Expanded(
                      child: ListView.builder(
                          itemCount: options.length,
                          itemBuilder: (context, index) => ListTile(
                                leading: Icon(Icons.settings),
                                title: Text(options[index].name),
                                onTap: () => con?.optionSettings(options[index]),
                              )),
                    )
                  ],
                ),
              );
            }

            print(optionsSnapshot.error);
            return Text('error');
          }),
    );
  }
}

class Controller {
  _StoreOptionsScreenState state;

  Controller(this.state);

  List<Location>? locations;

  void handleAddLocationButton() {
    Navigator.pushNamed(state.context, StoreEditOptionScreen.routeName, arguments: {
      "optionName": "",
      "optionPrice": 0.0,
      "optionDescription": "",
      "isNewLocation": true,
      "optionDocId": "",
    });
  }

  Future<void> optionSettings(Option? option) async {
    await Navigator.pushNamed(state.context, StoreEditOptionScreen.routeName, arguments: {
      "optionName": option!.name,
      "optionPrice": option.price,
      "optionDescription": option.description,
      "optionDocId": option.id,
      'isNewLocation': false,
    });
  }
}
