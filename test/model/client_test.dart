import 'dart:math';

import 'package:flutter_test/flutter_test.dart';
import 'package:monkey_management/model/client.dart';

void main() {
  test('Client assign test', () async {
    // arrange
    Client client = new Client();
    client.email = "test";
    client.firstName = "test";
    client.lastName = "test";
    client.phone = "test";
    client.address = "test";
    client.vehicleColor = "test";
    client.vehicleMake = "test";
    client.favLocation = "test";
    client.cardNum = "test";
    client.cardName = "test";
    client.cardExp = "test";
    client.cardCVV = "test";

    Client test = new Client();

    // act
    test.assign(client);

    // assert
    expect(test.email, "test");
    expect(test.firstName, "test");
    expect(test.lastName, "test");
    expect(test.phone, "test");
    expect(test.address, "test");
    expect(test.vehicleColor, "test");
    expect(test.vehicleMake, "test");
    expect(test.favLocation, "test");
    expect(test.cardNum, "test");
    expect(test.cardName, "test");
    expect(test.cardExp, "test");

    expect(test.email, client.email);
    expect(test.firstName, client.email);
    expect(test.lastName, client.email);
    expect(test.phone, client.email);
    expect(test.address, client.email);
    expect(test.vehicleColor, client.email);
    expect(test.vehicleMake, client.email);
    expect(test.favLocation, "test");
    expect(test.cardNum, "test");
    expect(test.cardName, "test");
    expect(test.cardExp, "test");
  });
}
