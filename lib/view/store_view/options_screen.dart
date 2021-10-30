import 'package:flutter/material.dart';
import 'package:monkey_management/view/store_view/add_update_option_screen.dart';

class StoreOptionsScreen extends StatefulWidget {
  static const routeName = "/options_screen";

  @override
  _StoreOptionsScreenState createState() => _StoreOptionsScreenState();
}

class _StoreOptionsScreenState extends State<StoreOptionsScreen> {
  Controller? con;

  @override
  void initState() {
    super.initState();
    con = Controller(this);
  }

  void render(fn) => setState(fn);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Padding(
          padding: const EdgeInsets.only(left: 65, right: 20),
          child: Text(
            'Store Options',
            style: TextStyle(color: Colors.black),
          ),
        ),
        foregroundColor: Colors.black,
        backgroundColor: Colors.pinkAccent[400],
      ),
      floatingActionButton: FloatingActionButton(
        child: Icon(
          Icons.add,
        ),
        backgroundColor: Colors.blue,
        onPressed: () => con!.handleAddOptionButton(),
      ),
      body: Center(
        child: Text('Place holder for a list of options'),
      ),
    );
  }
}

class Controller {
  _StoreOptionsScreenState state;

  Controller(this.state);

  void handleAddOptionButton() {
    Navigator.pushNamed(
      state.context, AddUpdateOptionScreen.routeName,
      // arguments: {'isEdit': false}
    );
  }
}
