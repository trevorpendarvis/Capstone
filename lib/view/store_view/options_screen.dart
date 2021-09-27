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
        title: Text(
          'Store Options',
          style: TextStyle(color: Colors.black),
        ),
        foregroundColor: Colors.black,
        backgroundColor: Colors.amber,
      ),
      body: Container(
        child: Row(
          children: [
            Text('Place holder for a list of options'),
            ElevatedButton(
              onPressed: () => con!.handleAddOptionButton(),
              child: Text('Add New Option'),
            ),
          ],
        ),
      ),
    );
  }
}

class Controller {
  _StoreOptionsScreenState state;

  Controller(this.state);

  void handleAddOptionButton() {
    Navigator.pushNamed(state.context, AddUpdateOptionScreen.routeName,
        // arguments: {'isEdit': false}
    );
  }
}
