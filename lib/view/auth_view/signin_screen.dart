import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:monkey_management/controller/firebase_controller.dart';
import 'package:monkey_management/model/data.dart';
import 'package:monkey_management/model/store.dart';
import 'package:monkey_management/view/auth_view/signup_screen.dart';
import 'package:monkey_management/view/client_view/client_screen.dart';
import 'package:monkey_management/view/common_view/mydialog.dart';
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
        title: Padding(
          padding: const EdgeInsets.only(
            left: 65.0,
            right: 10.0,
          ),
          child: Text(
            'Hello! Please Sign In!',
            //textAlign: TextAlign.right,
            style: TextStyle(
                color: Colors.pink[500],
                fontFamily: 'BowlbyOneSC',
                fontSize: 20.0),
          ),
        ),
      ),
      body: SingleChildScrollView(
        child: Form(
          key: formkey,
          child: Column(
            children: [
              Stack(
                children: [Image.asset('assets/images/MonkeyMGMT.png')],
              ),
              TextFormField(
                decoration: InputDecoration(
                  hintText: "Email",
                  border: OutlineInputBorder(),
                ),
                autocorrect: false,
                keyboardType: TextInputType.emailAddress,
                validator: con?.validEmail,
                onSaved: con?.onSavedEmail,
              ),
              TextFormField(
                decoration: InputDecoration(
                  hintText: "Password",
                  border: OutlineInputBorder(),
                ),
                autocorrect: false,
                obscureText: true,
                validator: con?.validPassword,
                onSaved: con?.onSavedPassword,
              ),
              SizedBox(
                height: 15.0,
              ),
              ElevatedButton(
                style: ButtonStyle(
                  backgroundColor: MaterialStateProperty.all(
                    Colors.pink[400],
                  ),
                ),
                onPressed: con!.signIn,
                child: Text(
                  'Sign In',
                  style: TextStyle(fontSize: 20.0, color: Colors.black),
                ),
              ),
              SizedBox(
                height: 5.0,
              ),
              ElevatedButton(
                style: ButtonStyle(
                  backgroundColor: MaterialStateProperty.all(
                    Colors.pink[400],
                  ),
                ),
                onPressed: con!.signUp,
                child: Text(
                  "Create a new account",
                  style: TextStyle(fontSize: 20.0, color: Colors.black),
                ),
              ),
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
    MyDialog.circularProgressStart(state.context);
    User? user =
        await FirebaseController.signIn(email: email!, password: password!);

    if (user != null) {
      accountType = await FirebaseController.getAccountType();

      MyDialog.circularProgressStop(state.context);

      if (accountType == AccountType.STORE) {
        Navigator.pushNamed(state.context, StoreScreen.routeName);
      } else if (accountType == AccountType.CLIENT) {
        Navigator.pushNamed(state.context, ClientScreen.routeName);
      } else {
        print('error');
      }
    } else {
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

  void signUp() {
    //navigate to sign up screen.
    Navigator.pushNamed(state.context, SignUpScreen.routeName);
  }
}
