import 'package:flutter/material.dart';


class CreditCardProvider extends ChangeNotifier {
    String name = '';
    String number = '';
    String expDate = '';
    String cvv = '';

    void setName(String value) {
      name = value;
      print('inside provider: $name');
      notifyListeners();
    }

    void setNumber(String value) {
      number = value;
      notifyListeners();
    }

    void setExpDate(String value) {
      expDate = value;
      notifyListeners();
    }

    void setCVV(String value) {
      cvv = value;
      notifyListeners();
    }
}