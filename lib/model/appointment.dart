import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:monkey_management/controller/firebase_controller.dart';
import 'package:monkey_management/model/client.dart';
import 'package:monkey_management/model/store.dart';

import 'option.dart';

class Appointment {
  Client client = Client();
  Store store = Store();
  DateTime appointmentTime = DateTime.now();
  Option option = Option();
  DateTime createdAt = DateTime.now();
  String createdBy = '';
  bool isCanceled = false;
  bool isCompleted = false;
  bool inRoute = false;
  String docId = '';

  static const COLLECTION = 'appointments';
  static const CLIENT_ID = 'client_id';
  static const STORE_ID = 'store_id';
  static const APPOINTMENT_TIME = 'appointment_time';
  static const OPTION_ID = 'option_id';
  static const CREATED_AT = 'created_at';
  static const CREATED_BY = 'created_by';
  static const IS_CANCELED = 'is_canceled';
  static const IS_COMPLETED = 'is_completed';
  static const IN_ROUTE = 'in_route';
  static const DOC_ID = 'doc_id';

  Appointment();

  Map<String, dynamic> serialize() {
    return <String, dynamic>{
      CLIENT_ID: this.client.docId,
      STORE_ID: this.store.id,
      APPOINTMENT_TIME: this.appointmentTime,
      OPTION_ID: this.option.id,
      CREATED_AT: this.createdAt,
      CREATED_BY: this.createdBy,
      IS_CANCELED: this.isCanceled,
      IS_COMPLETED: this.isCompleted,
      IN_ROUTE: this.inRoute,
      DOC_ID: this.docId,
    };
  }

  static Future<Appointment> deserialize(
      Map<String, dynamic>? doc, String docId) async {
    Appointment appointment = Appointment();

    print(doc![CLIENT_ID]);

    appointment.client =
        await FirebaseController.getClientProfile(doc[CLIENT_ID]);
    appointment.store = await FirebaseController.getStoreProfile(doc[STORE_ID]);
    appointment.appointmentTime =
        doc[APPOINTMENT_TIME].toDate() ?? DateTime.now();
    appointment.option = await FirebaseController.getOption(doc[OPTION_ID]);
    appointment.createdAt = doc[CREATED_AT].toDate() ?? DateTime.now();
    appointment.createdBy = doc[CREATED_BY] ?? '';
    appointment.docId = doc[DOC_ID] ?? '';
    appointment.isCanceled = doc[IS_CANCELED] ?? false;
    appointment.isCompleted = doc[IS_COMPLETED] ?? false;
    appointment.inRoute = doc[IN_ROUTE] ?? false;

    return appointment;
  }

  static Future<List<Appointment>> deserializeToList(
      QuerySnapshot<Map<String, dynamic>> docs) async {
    List<Appointment> appointments = [];

    docs.docs.forEach((element) async {
      Appointment appointment = await deserialize(element.data(), element.id);

      appointments.add(appointment);
    });
    return appointments;
  }
}
