import 'package:flutter/material.dart';


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
