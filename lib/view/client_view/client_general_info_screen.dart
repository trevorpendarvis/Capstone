import 'dart:core';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
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

  @override
  void initState() {
    super.initState();
    con = Controller(this);
  }

  void render(fn) => setState(fn);

  @override
  Widget build(BuildContext context) {
    Map? args = ModalRoute.of(context)!.settings.arguments as Map?;
    email = args!['email'];
    password = args['password'];
    print('Email: $email');
    print('Password: $password');
    return Scaffold(
      appBar: AppBar(
        title: Center(child: Text('Monkey Management')),
        backgroundColor: Colors.grey[850],
      ),
      body: SingleChildScrollView(
        child: Form(
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
                child:
                    Text("Finish", style: Theme.of(context).textTheme.button),
              ),
            ],
          ),
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
      user = await FirebaseController.signIn(
          email: state.email, password: state.password);

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
