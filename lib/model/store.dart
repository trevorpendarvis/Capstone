import 'dart:ffi';

import 'package:monkey_management/model/option.dart';

import 'appointment.dart';

class Store {
  String id = '';
  String name = '';
  String phone = '';
  String email = '';
  String address = '';
  double lat = 0;
  double lng = 0;

  List<Option> options = [];
  List<Appointment> appointments = [];

  static const COLLECTION = "stores";
  static const NAME = "name";
  static const EMAIL = "email";
  static const PHONE = "phone";
  static const ADDRESS = "address";
  static const LAT = "lat";
  static const LNG = "lng";

  Store();

  Store.clone(Store p) {
    this.id = p.id;
    this.name = p.name;
    this.email = p.email;
    this.phone = p.phone;
    this.address = p.address;
    this.options = p.options;
    this.appointments = p.appointments;
    this.lat = p.lat;
    this.lng = p.lng;
  }

  void assign(Store p) {
    this.id = p.id;
    //this.userName = p.userName;
    this.address = p.address;
    this.email = p.email;
    this.name = p.name;
    this.phone = p.phone;
    this.lat = p.lat;
    this.lng = p.lng;
  }

  Map<String, dynamic> serialize() {
    return <String, dynamic>{
      NAME: this.name,
      EMAIL: this.email,
      PHONE: this.phone,
      ADDRESS: this.address,
      LAT: this.lat,
      LNG: this.lng,
    };
  }

  static Store deserialize(Map<String, dynamic>? doc, String docId) {
    Store store = Store();
    store.id = docId;
    store.name = doc?[NAME] ?? 'Unknown';
    store.email = doc?[EMAIL] ?? 'Unknown';
    store.phone = doc?[PHONE] ?? 'Unknown';
    store.address = doc?[ADDRESS] ?? 'Unknown';
    store.lat = doc?[LAT] ?? 0;
    store.lng = doc?[LNG] ?? 0;
    return store;
  }
}
