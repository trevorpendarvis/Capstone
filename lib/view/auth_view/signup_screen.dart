import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:monkey_management/controller/firebase_controller.dart';
import 'package:monkey_management/model/client.dart';
import 'package:monkey_management/view/client_view/client_general_info_screen.dart';
import 'package:monkey_management/view/common_view/mydialog.dart';
import 'package:monkey_management/view/store_view/store_general_info_screen.dart';

class SignUpScreen extends StatefulWidget {
  static const routeName = "/signUpScreen";
  @override
  State<StatefulWidget> createState() {
    return _SignUpState();
  }
}

class _SignUpState extends State<SignUpScreen> {
  late _Controller con;
  GlobalKey<FormState> formKey = GlobalKey<FormState>();
  String? dropdownValue;

  @override
  void initState() {
    super.initState();
    con = _Controller(this);
  }

  void render(fn) => setState(fn);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[700],
      appBar: AppBar(
        title: Padding(
          padding: const EdgeInsets.only(left: 10, right: 20),
          child: Text(
            "Create a New Account",
            style: TextStyle(
                color: Colors.pinkAccent[400],
                fontSize: 25,
                fontWeight: FontWeight.bold),
          ),
        ),
        backgroundColor: Colors.grey[850],
      ),
      body: Padding(
        padding: const EdgeInsets.only(top: 10.0, right: 15.0, left: 15.0),
        child: Form(
          key: formKey,
          child: SingleChildScrollView(
            child: Column(
              children: [
                SizedBox(
                  height: 20.0,
                ),
                Text(
                  "Welcome, please sign up!",
                  style: TextStyle(
                    color: Colors.pinkAccent[400],
                    fontSize: 25,
                    fontWeight: FontWeight.bold,
                    decorationThickness: 10,
                  ),
                ),
                SizedBox(
                  height: 25.0,
                ),
                Padding(
                  padding: const EdgeInsets.only(bottom: 0.0),
                  child: Stack(
                    children: [
                      Image.asset(
                        'assets/images/MonkeyLogo.png',
                        height: 100.0,
                        width: 100.0,
                      )
                    ],
                  ),
                ),
                SizedBox(
                  height: 20.0,
                ),
                Container(
                  margin: EdgeInsets.fromLTRB(0, 10.0, 0, 10.0),
                  child: TextFormField(
                    style: TextStyle(fontWeight: FontWeight.bold),
                    decoration: InputDecoration(
                      hintText: "Email",
                      border: OutlineInputBorder(),
                    ),
                    keyboardType: TextInputType.emailAddress,
                    autocorrect: false,
                    validator: con.validateEmail,
                    onSaved: con.saveEmail,
                  ),
                ),
                Container(
                  margin: EdgeInsets.fromLTRB(0, 10.0, 0, 10.0),
                  child: TextFormField(
                    style: TextStyle(fontWeight: FontWeight.bold),
                    decoration: InputDecoration(
                      hintText: "Password",
                      border: OutlineInputBorder(
                        borderSide: BorderSide(
                          color: Colors.pink,
                          width: 1.5,
                        ),
                      ),
                    ),
                    obscureText: true,
                    autocorrect: false,
                    validator: con.validatePassword,
                    onSaved: con.savePassword,
                  ),
                ),
                Container(
                  margin: EdgeInsets.fromLTRB(0, 10.0, 0, 10.0),
                  child: TextFormField(
                    style: TextStyle(fontWeight: FontWeight.bold),
                    decoration: InputDecoration(
                      hintText: "Confirm Password",
                      border: OutlineInputBorder(),
                    ),
                    obscureText: true,
                    autocorrect: false,
                    validator: con.validatePassword,
                    onSaved: con.savePasswordConfirm,
                  ),
                ),
                Container(
                  margin: EdgeInsets.fromLTRB(0, 10.0, 0, 10.0),
                  decoration: BoxDecoration(
                    border: Border.all(color: Colors.black, width: 2.0),
                  ),
                  child: DropdownButton<String>(
                    isExpanded: true,
                    value: dropdownValue,
                    icon: const Icon(
                      Icons.arrow_drop_down,
                      color: Colors.black,
                    ),
                    iconSize: 25,
                    elevation: 16,
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      color: Colors.black,
                    ),
                    underline: Container(
                      height: 2,
                    ),
                    hint: Center(child: Text('I am a')),
                    onChanged: (newValue) {
                      render(() {
                        dropdownValue = newValue!;
                      });
                    },
                    items: <String>['Client', 'Store']
                        .map<DropdownMenuItem<String>>((String value) {
                      return DropdownMenuItem<String>(
                        value: value,
                        child: Text(value),
                      );
                    }).toList(),
                  ),
                ),
                con.passwordErrorMessage == null
                    ? SizedBox(
                        height: 1.0,
                      )
                    : Text(
                        con.passwordErrorMessage!,
                        style: TextStyle(color: Colors.black, fontSize: 14.0),
                      ),
                SizedBox(
                  height: 20.0,
                ),
                ElevatedButton(
                  onPressed: con.createAccount,
                  child: Text(
                    "Send It!",
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 15.0,
                      color: Colors.black,
                    ),
                  ),
                  style: ElevatedButton.styleFrom(
                    primary: Colors.pinkAccent[400],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _Controller {
  _SignUpState state;
  _Controller(this.state);
  String? email;
  String? password;
  String? passwordConfirm;
  String? passwordErrorMessage;

  FirebaseAuth auth = FirebaseAuth.instance;

  void createAccount() async {
    if (state.dropdownValue == null) {
      MyDialog.info(
          context: state.context,
          title: 'Select a Type',
          content: 'Select either client or store.');
      return;
    }
    if (!state.formKey.currentState!.validate()) return;

    state.render(() => passwordErrorMessage = null);
    state.formKey.currentState!.save();

    if (password != passwordConfirm) {
      state.render(() => passwordErrorMessage = "Passwords do not match.");
      return;
    }
    MyDialog.circularProgressStart(state.context);
    try {
      if (state.dropdownValue == 'Client') {
        await FirebaseController.createNewClient(
            email: email!, password: password!);
        MyDialog.circularProgressStop(state.context);
        // Collect client general info
        Navigator.pushReplacementNamed(
            state.context, ClientGeneralInfoScreen.routeName,
            arguments: {'email': email, 'password': password});
      } else {
        await FirebaseController.createNewStore(
            email: email!, password: password!);
        MyDialog.circularProgressStop(state.context);
        // Collect store general info
        Navigator.pushReplacementNamed(
            state.context, StoreGeneralInfoScreen.routeName,
            arguments: {'email': email, 'password': password});
      }
      //Navigator.pop(state.context);
    } catch (e) {
      MyDialog.circularProgressStop(state.context);
      MyDialog.info(
          context: state.context,
          title: "Failed to create account.",
          content: "$e");
    }
  }

  String? validateEmail(String? value) {
    if (value!.contains("@") && value.contains("."))
      return null;
    else
      return "Invalid email.";
  }

  void saveEmail(String? value) {
    email = value!;
  }

  String? validatePassword(String? value) {
    if (value!.length < 6)
      return "Password must be at least 6 characters long.";
    else
      return null;
  }

  void savePassword(String? value) {
    password = value!;
  }

  void savePasswordConfirm(String? value) {
    passwordConfirm = value;
  }
}
