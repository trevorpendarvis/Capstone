import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:monkey_management/controller/firebase_controller.dart';
import 'package:monkey_management/model/client.dart';
import 'package:monkey_management/view/common_view/mydialog.dart';
import 'package:monkey_management/view/store_view/store_screen.dart';

class StoreGeneralInfoScreen extends StatefulWidget {
  static const routeName = '/storeGeneralInfoScreen';
  @override
  State<StatefulWidget> createState() {
    return StoreGeneralInfoState();
  }
}

class StoreGeneralInfoState extends State<StoreGeneralInfoScreen> {
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
                    hintText: "Name",
                    border: OutlineInputBorder(),
                  ),
                  validator: con?.validateName,
                  onSaved: con?.saveName,
                ),
              ),
              Container(
                margin: EdgeInsets.fromLTRB(0, 10.0, 0, 10.0),
                child: TextFormField(
                  decoration: InputDecoration(
                    hintText: "Phone Number",
                    border: OutlineInputBorder(),
                  ),
                  keyboardType: TextInputType.phone,
                  validator: con?.validateNumber,
                  onSaved: con?.saveNumber,
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
                onPressed: con?.onSaved,
                child:
                    Text("Finish", style: Theme.of(context).textTheme.button),
              ),
            ],
          ),
        )));
  }
}

class Controller {
  StoreGeneralInfoState state;
  Controller(this.state);
  User? user;
  String? name;
  String? address;
  String? number;

  Future<void> onSaved() async {
    if (!state.formKey.currentState!.validate()) {
      return;
    }

    MyDialog.circularProgressStart(state.context);
    state.formKey.currentState!.save();
    Client p = new Client();
    p.accountType = 'STORE';
    p.firstName = name;
    p.address = address;
    p.email = state.email;
    p.phone = number;

    try {
      user = await FirebaseController.signIn(
          email: state.email, password: state.password);

      p.docId = user!.uid;

      await FirebaseController.addProfile(p);
      MyDialog.circularProgressStop(state.context);
      Navigator.pushReplacementNamed(state.context, StoreScreen.routeName,
          arguments: {'profile': p, 'user': user});
    } catch (e) {
      MyDialog.circularProgressStop(state.context);
      MyDialog.info(context: state.context, title: 'Error', content: '$e');
    }
  }

  String? validateNumber(String? value) {
    if (value == null || value.length < 7) {
      return 'Not a valid phone number';
    } else {
      return null;
    }
  }

  void saveNumber(String? value) {
    this.number = value;
  }

  String? validateAddress(String? value) {
    if (value == null || value.length < 5) {
      return 'invalid addresss min char 5';
    } else {
      return null;
    }
  }

  void saveAddress(String? value) {
    this.address = value;
  }

  String? validateName(String? value) {
    if (value!.length == 0) {
      return 'Please enter your stores';
    } else {
      return null;
    }
  }

  void saveName(String? value) {
    this.name = value;
  }
}
