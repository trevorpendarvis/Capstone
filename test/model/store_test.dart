import 'package:flutter_test/flutter_test.dart';
import 'package:monkey_management/model/store.dart';

void main() {
  test('store assign test', () async {
    //arrange
    Store store = new Store();
    store.id = "test";
    store.name = "test";
    store.phone = "test";
    store.email = "test";
    store.address = "test";

    Store test = new Store();

    // act
    test.assign(store);

    // assert
    expect(test.id, "test");
    expect(test.name, "test");
    expect(test.phone, "test");
    expect(test.email, "test");
    expect(test.address, "test");

    expect(test.id, store.id);
    expect(test.name, store.name);
    expect(test.phone, store.phone);
    expect(test.email, store.email);
    expect(test.address, store.address);
  });
}
