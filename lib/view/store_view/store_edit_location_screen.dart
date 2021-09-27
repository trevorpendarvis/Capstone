import 'package:flutter/material.dart';
import 'package:monkey_management/controller/firebase_controller.dart';
import 'package:monkey_management/model/location.dart';
import 'package:monkey_management/view/common_view/mydialog.dart';

class StoreEditLocationScreen extends StatefulWidget {
  static const routeName = "/store_edit_location_screen";

  @override
  _StoreEditLocationScreenState createState() =>
      _StoreEditLocationScreenState();
}

class _StoreEditLocationScreenState extends State<StoreEditLocationScreen> {
  Controller? con;

  var formKey = GlobalKey<FormState>();

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
          'Add Location',
          style: TextStyle(color: Colors.black),
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
                child: Form(
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
                ),
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  ElevatedButton(
                    onPressed: () {},
                    child: Text("Delete",
                        style: Theme.of(context).textTheme.button),
                  ),
                  ElevatedButton(
                    onPressed: con?.onSave,
                    child:
                        Text("Done", style: Theme.of(context).textTheme.button),
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
}
