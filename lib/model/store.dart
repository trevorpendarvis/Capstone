import 'dart:ffi';

import 'package:monkey_management/model/option.dart';

import 'appointment.dart';

class Store {
  String id = '';
  String name = '';
  String phone = '';
  String email = '';
  String address = '';

  List<Option> options = [];
  List<Appointment> appointments = [];

  static const COLLECTION = "stores";
  static const NAME = "name";
  static const EMAIL = "email";
  static const PHONE = "phone";
  static const ADDRESS = "address";

  Store();

  Store.clone(Store p) {
    this.id = p.id;
    this.name = p.name;
    this.email = p.email;
    this.phone = p.phone;
    this.address = p.address;
    this.options = p.options;
    this.appointments = p.appointments;
  }

  Map<String, dynamic> serialize() {
    return <String, dynamic>{
      NAME: this.name,
      EMAIL: this.email,
      PHONE: this.phone,
      ADDRESS: this.address,
    };
  }

  static Store deserialize(Map<String, dynamic>? doc, String docId) {
    Store store = Store();
    store.id =  docId;
    store.name = doc?[NAME];
    store.email = doc?[EMAIL];
    store.phone = doc?[PHONE];
    store.address = doc?[ADDRESS];
    return store;
  }
}