import 'package:flutter/material.dart';

class StoreScreen extends StatefulWidget {
  static const routeName = "/store_screen";
  const StoreScreen({Key? key}) : super(key: key);

  @override
  _StoreScreenState createState() => _StoreScreenState();
}

class _StoreScreenState extends State<StoreScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: Center(child: Text('This is the store screen'),),
    );
  }
}