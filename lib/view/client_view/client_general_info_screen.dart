import 'dart:core';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:monkey_management/controller/firebase_controller.dart';
import 'package:monkey_management/model/data.dart';
import 'package:monkey_management/model/client.dart';
import 'package:monkey_management/view/client_view/client_screen.dart';
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
  bool? isNewUser;

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

    print('Email: $email');
    print('Password: $password');
    return Scaffold(
      appBar: AppBar(
        title: Center(child: Text('Account Settings')),
        backgroundColor: Colors.grey[850],
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
                      child: Text("Finish", style: Theme.of(context).textTheme.button),
                    ),
                  ],
                ),
              )
            : //IS ALREADY A CLIENT
            
            Column(
              children: [
                //EMAIL
                  SizedBox(height: 7,),
                  Container(
                    margin: EdgeInsets.fromLTRB(4, 10, 0, 0),
                    alignment: Alignment.centerLeft,
                    child: 
                    Text(
                      "Email",
                      textAlign: TextAlign.start,
                      style: TextStyle(
                        fontWeight:  FontWeight.bold,
                        fontSize: 18,
                      ),
                    ),
                  ),
                  Container(
                    margin: EdgeInsets.fromLTRB(0, 10.0, 0, 10.0),
                    padding: EdgeInsets.fromLTRB(2, 0, 2, 0),
                    child: TextFormField(
                      //enabled: editMode,
                      initialValue: clientProfile!.email,
                      decoration: InputDecoration(
                        border: OutlineInputBorder(),
                      ),
                      //validator: con?.validateFirstName,
                      //onSaved: con?.saveFirstName,
                    ),
                  ),
                  SizedBox(height: 10,),

                //FIRST NAME
                  Container(
                    margin: EdgeInsets.fromLTRB(4, 10, 0, 0),
                    alignment: Alignment.centerLeft,
                    child: 
                    Text(
                      "First Name",
                      textAlign: TextAlign.start,
                      style: TextStyle(
                        fontWeight:  FontWeight.bold,
                        fontSize: 18,
                      ),
                    ),
                  ),
                  Container(
                    margin: EdgeInsets.fromLTRB(0, 10.0, 0, 10.0),
                    padding: EdgeInsets.fromLTRB(2, 0, 2, 0),
                    child: TextFormField(
                      enabled: false, //Will need to change to bool editMode -Caitlyn
                      initialValue: clientProfile!.firstName,
                      decoration: InputDecoration(
                        border: OutlineInputBorder(),
                      ),
                      //validator: con?.validateFirstName,
                      //onSaved: con?.saveFirstName,
                    ),
                  ),
                  SizedBox(height: 10,),

                  //LAST NAME
                  Container(
                    margin: EdgeInsets.fromLTRB(4, 10, 0, 0),
                    alignment: Alignment.centerLeft,
                    child: 
                    Text(
                      "Last Name",
                      textAlign: TextAlign.start,
                      style: TextStyle(
                        
                        fontWeight:  FontWeight.bold,
                        fontSize: 18,
                      ),
                    ),
                  ),
                  Container(
                    margin: EdgeInsets.fromLTRB(0, 10.0, 0, 10.0),
                    padding: EdgeInsets.fromLTRB(2, 0, 2, 0),
                    child: TextFormField(
                      enabled: false, //Will need to change to bool editMode -Caitlyn
                      initialValue: clientProfile!.lastName,
                      decoration: InputDecoration(
                        border: OutlineInputBorder(),
                      ),
                      //validator: con?.validateFirstName,
                      //onSaved: con?.saveFirstName,
                    ),
                  ),
                  SizedBox(height: 10,),

                  //FAV LOCATION
                  Container(
                    margin: EdgeInsets.fromLTRB(4, 10, 0, 0),
                    alignment: Alignment.centerLeft,
                    child: 
                    Text(
                      "Preferred Location",
                      textAlign: TextAlign.start,
                      style: TextStyle(
                        fontWeight:  FontWeight.bold,
                        fontSize: 18,
                      ),
                    ),
                  ),
                  Container(
                    margin: EdgeInsets.fromLTRB(0, 10.0, 0, 10.0),
                    padding: EdgeInsets.fromLTRB(2, 0, 2, 0),
                    child: TextFormField(
                      enabled: false, //Will need to change to bool editMode -Caitlyn
                      initialValue: clientProfile!.favLocation,
                      decoration: InputDecoration(
                        border: OutlineInputBorder(),
                      ),
                      //validator: con?.validateFirstName,
                      //onSaved: con?.saveFirstName,
                    ),
                  ),
                  SizedBox(height: 10,),

                  //PHONE NUMBER
                  Container(
                    alignment: Alignment.centerLeft,
                    child: 
                    Text(
                      "Phone Number",
                      textAlign: TextAlign.start,
                      style: TextStyle(
                        fontWeight:  FontWeight.bold,
                        fontSize: 18,
                      ),
                    ),
                  ),
                  Container(
                    margin: EdgeInsets.fromLTRB(0, 10.0, 0, 10.0),
                    padding: EdgeInsets.fromLTRB(2, 0, 2, 0),
                    child: TextFormField(
                      enabled: false, //Will need to change to bool editMode -Caitlyn
                      initialValue: clientProfile!.phone!.isEmpty ? clientProfile!.phone : "555-555-5555", ///???
                      decoration: InputDecoration(
                        border: OutlineInputBorder(),
                      ),
                      //validator: con?.validateFirstName,
                      //onSaved: con?.saveFirstName,
                    ),
                  ),
                  SizedBox(height: 10,),

                  //ADDRESS
                  Container(
                    alignment: Alignment.centerLeft,
                    margin: EdgeInsets.fromLTRB(4, 10, 0, 0),
                    child: 
                    Text(
                      "Address",
                      textAlign: TextAlign.start,
                      style: TextStyle(
                        fontWeight:  FontWeight.bold,
                        fontSize: 18,
                      ),
                    ),
                  ),
                  Container(
                    margin: EdgeInsets.fromLTRB(0, 10.0, 0, 10.0),
                    padding: EdgeInsets.fromLTRB(2, 0, 2, 0),
                    child: TextFormField(
                      enabled: false, //Will need to change to bool editMode -Caitlyn
                      initialValue: clientProfile!.address,
                      decoration: InputDecoration(
                        border: OutlineInputBorder(),
                      ),
                      //validator: con?.validateFirstName,
                      //onSaved: con?.saveFirstName,
                    ),
                  ),
                  SizedBox(height: 10),

                  //VEHICLE COLOR
                  Container(
                    alignment: Alignment.centerLeft,
                    margin: EdgeInsets.fromLTRB(4, 10, 0, 0),
                    child: 
                    Text(
                      "Vehicle Color",
                      textAlign: TextAlign.start,
                      style: TextStyle(
                        fontWeight:  FontWeight.bold,
                        fontSize: 18,
                      ),
                    ),
                  ),
                  Container(
                    margin: EdgeInsets.fromLTRB(0, 10.0, 0, 10.0),
                    padding: EdgeInsets.fromLTRB(2, 0, 2, 0),
                    child: TextFormField(
                      enabled: false, //Will need to change to bool editMode -Caitlyn
                      initialValue: clientProfile!.vehicleColor,
                      decoration: InputDecoration(
                        border: OutlineInputBorder(),
                      ),
                      //validator: con?.validateFirstName,
                      //onSaved: con?.saveFirstName,
                    ),
                  ),
                  SizedBox(height: 10),

                  //VEHICLE MAKE
                  Container(
                    alignment: Alignment.centerLeft,
                    margin: EdgeInsets.fromLTRB(4, 10, 0, 0),
                    child: 
                    Text(
                      "Vehicle Make",
                      textAlign: TextAlign.start,
                      style: TextStyle(
                        fontWeight:  FontWeight.bold,
                        fontSize: 18,
                      ),
                    ),
                  ),
                  Container(
                    margin: EdgeInsets.fromLTRB(0, 10.0, 0, 10.0),
                    padding: EdgeInsets.fromLTRB(2, 0, 2, 0),
                    child: TextFormField(
                      enabled: false, //Will need to change to bool editMode -Caitlyn
                      initialValue: clientProfile!.vehicleMake,
                      decoration: InputDecoration(
                        border: OutlineInputBorder(),
                      ),
                      //validator: con?.validateFirstName,
                      //onSaved: con?.saveFirstName,
                    ),
                  ),
                  SizedBox(height: 90)
              ],
            ),
      ),
    );
  }
}

class Controller {
  ClientGeneralInfoState state;
  Controller(this.state);
  String? firstName;
  String? lastName;
  String? address;
  User? user;

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
      return 'invalid address min char 5';
    } else {
      return null;
    }
  }

  void saveAddress(String? value) {
    this.address = value;
  }

  String? validateLastName(String? value) {
    if (value!.length == 0) {
      return 'Please enter your last name';
    } else {
      return null;
    }
  }

  void saveLastName(String? value) {
    this.lastName = value;
  }

  String? validateFirstName(String? value) {
    if (value!.length == 0) {
      return 'Please enter your first name';
    } else {
      return null;
    }
  }

  void saveFirstName(String? value) {
    this.firstName = value;
  }
}
