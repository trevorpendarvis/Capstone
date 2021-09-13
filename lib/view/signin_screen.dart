import 'package:flutter/material.dart';

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

  void signIn() {
    if (!state.formkey.currentState!.validate()) {
      return;
    }
    state.formkey.currentState!.save();
    print('Email: $email');
    print('Password: $password');
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
