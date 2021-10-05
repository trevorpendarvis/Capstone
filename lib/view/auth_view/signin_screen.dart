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
        backgroundColor: Colors.white,
        title: Text(
          'Hello! Please Sign In!',
          //textAlign: TextAlign.right,
          style: TextStyle(color: Colors.pink[500], fontFamily: 'BowlbyOneSC', fontSize: 20.0),
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
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: TextFormField(
                  decoration: InputDecoration(
                    labelText: 'Email',
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(30),
                      borderSide: BorderSide(color: Colors.black, width: 2.0),
                    ),
                    // fillColor: Colors.black12,
                    // filled: true,
                  ),
                  autocorrect: false,
                  keyboardType: TextInputType.emailAddress,
                  validator: con?.validEmail,
                  onSaved: con?.onSavedEmail,
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(left: 8.0, bottom: 8.0, right: 8.0),
                child: TextFormField(
                  decoration: InputDecoration(
                    labelText: 'Password',
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(30),
                      borderSide: BorderSide(color: Colors.black, width: 2.0),
                    ),
                    // fillColor: Colors.black12,
                    // filled: true,
                  ),
                  autocorrect: false,
                  obscureText: true,
                  validator: con?.validPassword,
                  onSaved: con?.onSavedPassword,
                ),
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
                  style: TextStyle(fontSize: 16.0, color: Colors.white, fontWeight: FontWeight.bold),
                ),
              ),
              SizedBox(
                height: 5.0,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text('Does\'t have an account?',
                      style: TextStyle(
                        fontSize: 16.0,
                      )),
                  TextButton(
                    // style: ButtonStyle(
                    //   backgroundColor: MaterialStateProperty.all(
                    //     Colors.pink[400],
                    //   ),
                    // ),
                    onPressed: con!.signUp,
                    child: Text(
                      "Join",
                      style: TextStyle(fontSize: 16.0, fontWeight: FontWeight.bold, color: Colors.pink[400]),
                    ),
                  ),
                ],
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
    User? user = await FirebaseController.signIn(email: email!, password: password!);

    if (user != null) {
      accountType = await FirebaseController.getAccountType();


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
