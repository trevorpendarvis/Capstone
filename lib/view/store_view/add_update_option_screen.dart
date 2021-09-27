import 'package:flutter/material.dart';
import 'package:monkey_management/controller/firebase_controller.dart';
import 'package:monkey_management/model/option.dart';
import 'package:monkey_management/view/common_view/mydialog.dart';

class AddUpdateOptionScreen extends StatefulWidget {
  static const routeName = "/add_update_option_screen";

  @override
  _AddUpdateOptionScreenState createState() => _AddUpdateOptionScreenState();
}

class _AddUpdateOptionScreenState extends State<AddUpdateOptionScreen> {
  Controller? con;

  var formKey = GlobalKey<FormState>();

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
          'Add Option',
          style: TextStyle(color: Colors.black),
        ),
        foregroundColor: Colors.black,
        backgroundColor: Colors.amber,
      ),
      body: Container(
          padding: EdgeInsets.all(8.0),
          child: SingleChildScrollView(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Form(
                  key: formKey,
                  child: Column(
                    children: [
                      Container(
                        margin: EdgeInsets.fromLTRB(0, 10.0, 0, 10.0),
                        child: TextFormField(
                          decoration: InputDecoration(
                            hintText: "Option Name",
                            border: OutlineInputBorder(),
                          ),
                          validator: con?.validateName,
                          onSaved: con?.saveName,
                        ),
                      ),
                      Container(
                        margin: EdgeInsets.fromLTRB(0, 10.0, 0, 10.0),
                        child: TextFormField(
                          decoration: InputDecoration(
                            hintText: "Description",
                            border: OutlineInputBorder(),
                          ),
                          validator: con?.validateDescription,
                          onSaved: con?.saveDescription,
                        ),
                      ),
                      Container(
                        margin: EdgeInsets.fromLTRB(0, 10.0, 0, 10.0),
                        child: TextFormField(
                          decoration: InputDecoration(
                            hintText: "Price",
                            border: OutlineInputBorder(),
                          ),
                          validator: con?.validatePrice,
                          onSaved: con?.savePrice,
                        ),
                      ),
                    ],
                  ),
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    ElevatedButton(
                      onPressed: () {},
                      child: Text("Delete", style: Theme.of(context).textTheme.button),
                    ),
                    ElevatedButton(
                      onPressed: con?.onSave,
                      child: Text("Done", style: Theme.of(context).textTheme.button),
                    ),
                  ],
                )
              ],
            ),
          )),
    );
  }
}

class Controller {
  _AddUpdateOptionScreenState state;

  Controller(this.state);

  Option _option = Option();

  String? validateName(String? value) {
    if (value == null || value.length < 1) {
      return 'invalid name min char 1';
    } else {
      return null;
    }
  }

  void saveName(String? value) {
    _option.name = value!;
  }

  String? validateDescription(String? value) {
    if (value!.length == 0) {
      return 'Please enter your description';
    } else {
      return null;
    }
  }

  void saveDescription(String? value) {
    _option.description = value!;
  }

  String? validatePrice(String? value) {
    if (value!.length == 0) return 'Please enter the price';
    if (double.parse(value) <= 0.0) {
      return 'Please enter the price';
    } else {
      return null;
    }
  }

  void savePrice(String? value) {
    _option.price = double.parse(value!);
  }

  Future<void> onSave() async {
    if (!state.formKey.currentState!.validate()) {
      return;
    }

    MyDialog.circularProgressStart(state.context);
    state.formKey.currentState!.save();

    try {
      await FirebaseController.addOption(_option);

      MyDialog.circularProgressStop(state.context);
      Navigator.pop(state.context);
    } catch (e) {
      MyDialog.circularProgressStop(state.context);
      MyDialog.info(context: state.context, title: 'Error', content: '$e');
    }
  }
}
