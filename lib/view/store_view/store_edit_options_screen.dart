import 'package:flutter/material.dart';
import 'package:monkey_management/controller/firebase_controller.dart';
import 'package:monkey_management/model/option.dart';
import 'package:monkey_management/view/common_view/mydialog.dart';
import 'options_screen.dart';

class StoreEditOptionScreen extends StatefulWidget {
  static const routeName = "/store_edit_option_screen";

  @override
  _StoreEditOptionScreenState createState() => _StoreEditOptionScreenState();
}

class _StoreEditOptionScreenState extends State<StoreEditOptionScreen> {
  Controller? con;

  var formKey = GlobalKey<FormState>();
  String? optionName;
  double? optionPrice;
  String? optionDescription;
  String? optionDocId;

  bool? isNewLocation;

  @override
  void initState() {
    super.initState();
    con = Controller(this);
  }

  void render(fn) => setState(fn);

  @override
  Widget build(BuildContext context) {
    Map? args = ModalRoute.of(context)!.settings.arguments as Map?;
    optionName = args!['optionName'];
    optionDescription = args['optionDescription'];
    optionPrice = args['optionPrice'];
    optionDocId = args['optionDocId'];
    isNewLocation = args['isNewLocation'] ?? true;

    //saving docID so it can be used in controller
    con!.currentOptions(
        optionDocId, optionDescription, optionName, optionPrice, isNewLocation);

    //print("optionName: " + optionName!);
    return Scaffold(
      appBar: AppBar(
        title: Padding(
          padding: const EdgeInsets.only(left: 70, right: 20),
          child: Text(
            'Add/Edit Product',
            style: TextStyle(color: Colors.black),
          ),
        ),
        foregroundColor: Colors.black,
        backgroundColor: Colors.pinkAccent[400],
      ),
      body: Container(
          padding: EdgeInsets.all(8.0),
          child: SingleChildScrollView(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                SingleChildScrollView(
                  child: isNewLocation!
                      ?
                      // If this is a new Product
                      Form(
                          key: formKey,
                          child: Column(
                            children: [
                              Container(
                                margin: EdgeInsets.fromLTRB(0, 10.0, 0, 10.0),
                                child: TextFormField(
                                  decoration: InputDecoration(
                                    hintText: "ProductName",
                                    border: OutlineInputBorder(),
                                  ),
                                  validator: con?.validateOptionName,
                                  onSaved: con?.saveOptionName,
                                  onChanged: (String? newValue) {
                                    con!._option.name = newValue!;
                                  },
                                ),
                              ),
                              Container(
                                margin: EdgeInsets.fromLTRB(0, 10.0, 0, 10.0),
                                child: TextFormField(
                                  decoration: InputDecoration(
                                    hintText: "Product Description",
                                    border: OutlineInputBorder(),
                                  ),
                                  validator: con?.validateOptionDesc,
                                  onSaved: con?.saveOptionDesc,
                                  onChanged: (String? newValue) {
                                    con!._option.description = newValue!;
                                  },
                                ),
                              ),
                              Container(
                                margin: EdgeInsets.fromLTRB(0, 10.0, 0, 10.0),
                                child: TextFormField(
                                  decoration: InputDecoration(
                                    hintText: "Product Price",
                                    border: OutlineInputBorder(),
                                  ),
                                  validator: con?.validateOptionPrice,
                                  onSaved: con?.saveOptionPrice,
                                  onChanged: (String? newValue) {
                                    var updatedValue = double.tryParse(newValue!);
                                    con!._option.price = updatedValue!;
                                  },
                                ),
                              ),
                            ],
                          ),
                        )
                      :
                      // If it's an existing product
                      Form(
                          key: formKey,
                          child: Column(
                            children: [
                              //productName
                              Container(
                                margin: EdgeInsets.fromLTRB(4, 10, 0, 0),
                                alignment: Alignment.centerLeft,
                                child: Text(
                                  "Product:",
                                  textAlign: TextAlign.start,
                                  style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    fontSize: 18,
                                  ),
                                ),
                              ),
                              Container(
                                margin: EdgeInsets.fromLTRB(0, 10.0, 0, 10.0),
                                child: TextFormField(
                                  initialValue: optionName,
                                  decoration: InputDecoration(
                                    border: OutlineInputBorder(),
                                  ),
                                  validator: con?.validateOptionName,
                                  onSaved: con?.saveOptionName,
                                  onChanged: (String? newValue) {
                                    con!._option.name = newValue!;
                                  },
                                ),
                              ),
                              //product description
                              Container(
                                margin: EdgeInsets.fromLTRB(4, 10, 0, 0),
                                alignment: Alignment.centerLeft,
                                child: Text(
                                  "Product Description:",
                                  textAlign: TextAlign.start,
                                  style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    fontSize: 18,
                                  ),
                                ),
                              ),
                              Container(
                                margin: EdgeInsets.fromLTRB(0, 10.0, 0, 10.0),
                                child: TextFormField(
                                  initialValue: optionDescription,
                                  decoration: InputDecoration(
                                    border: OutlineInputBorder(),
                                  ),
                                  validator: con?.validateOptionDesc,
                                  onSaved: con?.saveOptionDesc,
                                  onChanged: (String? newValue) {
                                    con!._option.description = newValue!;
                                  },
                                ),
                              ),
                              //product price
                              Container(
                                margin: EdgeInsets.fromLTRB(4, 10, 0, 0),
                                alignment: Alignment.centerLeft,
                                child: Text(
                                  "Product Price:",
                                  textAlign: TextAlign.start,
                                  style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    fontSize: 18,
                                  ),
                                ),
                              ),
                              Container(
                                margin: EdgeInsets.fromLTRB(0, 10.0, 0, 10.0),
                                child: TextFormField(
                                  //initialValue: optionPrice.toString(),
                                  initialValue: optionPrice!.toStringAsFixed(2),
                                  decoration: InputDecoration(
                                    border: OutlineInputBorder(),
                                  ),
                                  validator: con?.validateOptionPrice,
                                  onSaved: con?.saveOptionPrice,
                                  onChanged: (String? newValue) {
                                    var updatedValue = double.tryParse(newValue!);
                                    con!._option.price = updatedValue!;
                                  },
                                ),
                              ),
                            ],
                          ),
                        ),
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    ElevatedButton(
                      onPressed: con?.delete,
                      child: Text("Delete", style: Theme.of(context).textTheme.button),
                    ),
                    isNewLocation!
                        ?
                        // Add new Option
                        ElevatedButton(
                            onPressed: con?.onSave,
                            child:
                                Text("Done", style: Theme.of(context).textTheme.button),
                          )
                        :
                        // Update existing option
                        ElevatedButton(
                            onPressed: con?.onUpdate,
                            child:
                                Text("Update", style: Theme.of(context).textTheme.button),
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
  _StoreEditOptionScreenState state;

  Controller(this.state);

  Option _option = Option();
  String? optionDocId;
  String? optionName;
  String? optionDesc;
  double? optionPrice;
  bool? isNewLocationController;
  String? validateOptionName(String? value) {
    if (value == null || value.length < 1) {
      return 'invalid name min char 1';
    } else {
      return null;
    }
  }

  void saveOptionName(String? value) {
    _option.name = value!;
  }

  void currentOptions(
      String? docId, String? desc, String? name, double? price, bool? isNewLocation) {
    optionDocId = docId!;
    _option.name = name!;
    _option.description = desc!;
    _option.price = price! as double;
    isNewLocationController = isNewLocation;
    //print("OptionDocID = " + optionDocId!);
  }

  String? validateOptionDesc(String? value) {
    int limit = 5;
    if (value == null || value.length < limit) {
      return 'invalid description min char ' + limit.toString();
    } else {
      return null;
    }
  }

  void saveOptionDesc(String? value) {
    _option.description = value!;
  }

  String? validateOptionPrice(String? value) {
    if (value!.length == 0) {
      return 'Please enter store price';
    } else {
      return null;
    }
  }

  void saveOptionPrice(String? value) {
    _option.price = value! as double;
  }

  Future<void> onSave() async {
    print("Done was pressed");

    //validation works
    if (!state.formKey.currentState!.validate()) {
      return;
    }

    MyDialog.circularProgressStart(state.context);
    //state.formKey.currentState!.save();

    try {
      await FirebaseController.addOption(_option);

      MyDialog.circularProgressStop(state.context);
      Navigator.pop(state.context);
    } catch (e) {
      MyDialog.circularProgressStop(state.context);
      MyDialog.info(context: state.context, title: 'Error', content: '$e');
    }
  }

  Future<void> onUpdate() async {
    //validation
    if (!state.formKey.currentState!.validate()) {
      return;
    }

    Option p = new Option();
    p.name = _option.name;
    p.price = _option.price;
    p.description = _option.description;

    try {
      MyDialog.circularProgressStart(state.context);
      Map<String, dynamic> updateInfo = {};
      updateInfo[Option.NAME] = p.name;
      updateInfo[Option.DESCRIPTION] = p.description;
      updateInfo[Option.PRICE] = p.price;
      print("price = " + p.price.toString());
      await FirebaseController.updateOption(optionDocId, updateInfo);

      MyDialog.circularProgressStop(state.context);
      Navigator.pop(state.context);
    } catch (e) {}
  }

  Future<void> delete() async {
    //bool? confirmDelete = false;
    //if this is a new location, then pop back to previous screen
    if (isNewLocationController != null) {
      if (isNewLocationController == true) {
        Navigator.pop(state.context);
      }
    }
    try {
      await FirebaseController.deleteOption(_option.name);
      MyDialog.circularProgressStop(state.context);
      Navigator.pop(state.context);
      Navigator.pushNamed(state.context, StoreOptionsScreen.routeName);
    } catch (e) {
      MyDialog.circularProgressStop(state.context);
      MyDialog.info(context: state.context, title: 'Error', content: '$e');
    }
  }
}
