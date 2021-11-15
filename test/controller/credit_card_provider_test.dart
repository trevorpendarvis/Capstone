import 'package:flutter_test/flutter_test.dart';
import 'package:monkey_management/controller/credit_card_provider.dart';

void main() {
  test('credit card provider set test', () async {
    // assign
    CreditCardProvider creditCard = new CreditCardProvider();
    String name = "testName";
    String number = "testNumber";
    String expDate = "testDate";
    String cvv = "testCvv";

    // act
    creditCard.setName(name);
    creditCard.setNumber(number);
    creditCard.setExpDate(expDate);
    creditCard.setCVV(cvv);

    // assert
    expect(creditCard.name, "testName");
    expect(creditCard.number, "testNumber");
    expect(creditCard.expDate, "testDate");
    expect(creditCard.cvv, "testCvv");
  });
}
