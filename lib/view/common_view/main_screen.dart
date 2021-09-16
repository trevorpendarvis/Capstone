import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:monkey_management/controller/firebase_controller.dart';
import 'package:monkey_management/model/data.dart';
import 'package:monkey_management/view/client_view/client_screen.dart';
import 'package:monkey_management/view/common_view/splash_screen.dart';
import 'package:monkey_management/view/store_view/store_screen.dart';

class MainScreen extends StatefulWidget {
  static const routeName = '/main-screen';

  @override
  _MainScreenState createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  bool _isInit = false;
  late AccountType _accountType;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
  }

  @override
  void didChangeDependencies() async {
    // if (!widget._isInit) {
    if (!_isInit) {
      _accountType = await FirebaseController.getAccountType();

      setState(() {
        _isInit = true;
        // widget._isInit = true;
      });
    }
    super.didChangeDependencies();
  }

  Widget screen() {
    if (!_isInit) return SplashScreen();
    if (_accountType == AccountType.CLIENT) return ClientScreen();
    if (_accountType == AccountType.STORE) return StoreScreen();

    return Scaffold(body: Center(child: Text('Something is wrong!')),);
  }

  @override
  Widget build(BuildContext context) {
    return screen();
  }
}
