import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:monkey_management/controller/firebase_controller.dart';
import 'package:monkey_management/model/profile.dart';
import 'package:monkey_management/view/common_view/mydialog.dart';

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

  @override
  void initState() {
    super.initState();
    con = _Controller(this);
  }

  void render(fn) => setState(fn);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Create a New Account"),
      ),
      body: Padding(
        padding: const EdgeInsets.only(top: 10.0, right: 15.0, left: 15.0),
        child: Form(
          key: formKey,
          child: SingleChildScrollView(
            child: Column(
              children: [
                Text("Create an account", style: Theme.of(context).textTheme.headline5),
                TextFormField(
                  decoration: InputDecoration(
                    hintText: "Email",
                  ),
                  keyboardType: TextInputType.emailAddress,
                  autocorrect: false,
                  validator: con.validateEmail,
                  onSaved: con.saveEmail,
                ),
                TextFormField(
                  decoration: InputDecoration(
                    hintText: "Password",
                  ),
                  obscureText: true,
                  autocorrect: false,
                  validator: con.validatePassword,
                  onSaved: con.savePassword,
                ),
                TextFormField(
                  decoration: InputDecoration(
                    hintText: "Confirm Password",
                  ),
                  obscureText: true,
                  autocorrect: false,
                  validator: con.validatePassword,
                  onSaved: con.savePasswordConfirm,
                ),
                con.passwordErrorMessage == null
                    ? SizedBox(
                        height: 1.0,
                      )
                    : Text(
                        con.passwordErrorMessage!,
                        style: TextStyle(color: Colors.red, fontSize: 14.0),
                      ),
                ElevatedButton(
                  onPressed: con.createAccount,
                  child: Text(
                    "Create",
                    style: Theme.of(context).textTheme.button,
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
  Profile newProfile = Profile();

  FirebaseAuth auth = FirebaseAuth.instance;

  void createAccount() async {
    if (!state.formKey.currentState!.validate()) return;

    state.render(() => passwordErrorMessage = null);
    state.formKey.currentState!.save();

    if (password != passwordConfirm) {
      state.render(() => passwordErrorMessage = "Passwords do not match.");
      return;
    }

    try {
      await FirebaseController.createNewAccount(email: email!, password: password!);
      MyDialog.info(
        context: state.context,
        title: "Account created!",
        content: "Go to Sign In screen to use the app."
      );
      //Navigator.pop(state.context);
    } catch (e) {
      MyDialog.info(
          context: state.context, title: "Failed to create account.", content: "$e");
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
