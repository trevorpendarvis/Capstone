import 'dart:ffi';

import 'package:monkey_management/model/option.dart';

import 'appointment.dart';

class Store {
  String name = '';
  String shortName = '';
  String phone = '';
  String email = '';
  String address = '';



  List<Option> options = [];
  List<Appointment> appointments = [];

  static const COLLECTION = "stores";
}