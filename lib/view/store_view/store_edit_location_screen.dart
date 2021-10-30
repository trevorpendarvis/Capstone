import 'package:flutter/material.dart';
import 'package:monkey_management/controller/firebase_controller.dart';
import 'package:monkey_management/model/location.dart';
import 'package:monkey_management/view/common_view/mydialog.dart';
import 'package:monkey_management/view/store_view/store_locations_screen.dart';

class StoreEditLocationScreen extends StatefulWidget {
  static const routeName = "/store_edit_location_screen";

  @override
  _StoreEditLocationScreenState createState() =>
      _StoreEditLocationScreenState();
}

class _StoreEditLocationScreenState extends State<StoreEditLocationScreen> {
  Controller? con;

  var formKey = GlobalKey<FormState>();
  String? locationName;
  String? locationAddress;
  bool? isNewLocation;

  @override
  void initState() {
    super.initState();
    con = Controller(this);
  }

  void render(fn) => setState(fn);

  @override
  Widget build(BuildContext context) {
    Map? args = ModalRoute.of(context)!.settings.arguments as Map?;
    locationName = args!['locationName'];
    locationAddress = args['locationAddress'];
    isNewLocation = args['isNewLocation'] ?? true;
    return Scaffold(
      appBar: AppBar(
        title: Padding(
          padding: const EdgeInsets.only(left: 70, right: 20),
          child: Text(
            'Edit Location',
            style: TextStyle(color: Colors.black),
          ),
        ),
        foregroundColor: Colors.black,
        backgroundColor: Colors.pinkAccent[400],
      ),
      body: Container(
          padding: EdgeInsets.all(8.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              SingleChildScrollView(
                child: isNewLocation!
                    ? // If this is a new location
                    Form(
                        key: formKey,
                        child: Column(
                          children: [
                            Container(
                              margin: EdgeInsets.fromLTRB(0, 10.0, 0, 10.0),
                              child: TextFormField(
                                decoration: InputDecoration(
                                  hintText: "Location Store Name",
                                  border: OutlineInputBorder(),
                                ),
                                validator: con?.validateStoreName,
                                onSaved: con?.saveStoreName,
                              ),
                            ),
                            Container(
                              margin: EdgeInsets.fromLTRB(0, 10.0, 0, 10.0),
                              child: TextFormField(
                                decoration: InputDecoration(
                                  hintText: "Address",
                                  border: OutlineInputBorder(),
                                ),
                                validator: con?.validateStoreAddress,
                                onSaved: con?.saveStoreAddress,
                              ),
                            ),
                          ],
                        ),
                      )
                    : // If it's an existing location
                    Form(
                        key: formKey,
                        child: Column(
                          children: [
                            Container(
                              margin: EdgeInsets.fromLTRB(0, 10.0, 0, 10.0),
                              child: TextFormField(
                                initialValue: locationName,
                                decoration: InputDecoration(
                                  // hintText: locationName,
                                  border: OutlineInputBorder(),
                                ),
                                validator: con?.validateStoreName,
                                onSaved: con?.saveStoreName,
                              ),
                            ),
                            Container(
                              margin: EdgeInsets.fromLTRB(0, 10.0, 0, 10.0),
                              child: TextFormField(
                                initialValue: locationAddress,
                                decoration: InputDecoration(
                                  // hintText: locationAddress,
                                  border: OutlineInputBorder(),
                                ),
                                validator: con?.validateStoreAddress,
                                onSaved: con?.saveStoreAddress,
                              ),
                            ),
                          ],
                        ),
                      ),
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  ElevatedButton(
                    onPressed: con?.delete,
                    child: Text("Delete",
                        style: Theme.of(context).textTheme.button),
                  ),
                  isNewLocation!
                      ?
                      // Add new location
                      ElevatedButton(
                          onPressed: con?.onSave,
                          child: Text("Done",
                              style: Theme.of(context).textTheme.button),
                        )
                      :
                      // Update existing location
                      ElevatedButton(
                          onPressed: con?.onUpdate,
                          child: Text("Update",
                              style: Theme.of(context).textTheme.button),
                        ),
                ],
              )
            ],
          )),
    );
  }
}

class Controller {
  _StoreEditLocationScreenState state;

  Controller(this.state);

  Location _location = Location();

  String? validateStoreName(String? value) {
    if (value == null || value.length < 1) {
      return 'invalid store name min char 1';
    } else {
      return null;
    }
  }

  void saveStoreName(String? value) {
    _location.StoreName = value!;
  }

  String? validateStoreAddress(String? value) {
    if (value!.length == 0) {
      return 'Please enter store address';
    } else {
      return null;
    }
  }

  void saveStoreAddress(String? value) {
    _location.StoreAddress = value!;
  }

  Future<void> onSave() async {
    if (!state.formKey.currentState!.validate()) {
      return;
    }

    MyDialog.circularProgressStart(state.context);
    state.formKey.currentState!.save();

    try {
      await FirebaseController.addLocation(_location);

      MyDialog.circularProgressStop(state.context);
      Navigator.pop(state.context);
    } catch (e) {
      MyDialog.circularProgressStop(state.context);
      MyDialog.info(context: state.context, title: 'Error', content: '$e');
    }
  }

  // Still working on this function
  Future<void> onUpdate() async {
    if (!state.formKey.currentState!.validate()) {
      return;
    }

    // MyDialog.circularProgressStart(state.context);
    state.formKey.currentState!.save();

    print("Store name = " + _location.StoreName);
  }

  Future<void> delete() async {
    if (!state.formKey.currentState!.validate()) {
      return;
    }

    MyDialog.circularProgressStart(state.context);
    state.formKey.currentState!.save();
    try {
      await FirebaseController.deleteLocation(_location.StoreName);
      MyDialog.circularProgressStop(state.context);
      Navigator.pop(state.context);
    } catch (e) {
      MyDialog.circularProgressStop(state.context);
      MyDialog.info(context: state.context, title: 'Error', content: '$e');
    }
  }
}
