import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:monkey_management/controller/firebase_controller.dart';
import 'package:monkey_management/model/data.dart';
import 'package:monkey_management/view/client_view/client_screen.dart';
import 'package:monkey_management/view/store_view/store_screen.dart';

class SignInScreen extends StatefulWidget {
  static const routeName = "/signInScreen";
  @override
  State<StatefulWidget> createState() {
    return SignInState();
  }
}

class SignInState extends State<SignInScreen> {
  Controller? con;
  var formkey = GlobalKey<FormState>();
  @override
  void initState() {
    super.initState();
    con = Controller(this);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Sign In'),
      ),
      body: SingleChildScrollView(
        child: Form(
          key: formkey,
          child: Column(
            children: [
              Stack(
                children: [Image.asset('assets/images/MM.png')],
              ),
              TextFormField(
                decoration: InputDecoration(hintText: "Email"),
                autocorrect: false,
                keyboardType: TextInputType.emailAddress,
                validator: con?.validEmail,
                onSaved: con?.onSavedEmail,
              ),
              TextFormField(
                decoration: InputDecoration(hintText: "Password"),
                autocorrect: false,
                obscureText: true,
                validator: con?.validPassword,
                onSaved: con?.onSavedPassword,
              ),
              ElevatedButton(
                  onPressed: con!.signIn,
                  child: Text(
                    'Sign In',
                    style: TextStyle(fontSize: 20.0, color: Colors.white),
                  ))
            ],
          ),
        ),
      ),
    );
  }
}

class Controller {
  SignInState state;
  Controller(this.state);
  String? email;
  String? password;
  late AccountType accountType;

  Future<void> signIn() async {
    if (!state.formkey.currentState!.validate()) {
      return;
    }
    state.formkey.currentState!.save();

    User? user = await FirebaseController.signIn(email: email!, password: password!);

    if (user != null) {
      accountType = await FirebaseController.getAccountType();

      if (accountType == AccountType.STORE) {
        Navigator.pushNamed(state.context, StoreScreen.routeName);
      }
      else if (accountType == AccountType.CLIENT) {
        Navigator.pushNamed(state.context, ClientScreen.routeName);
      }
      else {
        print('error');
      }
    }
    else {
      print('error');
    }
  }

  String? validEmail(String? value) {
    if (value == null || !value.contains("@") || !value.contains(".")) {
      return 'Not a valid Email address';
    }
    return null;
  }

  void onSavedEmail(String? value) {
    this.email = value;
  }

  String? validPassword(String? value) {
    if (value == null || value.length < 6) {
      return 'Not a valid password';
    }
    return null;
  }

  void onSavedPassword(String? value) {
    this.password = value;
  }
}
