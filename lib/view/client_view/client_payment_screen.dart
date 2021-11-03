import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:monkey_management/controller/firebase_controller.dart';
import 'package:monkey_management/model/cardBack.dart';
import 'package:monkey_management/model/cardFront.dart';
import 'package:monkey_management/model/client.dart';
import 'package:monkey_management/view/common_view/loading_screen.dart';
import 'package:monkey_management/view/common_view/mydialog.dart';

import 'package:flip_card/flip_card.dart';

class ClientPaymentScreen extends StatefulWidget {
  static const routeName = "/client_payment_screen";

  const ClientPaymentScreen({Key? key}) : super(key: key);

  @override
  _ClientPaymentScreenState createState() => _ClientPaymentScreenState();
}

class _ClientPaymentScreenState extends State<ClientPaymentScreen> {
  Controller? con;
  var formKey = GlobalKey<FormState>();
  GlobalKey<FlipCardState> cardKey = GlobalKey<FlipCardState>();

  Client? clientProfile;
  Client? tempProfile;
  bool? editMode = false;
  //bool? isCVVFocused = false;

  @override
  void initState() {
    super.initState();
    con = Controller(this);
  }

  void render(fn) => setState(fn);

  @override
  Widget build(BuildContext context) {
    Map? args = ModalRoute.of(context)!.settings.arguments as Map?;
    clientProfile = args!['one_clientProfile'] ?? Client();

    tempProfile = Client.clone(clientProfile!);

    return FutureBuilder(
        future: con!.fetchData(),
        builder: (context, snapshot) {
          //if (snapshot.connectionState == ConnectionState.waiting) return LoadingScreen();
          //if (snapshot.connectionState == ConnectionState.done) {
          return WillPopScope(
            onWillPop: () => Future.value(true),
            child: Scaffold(
              appBar: AppBar(
                title: Center(
                    child: Text(
                  'Payment Information',
                  style: TextStyle(color: Colors.pink[400]),
                )),
                backgroundColor: Colors.blue[400],
                actions: [
                  editMode!
                      ? IconButton(
                          icon: Icon(
                            Icons.check,
                            color: Colors.pink,
                          ),
                          onPressed: con?.saveCard,
                        )
                      : IconButton(
                          icon: Icon(
                            Icons.edit,
                            color: Colors.pink,
                          ),
                          onPressed: con?.editCard,
                        ),
                ],
              ),
              body: SingleChildScrollView(
                //   child: Form(
                //     key: formKey,
                //     child:
                //     Stack(
                //       children: [
                //         Container(
                //         child:

                //           ClipRRect(
                //             child:  Image.asset('assets/images/bg.png', fit: BoxFit.cover),
                //             borderRadius: BorderRadius.circular(16),
                //           ),
                //           height: MediaQuery.of(context).size.height/3,
                //           width: MediaQuery.of(context).size.width-20,
                //           decoration: BoxDecoration(
                //             color: Color(0xffa29bfe),
                //             boxShadow: [
                //               BoxShadow(
                //                   color: Colors.grey.withOpacity(0.8),
                //                   spreadRadius: 5,
                //                   blurRadius: 18,
                //                   offset: Offset(0, 1), // changes position of shadow
                //                 ),
                //             ],
                //             borderRadius: BorderRadius.circular(16)
                //           ),
                //         ),

                //       Positioned(
                //         left: 20,
                //         child:
                //           Image.asset('assets/images/MonkeyLogo.png',
                //             width: 90,
                //             height:90
                //           ),
                //       ),
                //       Positioned(
                //         left: 20,
                //         top:100,
                //         child: Column(
                //           crossAxisAlignment: CrossAxisAlignment.start,
                //           children: <Widget>[
                //             Text(
                //               "1111 2222 3333 4444",//clientProfile!.cardNum,
                //               style: TextStyle(fontSize:24, color: Colors.white)
                //             ),
                //             Text(
                //               "Caitlyn Bell", //clientProfile!.cardName,
                //               style: TextStyle(fontSize: 20, color: Colors.white)
                //             ),
                //           ],
                //     )
                //     ),
                //     ]),

                //   ),
                // ),
                child: Form(
                  key: formKey,
                  child: Padding(
                    padding: const EdgeInsets.all(10.0),
                    child: Column(
                      children: <Widget>[
                        Padding(
                          padding: const EdgeInsets.only(bottom: 20.0),
                          child: FlipCard(
                            key: cardKey, //Will I need form key instead???
                            flipOnTouch: false,
                            front: CreditCardFront(
                              cardName: tempProfile!.cardName ?? 'Card Holder Name',
                              cardNum: tempProfile!.cardNum ?? '1111 2222 3333 4444',
                              cardExp: tempProfile!.cardExp ?? '01/23',
                            ),
                            back: CreditCardBack(cardCVV: tempProfile!.cardCVV ?? '123'),
                          ),
                        ),
                        TextFormField(
                          initialValue: clientProfile!.cardName,
                          enabled: editMode,
                          onChanged: (value) {
                            setState(() {
                              tempProfile!.cardName = value;
                            });
                          },
                          decoration: InputDecoration(labelText: "Enter name"),
                          onSaved: con?.saveCardName,
                        ),
                        TextFormField(
                          initialValue: clientProfile!.cardNum,
                          enabled: editMode,
                          onChanged: (value) {
                            setState(() {
                              tempProfile!.cardNum = value;
                            });
                          },
                          decoration:
                              InputDecoration(labelText: "Enter credit card number"),
                          validator: con?.validateCardNum,
                          onSaved: con?.saveCardNum,
                        ),
                        TextFormField(
                          initialValue: clientProfile!.cardExp,
                          enabled: editMode,
                          onChanged: (value) {
                            setState(() {
                              tempProfile!.cardExp = value;
                            });
                          },
                          decoration: InputDecoration(labelText: "Enter expiration date"),
                          validator: con?.validateCardExp,
                          onSaved: con?.saveCardExp,
                        ),
                        TextFormField(
                          initialValue: clientProfile!.cardCVV,
                          enabled: editMode,
                          onChanged: (value) {
                            setState(() {
                              tempProfile!.cardCVV = value;
                            });
                          },
                          onSaved: (value) {
                            setState(() {
                              cardKey.currentState!.toggleCard();
                            });
                            con?.saveCardCVV(value); //Does this work?
                          },
                          // onSubmitted: (value) {
                          //   setState(() {
                          //     cardKey.currentState!.toggleCard();
                          //   });
                          // },
                          onTap: () {
                            setState(() {
                              cardKey.currentState!.toggleCard();
                            });
                          },
                          decoration: InputDecoration(labelText: "Enter security code"),
                        )
                      ],
                    ),
                  ),
                ),
              ),
            ),
          );
          // } else
          //   return Text("Error");
        });
  }
}

class Controller {
  _ClientPaymentScreenState state;
  Controller(this.state);
  late Client clientProfile;

  String? cardName;
  String? cardNum;
  String? cardExp;
  String? cardCVV;

  Future<void> fetchData() async {
    clientProfile =
        await FirebaseController.getClientProfile(FirebaseAuth.instance.currentUser!.uid);
  }

  void saveCardName(String? value) {
    this.cardName = value;
    state.tempProfile!.cardName = value;
  }

  String? validateCardNum(String? value) {
    if (value == null || value.length < 16 || value.length > 16) {
      return 'Card number must be 16 digits.';
    } else {
      return null;
    }
  }

  void saveCardNum(String? value) {
    this.cardNum = value;
    state.tempProfile!.cardNum = value;
  }

  String? validateCardExp(String? value) {
    if (value == null || value.length < 4 || value.length > 4) {
      return 'Expiration date must follow MM/YY format.';
    } else {
      return null;
    }
  }

  void saveCardExp(String? value) {
    this.cardExp = value;
    state.tempProfile!.cardExp = value;
  }

  String? validateCardCVV(String? value) {
    if (value == null || value.length < 3 || value.length > 3) {
      return 'CVV must be 3 digits.';
    } else {
      return null;
    }
  }

  void saveCardCVV(String? value) {
    this.cardCVV = value;
    state.tempProfile!.cardCVV = value;
  }

  void saveCard() async {
    if (!state.formKey.currentState!.validate()) return;
    state.formKey.currentState!.save();
    //state.cardKey.currentState!.save();

    try {
      MyDialog.circularProgressStart(state.context);
      Map<String, dynamic> updateInfo = {};

      if (state.clientProfile!.cardName != state.tempProfile!.cardName)
        updateInfo[Client.CARD_NAME] = state.tempProfile!.cardName;

      if (state.clientProfile!.cardNum != state.tempProfile!.cardNum)
        updateInfo[Client.CARD_NUM] = state.tempProfile!.cardNum;

      if (state.clientProfile!.cardExp != state.tempProfile!.cardExp)
        updateInfo[Client.CARD_EXP] = state.tempProfile!.cardExp;

      if (state.clientProfile!.cardCVV != state.tempProfile!.cardCVV)
        updateInfo[Client.CARD_CVV] = state.tempProfile!.cardCVV;

      await FirebaseController.updateClientProfile(
          FirebaseAuth.instance.currentUser!.uid, updateInfo);
      state.clientProfile!.assign(state.tempProfile!);

      MyDialog.circularProgressStop(state.context);
      Navigator.pop(state.context);
      //state.render(() => {});
    } catch (e) {
      MyDialog.circularProgressStop(state.context);
      MyDialog.info(
          context: state.context, title: "Error Updating Payment Info", content: "$e");
    }
  }

  void editCard() {
    state.render(() => state.editMode = true);
  }
}
