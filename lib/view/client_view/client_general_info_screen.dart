import 'dart:core';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:monkey_management/controller/firebase_controller.dart';
import 'package:monkey_management/model/data.dart';
import 'package:monkey_management/model/client.dart';
import 'package:monkey_management/model/store.dart';
import 'package:monkey_management/view/client_view/client_screen.dart';
import 'package:monkey_management/view/common_view/loading_screen.dart';
import 'package:monkey_management/view/common_view/mydialog.dart';

class ClientGeneralInfoScreen extends StatefulWidget {
  static const routeName = '/ClientGeneralInfoScreen';

  @override
  State<StatefulWidget> createState() {
    return ClientGeneralInfoState();
  }
}

class ClientGeneralInfoState extends State<ClientGeneralInfoScreen> {
  Controller? con;
  var formKey = GlobalKey<FormState>();
  String? email;
  String? password;
  Client? clientProfile;
  Client? tempProfile;
  bool? isNewUser;
  bool? editMode = false;
  String? dropdownValue;

  @override
  void initState() {
    super.initState();
    con = Controller(this);
  }

  void render(fn) => setState(fn);

  @override
  Widget build(BuildContext context) {
    Map? args = ModalRoute.of(context)!.settings.arguments as Map?;
    email = args!['email'] ?? '';
    password = args['password'] ?? '';
    clientProfile = args['one_clientProfile'] ?? Client();
    isNewUser = args['isNewUser'] ?? true;

    tempProfile = Client.clone(clientProfile!);
    //String? dropdownValue = tempProfile!.favLocation;
    //print(dropdownValue);
    //dropdownValue = 'One';
    print('Email: $email');
    print('Password: $password');
    return FutureBuilder(
        future: con!.fetchData(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) return LoadingScreen();
          if (snapshot.connectionState == ConnectionState.done)
            return WillPopScope(
              onWillPop: () => Future.value(true),
              child: Scaffold(
                appBar: AppBar(
                  title: Center(child: Text('Account Settings')),
                  backgroundColor: Colors.grey[850],
                  actions: [
                    editMode!
                        ? IconButton(icon: Icon(Icons.check), onPressed: con?.saveUpdates)
                        : IconButton(icon: Icon(Icons.edit), onPressed: con?.editProfile),
                  ],
                ),
                body: SingleChildScrollView(
                  child: isNewUser!
                      ? //IS A NEW CLIENT
                      Form(
                          key: formKey,
                          child: Column(
                            children: [
                              Container(
                                margin: EdgeInsets.fromLTRB(0, 10.0, 0, 10.0),
                                child: TextFormField(
                                  decoration: InputDecoration(
                                    hintText: "First Name",
                                    border: OutlineInputBorder(),
                                  ),
                                  validator: con?.validateFirstName,
                                  onSaved: con?.saveFirstName,
                                ),
                              ),
                              Container(
                                margin: EdgeInsets.fromLTRB(0, 10.0, 0, 10.0),
                                child: TextFormField(
                                  decoration: InputDecoration(
                                    hintText: "Last Name",
                                    border: OutlineInputBorder(),
                                  ),
                                  validator: con?.validateLastName,
                                  onSaved: con?.saveLastName,
                                ),
                              ),
                              Container(
                                margin: EdgeInsets.fromLTRB(0, 10.0, 0, 10.0),
                                child: TextFormField(
                                  decoration: InputDecoration(
                                    hintText: "Address",
                                    border: OutlineInputBorder(),
                                  ),
                                  validator: con?.validateAddress,
                                  onSaved: con?.saveAddress,
                                ),
                              ),
                              ElevatedButton(
                                onPressed: con?.onSave,
                                child: Text("Finish",
                                    style: Theme.of(context).textTheme.button),
                              ),
                            ],
                          ),
                        )
                      : //IS ALREADY A CLIENT
                      Form(
                          key: formKey,
                          child: Column(
                            children: [
                              //EMAIL
                              SizedBox(
                                height: 7,
                              ),
                              Container(
                                margin: EdgeInsets.fromLTRB(4, 10, 0, 0),
                                alignment: Alignment.centerLeft,
                                child: Text(
                                  "Email",
                                  textAlign: TextAlign.start,
                                  style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    fontSize: 18,
                                  ),
                                ),
                              ),
                              Container(
                                margin: EdgeInsets.fromLTRB(0, 10.0, 0, 10.0),
                                padding: EdgeInsets.fromLTRB(2, 0, 2, 0),
                                child: TextFormField(
                                  enabled: false,
                                  initialValue: clientProfile!.email,
                                  decoration: InputDecoration(
                                    border: OutlineInputBorder(),
                                  ),
                                ),
                              ),
                              SizedBox(
                                height: 10,
                              ),

                              //FIRST NAME
                              Container(
                                margin: EdgeInsets.fromLTRB(4, 10, 0, 0),
                                alignment: Alignment.centerLeft,
                                child: Text(
                                  "First Name",
                                  textAlign: TextAlign.start,
                                  style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    fontSize: 18,
                                  ),
                                ),
                              ),
                              Container(
                                margin: EdgeInsets.fromLTRB(0, 10.0, 0, 10.0),
                                padding: EdgeInsets.fromLTRB(2, 0, 2, 0),
                                child: TextFormField(
                                  enabled: editMode, //enable changes
                                  initialValue:
                                      tempProfile!.firstName, //clientProfile!.firstName,
                                  decoration: InputDecoration(
                                    border: OutlineInputBorder(),
                                  ),
                                  validator: con?.validateFirstName,
                                  onSaved: con?.saveFirstName,
                                ),
                              ),
                              SizedBox(
                                height: 10,
                              ),

                              //LAST NAME
                              Container(
                                margin: EdgeInsets.fromLTRB(4, 10, 0, 0),
                                alignment: Alignment.centerLeft,
                                child: Text(
                                  "Last Name",
                                  textAlign: TextAlign.start,
                                  style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    fontSize: 18,
                                  ),
                                ),
                              ),
                              Container(
                                margin: EdgeInsets.fromLTRB(0, 10.0, 0, 10.0),
                                padding: EdgeInsets.fromLTRB(2, 0, 2, 0),
                                child: TextFormField(
                                  enabled: editMode,
                                  initialValue: tempProfile!.lastName,
                                  decoration: InputDecoration(
                                    border: OutlineInputBorder(),
                                  ),
                                  validator: con?.validateLastName,
                                  onSaved: con?.saveLastName,
                                ),
                              ),
                              SizedBox(
                                height: 10,
                              ),

                              //FAV LOCATION – USE DROPDOWN MENU
                              Container(
                                margin: EdgeInsets.fromLTRB(4, 10, 0, 0),
                                alignment: Alignment.centerLeft,
                                child: Text(
                                  "Preferred Location",
                                  textAlign: TextAlign.start,
                                  style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    fontSize: 18,
                                  ),
                                ),
                              ),

                              Container(
                                margin: EdgeInsets.fromLTRB(4, 10, 0, 0),
                                alignment: Alignment.topCenter,
                                width: MediaQuery.of(context).size.width,
                                child: DropdownButton<String>(
                                  itemHeight: 48,
                                  isExpanded: true,
                                  value: dropdownValue = con!.dropdownValue,
                                  icon: const Icon(Icons.arrow_downward),
                                  iconSize: 16,
                                  elevation: 16,
                                  style: const TextStyle(color: Colors.black),
                                  underline: Container(
                                    height: 2,
                                    color: Colors.black,
                                  ),
                                  onChanged: (String? newValue) {
                                    setState(() {
                                      if (editMode == true) {
                                        dropdownValue = newValue;
                                        con!.saveFavLocationToFirebase(newValue!);
                                      } else {
                                        MyDialog.info(
                                            context: con!.state.context,
                                            title: "Not in Edit mode",
                                            content:
                                                "Please press the edit button to change Preferred Location");
                                      }
                                      return null;
                                    }
                                        //con!.saveFavLocation(newValue!);
                                        );
                                  },
                                  items: con!.storeNames
                                      .map<DropdownMenuItem<String>>((String value) {
                                    return DropdownMenuItem<String>(
                                      value: value,
                                      child: Text(value),
                                    );
                                  }).toList(),
                                ),
                              ),
                              SizedBox(
                                height: 10,
                              ),

                              //PHONE NUMBER
                              Container(
                                alignment: Alignment.centerLeft,
                                child: Text(
                                  "Phone Number",
                                  textAlign: TextAlign.start,
                                  style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    fontSize: 18,
                                  ),
                                ),
                              ),
                              Container(
                                margin: EdgeInsets.fromLTRB(0, 10.0, 0, 10.0),
                                padding: EdgeInsets.fromLTRB(2, 0, 2, 0),
                                child: TextFormField(
                                  enabled: editMode,
                                  initialValue: tempProfile!.phone,
                                  decoration: InputDecoration(
                                    border: OutlineInputBorder(),
                                  ),
                                  //validator: con?.validatePhone //NEED TO IMPLEMENT
                                  onSaved: con?.savePhone,
                                ),
                              ),
                              SizedBox(
                                height: 10,
                              ),

                              //ADDRESS
                              Container(
                                alignment: Alignment.centerLeft,
                                margin: EdgeInsets.fromLTRB(4, 10, 0, 0),
                                child: Text(
                                  "Address",
                                  textAlign: TextAlign.start,
                                  style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    fontSize: 18,
                                  ),
                                ),
                              ),
                              Container(
                                margin: EdgeInsets.fromLTRB(0, 10.0, 0, 10.0),
                                padding: EdgeInsets.fromLTRB(2, 0, 2, 0),
                                child: TextFormField(
                                  enabled: editMode,
                                  initialValue: tempProfile!.address,
                                  decoration: InputDecoration(
                                    border: OutlineInputBorder(),
                                  ),
                                  validator: con?.validateAddress,
                                  onSaved: con?.saveAddress,
                                ),
                              ),
                              SizedBox(height: 10),

                              //VEHICLE COLOR – USE DROPDOWN
                              Container(
                                alignment: Alignment.centerLeft,
                                margin: EdgeInsets.fromLTRB(4, 10, 0, 0),
                                child: Text(
                                  "Vehicle Color",
                                  textAlign: TextAlign.start,
                                  style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    fontSize: 18,
                                  ),
                                ),
                              ),
                              Container(
                                margin: EdgeInsets.fromLTRB(0, 10.0, 0, 10.0),
                                padding: EdgeInsets.fromLTRB(2, 0, 2, 0),
                                child: TextFormField(
                                  enabled: editMode,
                                  initialValue: tempProfile!.vehicleColor,
                                  decoration: InputDecoration(
                                    border: OutlineInputBorder(),
                                  ),
                                  //validator: con?.validateFirstName,
                                  onSaved: con?.saveVehicleColor,
                                ),
                              ),
                              SizedBox(height: 10),

                              //VEHICLE MAKE
                              Container(
                                alignment: Alignment.centerLeft,
                                margin: EdgeInsets.fromLTRB(4, 10, 0, 0),
                                child: Text(
                                  "Vehicle Make",
                                  textAlign: TextAlign.start,
                                  style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    fontSize: 18,
                                  ),
                                ),
                              ),
                              Container(
                                margin: EdgeInsets.fromLTRB(0, 10.0, 0, 10.0),
                                padding: EdgeInsets.fromLTRB(2, 0, 2, 0),
                                child: TextFormField(
                                  enabled: editMode,
                                  initialValue: tempProfile!.vehicleMake,
                                  decoration: InputDecoration(
                                    border: OutlineInputBorder(),
                                  ),
                                  //validator: con?.validateFirstName,
                                  onSaved: con?.saveVehicleMake,
                                ),
                              ),
                              SizedBox(height: 90)
                            ],
                          ),
                        ),
                ),
              ),
            );
          else
            return Text("Error");
        });
  }
}

class Controller {
  ClientGeneralInfoState state;
  Controller(this.state);
  String? firstName;
  String? lastName;
  String? address;
  User? user;
  List<Store> stores = [];
  List<String> storeNames = [];
  late Client clientProfile;
  String? dropdownValue;

  Future<void> fetchData() async {
    stores = await FirebaseController.fetchStores();
    storeNames = [];
    clientProfile =
        await FirebaseController.getClientProfile(FirebaseAuth.instance.currentUser!.uid);

    for (int i = 0; i < stores.length; i++) {
      storeNames.add(stores[i].name);
    }

    if (clientProfile.favLocation == "" ||
        storeNames.contains(clientProfile.favLocation) == false) {
      dropdownValue = storeNames[0];
    } else {
      dropdownValue = clientProfile.favLocation;
    }

    print(storeNames);
    // Appointment appointment = Appointment();
    // await FirebaseController.addAppointment(appointment);
  }

  Future<void> accountSettings(String? uid) async {
    await Navigator.pushNamed(state.context, ClientGeneralInfoScreen.routeName,
        arguments: {
          // "user": state.user,
          "one_clientProfile": clientProfile,
          'isNewUser': false,
        });
    Navigator.pop(state.context); //pop the drawer
    state.render(() {});
  }

  void saveStores(List<Store> stores) {
    storeNames = [];
    for (int i = 0; i < stores.length; i++) {
      storeNames.add(stores[i].name);
    }
    print(storeNames);
  }

  Future<void> onSave() async {
    if (!state.formKey.currentState!.validate()) {
      return;
    }

    MyDialog.circularProgressStart(state.context);
    state.formKey.currentState!.save();
    Client p = new Client();
    p.firstName = firstName;
    p.lastName = lastName;
    p.address = address;
    p.email = state.email;

    try {
      user =
          await FirebaseController.signIn(email: state.email, password: state.password);

      p.docId = user!.uid;

      await FirebaseController.addClientProfile(p);
      MyDialog.circularProgressStop(state.context);
      Navigator.pushReplacementNamed(state.context, ClientScreen.routeName,
          arguments: {'profile': p, 'user': user});
    } catch (e) {
      MyDialog.circularProgressStop(state.context);
      MyDialog.info(context: state.context, title: 'Error', content: '$e');
    }
  }

  String? validateAddress(String? value) {
    if (value == null || value.length < 5) {
      return 'Address must be at least 5 characters.';
    } else {
      return null;
    }
  }

  void saveAddress(String? value) {
    this.address = value;

    state.tempProfile!.address = value;
  }

  String? validateLastName(String? value) {
    if (value!.length == 0) {
      return 'Please enter your last name.';
    } else {
      return null;
    }
  }

  Future<bool> checkEditMode() async {
    if (true) {
      return true;
    } else {
      return false;
    }
  }

  void saveLastName(String? value) {
    this.lastName = value;

    state.tempProfile!.lastName = value;
  }

  String? validateFirstName(String? value) {
    if (value!.length == 0) {
      return 'Please enter your first name.';
    } else {
      return null;
    }
  }

  void saveFirstName(String? value) {
    this.firstName = value;

    state.tempProfile!.firstName = value;
  }

  void saveFavLocation(String? value) {
    state.tempProfile!.favLocation = value;
    print(state.tempProfile!.favLocation);
  }

  void savePhone(String? value) {
    state.tempProfile!.phone = value;
  }

  void saveVehicleColor(String? value) {
    state.tempProfile!.vehicleColor = value;
  }

  void saveVehicleMake(String? value) {
    state.tempProfile!.vehicleMake = value;
  }

  void saveUpdates() async {
    if (!state.formKey.currentState!.validate()) return;
    state.formKey.currentState!.save();

    try {
      MyDialog.circularProgressStart(state.context);
      Map<String, dynamic> updateInfo = {};

      if (state.clientProfile!.firstName != state.tempProfile!.firstName)
        updateInfo[Client.FIRSTNAME] = state.tempProfile!.firstName;

      if (state.clientProfile!.lastName != state.tempProfile!.lastName)
        updateInfo[Client.LASTNAME] = state.tempProfile!.lastName;

      if (state.clientProfile!.favLocation != state.tempProfile!.favLocation)
        updateInfo[Client.FAV_LOCATION] = state.tempProfile!.favLocation;

      if (state.clientProfile!.phone != state.tempProfile!.phone)
        updateInfo[Client.PHONE] = state.tempProfile!.phone;

      if (state.clientProfile!.address != state.tempProfile!.address)
        updateInfo[Client.ADDRESS] = state.tempProfile!.address;

      if (state.clientProfile!.vehicleColor != state.tempProfile!.vehicleColor)
        updateInfo[Client.VEHICLE_COLOR] = state.tempProfile!.vehicleColor;

      if (state.clientProfile!.vehicleMake != state.tempProfile!.vehicleMake)
        updateInfo[Client.VEHICLE_MAKE] = state.tempProfile!.vehicleMake;

      await FirebaseController.updateClientProfile(
          FirebaseAuth.instance.currentUser!.uid, updateInfo);
      state.clientProfile!.assign(state.tempProfile!);

      MyDialog.circularProgressStop(state.context);
      Navigator.pop(state.context);
    } catch (e) {
      MyDialog.circularProgressStop(state.context);
      MyDialog.info(
          context: state.context, title: "Error Updating Account", content: "$e");
    }
  }

  void saveFavLocationToFirebase(String newFav) async {
    try {
      MyDialog.circularProgressStart(state.context);
      Map<String, dynamic> updateInfo = {};

      updateInfo[Client.FAV_LOCATION] = newFav;

      await FirebaseController.updateClientProfile(
          FirebaseAuth.instance.currentUser!.uid, updateInfo);
      state.clientProfile!.assign(state.tempProfile!);

      MyDialog.circularProgressStop(state.context);
    } catch (e) {
      MyDialog.circularProgressStop(state.context);
      MyDialog.info(
          context: state.context, title: "Error Updating favLocation", content: "$e");
    }
  }

  void editProfile() {
    state.render(() => state.editMode = true);
  }
}
