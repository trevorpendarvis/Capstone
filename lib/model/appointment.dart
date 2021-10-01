import 'package:cloud_firestore/cloud_firestore.dart';

import 'option.dart';

class Appointment {
  String clientId = '';
  String storeId = '';
  DateTime appointmentTime = DateTime.now();
  Option option = Option();
  DateTime createdAt = DateTime.now();
  String createdBy = '';
  bool isCanceled =  false;
  bool isCompleted =  false;

  static const COLLECTION = 'appointments';
  static const CLIENT_ID = 'client_id';
  static const STORE_ID = 'store_id';
  static const APPOINTMENT_TIME = 'appointment_time';
  static const OPTION_ID = 'option_id';
  static const CREATED_AT = 'created_at';
  static const CREATED_BY = 'created_by';
  static const IS_CANCELED = 'is_canceled';
  static const IS_COMPLETED = 'is_completed';

  Appointment();

  Map<String, dynamic> serialize() {
    return <String, dynamic>{
    CLIENT_ID: this.clientId,
    STORE_ID: this.storeId,
    APPOINTMENT_TIME: this.appointmentTime,
    OPTION_ID: this.option.id,
    CREATED_AT: this.createdAt,
    CREATED_BY: this.createdBy,
    IS_CANCELED: this.isCanceled,
    IS_COMPLETED: this.isCompleted,
    };
  }

  static Appointment deserialize(Map<String, dynamic>? doc, String docId) {
    Appointment appointment = Appointment();

    appointment.clientId = doc![CLIENT_ID] ?? '';
    appointment.storeId = doc[STORE_ID] ?? '';
    appointment.appointmentTime = doc[APPOINTMENT_TIME].toDate() ?? DateTime.now();
    // appointment.option = doc![CLIENT_ID] ?? ''; // need a list of options to deserialize
    appointment.createdAt = doc[CREATED_AT].toDate() ?? DateTime.now();
    appointment.createdBy = doc[CREATED_BY] ?? '';
    appointment.isCanceled = doc[IS_CANCELED] ?? false;
    appointment.isCompleted = doc[IS_COMPLETED] ?? false;

    return appointment;
  }

  static List<Appointment> deserializeToList(QuerySnapshot<Map<String, dynamic>> docs) {
    List<Appointment> appointments = [];

    docs.docs.forEach((element) {
      appointments.add(deserialize(element.data(), element.id));
    });
    return appointments;
  }
}