import 'package:flutter/material.dart';
import 'package:monkey_management/controller/firebase_controller.dart';
import 'package:monkey_management/view/common_view/mydialog.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:monkey_management/model/store.dart';
import 'package:monkey_management/view/common_view/loading_screen.dart';

class StoreOptionsScreen extends StatefulWidget {
  static const routeName = "/options_screen";

  @override
  _StoreOptionsScreenState createState() {
    return _StoreOptionsScreenState();
  }
}

class _StoreOptionsScreenState extends State<StoreOptionsScreen> {
  Controller? con;

  var formKey = GlobalKey<FormState>();
  String? email;
  String? storePhone;
  String? storeAddress;
  String? storeName;
  bool? isNewLocation = false; //is a test
  Store? storeProfile;
  Store? tempProfile;

  @override
  void initState() {
    super.initState();
    con = Controller(this);
  }

  void render(fn) => setState(fn);

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
        future: con!.fetchData(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) return LoadingScreen();
          if (snapshot.connectionState == ConnectionState.done)
            return WillPopScope(
                onWillPop: () => Future.value(true),
                child: Scaffold(
                  //resizeToAvoidBottomInset: false,
                  appBar: AppBar(
                    title: Padding(
                      padding: const EdgeInsets.only(left: 70, right: 20),
                      child: Text(
                        'Edit Store Options',
                        style: TextStyle(color: Colors.black),
                      ),
                    ),
                    foregroundColor: Colors.black,
                    backgroundColor: Colors.pinkAccent[400],
                  ),
                  body: Container(
                      padding: EdgeInsets.all(8.0),
                      child: SingleChildScrollView(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            SingleChildScrollView(
                              child: isNewLocation!
                                  ?
                                  // New Store
                                  Form(
                                      key: formKey,
                                      child: Column(
                                        children: [
                                          Container(
                                            margin: EdgeInsets.fromLTRB(0, 10.0, 0, 10.0),
                                            child: TextFormField(
                                              decoration: InputDecoration(
                                                hintText: "Name",
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
                                          Container(
                                            margin: EdgeInsets.fromLTRB(0, 10.0, 0, 10.0),
                                            child: TextFormField(
                                              decoration: InputDecoration(
                                                hintText: "Phone Number",
                                                border: OutlineInputBorder(),
                                              ),
                                              validator: con?.validateStorePhone,
                                              onSaved: con?.saveStorePhone,
                                            ),
                                          ),
                                        ],
                                      ),
                                    )
                                  :
                                  // existing store
                                  Form(
                                      key: formKey,
                                      child: Column(
                                        children: [
                                          Container(
                                            margin: EdgeInsets.fromLTRB(4, 10, 0, 0),
                                            alignment: Alignment.centerLeft,
                                            child: Text(
                                              "Store Name:",
                                              textAlign: TextAlign.start,
                                              style: TextStyle(
                                                fontWeight: FontWeight.bold,
                                                fontSize: 18,
                                              ),
                                            ),
                                          ),
                                          //storeName TextBox
                                          Container(
                                            margin: EdgeInsets.fromLTRB(0, 10.0, 0, 10.0),
                                            child: TextFormField(
                                              initialValue: con!.storeName,
                                              decoration: InputDecoration(
                                                // hintText: locationName,
                                                border: OutlineInputBorder(),
                                              ),
                                              validator: con?.validateStoreName,
                                              onSaved: con?.saveStoreName,
                                              onChanged: (String? newValue) {
                                                con!.storeName = newValue;
                                              },
                                            ),
                                          ),
                                          //Start store address
                                          Container(
                                            margin: EdgeInsets.fromLTRB(4, 10, 0, 0),
                                            alignment: Alignment.centerLeft,
                                            child: Text(
                                              "Main Address:",
                                              textAlign: TextAlign.start,
                                              style: TextStyle(
                                                fontWeight: FontWeight.bold,
                                                fontSize: 18,
                                              ),
                                            ),
                                          ),
                                          Container(
                                            margin: EdgeInsets.fromLTRB(0, 10.0, 0, 10.0),
                                            child: TextFormField(
                                              initialValue: con!.storeAddress,
                                              decoration: InputDecoration(
                                                border: OutlineInputBorder(),
                                              ),
                                              validator: con?.validateStoreAddress,
                                              onSaved: con?.saveStoreAddress,
                                              onChanged: (String? newValue) {
                                                con!.storeAddress = newValue;
                                              },
                                            ),
                                          ),
                                          //Start store phone
                                          Container(
                                            margin: EdgeInsets.fromLTRB(4, 10, 0, 0),
                                            alignment: Alignment.centerLeft,
                                            child: Text(
                                              "Store Phone:",
                                              textAlign: TextAlign.start,
                                              style: TextStyle(
                                                fontWeight: FontWeight.bold,
                                                fontSize: 18,
                                              ),
                                            ),
                                          ),
                                          Container(
                                            margin: EdgeInsets.fromLTRB(0, 10.0, 0, 10.0),
                                            child: TextFormField(
                                              initialValue: con!.storePhone,
                                              decoration: InputDecoration(
                                                border: OutlineInputBorder(),
                                              ),
                                              validator: con?.validateStorePhone,
                                              onSaved: con?.saveStoreAddress,
                                              onChanged: (String? newValue) {
                                                con!.storePhone = newValue;
                                              },
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.end,
                              children: [
                                // Update existing location
                                ElevatedButton(
                                  onPressed: con?.onSave,
                                  child: Text("Save",
                                      style: Theme.of(context).textTheme.button),
                                ),
                              ],
                            )
                          ],
                        ),
                      )),
                ));
          else
            return Text("Error");
        });
  }
}

class Controller {
  _StoreOptionsScreenState state;
  late Store storeProfile;
  Controller(this.state);
  String? email;
  String? storePhone;
  String? storeAddress;
  String? storeName;

  Store _store = Store();

  Future<void> fetchData() async {
    try {
      storeProfile = await FirebaseController.getStoreProfile(
          FirebaseAuth.instance.currentUser!.uid);

      storeName = storeProfile.name;
      storePhone = storeProfile.phone;
      storeAddress = storeProfile.address;
    } catch (e) {
      //do nothing
    }
    print("StoreName = " + storeName!);
    print("storeAddress = " + storeAddress!);
    print("storePhone = " + storePhone!);
  }

  String? validateStoreName(String? value) {
    if (value == null || value.length < 1) {
      return 'invalid store name min char 1';
    } else {
      return null;
    }
  }

  void saveStoreName(String? value) {
    _store.name = value!;
  }

  String? validateStoreAddress(String? value) {
    if (value!.length == 0) {
      return 'Please enter store address';
    } else {
      return null;
    }
  }

  String? validateStorePhone(String? value) {
    if (value!.length < 10) {
      return 'Please enter a valid phone number';
    } else {
      return null;
    }
  }

  void saveStoreAddress(String? value) {
    _store.address = value!;
  }

  void saveStorePhone(String? value) {
    _store.phone = value!;
  }

  void onSave() async {
    print("save button pressed");

    //validate stuff
    if (!state.formKey.currentState!.validate()) {
      return;
    }

    print("save button pressed1");
    state.formKey.currentState!.save();
    Store p = new Store();
    p.name = storeName!;
    p.address = storeAddress!;
    p.phone = storePhone!;

    try {
      MyDialog.circularProgressStart(state.context);
      Map<String, dynamic> updateInfo = {};
      updateInfo[Store.NAME] = p.name;
      updateInfo[Store.ADDRESS] = p.address;
      updateInfo[Store.PHONE] = p.phone;

      await FirebaseController.updateStoreProfile(
          FirebaseAuth.instance.currentUser!.uid, updateInfo);

      MyDialog.circularProgressStop(state.context);
      Navigator.pop(state.context);
    } catch (e) {}
  }
}
