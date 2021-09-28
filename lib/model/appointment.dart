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
}