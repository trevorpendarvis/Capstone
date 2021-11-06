import 'package:firebase_auth/firebase_auth.dart';
import 'package:flip_card/flip_card_controller.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:monkey_management/controller/credit_card_provider.dart';
import 'package:monkey_management/controller/firebase_controller.dart';
import 'package:monkey_management/model/cardBack.dart';
import 'package:monkey_management/model/cardFront.dart';
import 'package:monkey_management/model/client.dart';
import 'package:monkey_management/view/common_view/loading_screen.dart';
import 'package:monkey_management/view/common_view/mydialog.dart';

import 'package:flip_card/flip_card.dart';
import 'package:provider/provider.dart';

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
  FlipCardController flipCardController = FlipCardController();


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
  void didChangeDependencies() {
    print('didChangeDependencies');
    super.didChangeDependencies();
  }

  @override
  void didUpdateWidget(covariant ClientPaymentScreen oldWidget) {
    super.didUpdateWidget(oldWidget);
    print('didUpdateWidget');
    // print(tempProfile!.firstName);
  }

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
                child: Column(
                  children: [
                    Consumer<CreditCardProvider>(
                      builder: (context, card, _) =>
                          Container(
                            // padding: const EdgeInsets.all( 20.0),
                            // margin: const EdgeInsets.all( 20.0),
                            child: FlipCard(
                              key: cardKey, //Will I need form key instead???
                              flipOnTouch: false,
                              controller: flipCardController,
                              front: CreditCardFront(
                                cardName: card.name == '' ? 'Card Holder Name' : card.name,
                                cardNum: card.number == '' ? '---- ---- ---- ----' : card.number,
                                cardExp: card.expDate == '' ? 'MM/YY' : card.expDate,
                              ),
                              back: CreditCardBack(cardCVV: card.cvv == '' ? '---' : card.cvv),
                            ),
                          ),
                    ),
                    Form(
                      key: formKey,
                      child: Padding(
                        padding: const EdgeInsets.all(10.0),
                        child: Column(
                          children: <Widget>[
              
              
                            TextFormField(
                              initialValue: clientProfile!.cardName,
                              enabled: editMode,
                              onChanged: (value) {
                                  tempProfile!.cardName = value;
                                  Provider.of<CreditCardProvider>(context, listen: false).setName(value);
                              },
                              onTap: () {
                                setState(() {
                                  if (!cardKey.currentState!.isFront) cardKey.currentState!.toggleCard();
                                });
                              },
                              decoration: InputDecoration(labelText: "Enter name"),
                              onSaved: con?.saveCardName,
                            ),
              
                            TextFormField(
                              inputFormatters: [
                                FilteringTextInputFormatter.digitsOnly,
                                new CardNumSpacing(),
                              ],
                              initialValue: clientProfile!.cardNum,
                              enabled: editMode,
                              onChanged: (value) {
                                  tempProfile!.cardNum = value;
                                  Provider.of<CreditCardProvider>(context, listen: false).setNumber(value);
                              },
                              onTap: () {
                                setState(() {
                                  if (!cardKey.currentState!.isFront) cardKey.currentState!.toggleCard();
                                });
                              },
                              decoration:
                                  InputDecoration(labelText: "Enter credit card number"),
                              validator: con?.validateCardNum,
                              onSaved: con?.saveCardNum,
                            ),
                            TextFormField(
                              inputFormatters: [
                                FilteringTextInputFormatter.digitsOnly,
                                new CardExpFormat(),
                              ],
                              initialValue: clientProfile!.cardExp,
                              enabled: editMode,
                              onChanged: (value) {
                                  tempProfile!.cardExp = value;
                                  Provider.of<CreditCardProvider>(context, listen: false).setExpDate(value);
                              },
                              onTap: () {
                                setState(() {
                                  if (!cardKey.currentState!.isFront) cardKey.currentState!.toggleCard();
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
                                  tempProfile!.cardCVV = value;
                                  Provider.of<CreditCardProvider>(context, listen: false).setCVV(value);
                              },
              
                              onSaved: (value) {
                                setState(() {
                                  cardKey.currentState!.toggleCard();
                                });
                                con?.saveCardCVV(value); //Does this work?
                              },
                              onTap: () {
                                setState(() {
                                  if (cardKey.currentState!.isFront) cardKey.currentState!.toggleCard();
                                });
                              },
                              decoration: InputDecoration(labelText: "Enter security code"),
                            )
                          ],
                        ),
                      ),
                    ),
                  ],
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

    Provider.of<CreditCardProvider>(state.context, listen: false).number = clientProfile.cardNum!;
    Provider.of<CreditCardProvider>(state.context, listen: false).name = clientProfile.cardName!;
    Provider.of<CreditCardProvider>(state.context, listen: false).expDate = clientProfile.cardExp!;
    Provider.of<CreditCardProvider>(state.context, listen: false).cvv = clientProfile.cardCVV!;
  }

  void saveCardName(String? value) {
    this.cardName = value;
    state.tempProfile!.cardName = value;
  }

  String? validateCardNum(String? value) {
    if (value == null || value.length < 19 || value.length > 19) {
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
    if (value == null || value.length < 5 || value.length > 5) {
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

//Formatter for adding space after every four digits of credit card number
class CardNumSpacing extends TextInputFormatter {
  @override
  TextEditingValue formatEditUpdate(
      TextEditingValue oldValue, TextEditingValue newValue) {
    var text = newValue.text;

    if (newValue.selection.baseOffset == 0) {
      return newValue;
    }

    var buffer = new StringBuffer();
    for (int i = 0; i < text.length; i++) {
      buffer.write(text[i]);
      var nonZeroIndex = i + 1;
      if (nonZeroIndex % 4 == 0 && nonZeroIndex != text.length) {
        buffer.write(
            ' '); // Replace this with anything you want to put after each 4 numbers
      }
    }

    var string = buffer.toString();
    return newValue.copyWith(
        text: string, selection: new TextSelection.collapsed(offset: string.length));
  }
}

//Formatter for adding slash between expiration date
class CardExpFormat extends TextInputFormatter {
  @override
  TextEditingValue formatEditUpdate(
      TextEditingValue oldValue, TextEditingValue newValue) {
    var text = newValue.text;

    if (newValue.selection.baseOffset == 0) {
      return newValue;
    }

    var buffer = new StringBuffer();
    for (int i = 0; i < text.length; i++) {
      buffer.write(text[i]);
      var nonZeroIndex = i + 1;
      if (nonZeroIndex % 2 == 0 && nonZeroIndex != text.length) {
        buffer.write('/');
      }
    }

    var string = buffer.toString();
    return newValue.copyWith(
        text: string, selection: new TextSelection.collapsed(offset: string.length));
  }
}