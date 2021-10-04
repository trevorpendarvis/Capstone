import 'package:cloud_firestore/cloud_firestore.dart';

class Location {
  String StoreName = '';
  String StoreAddress = '';
  String storeId = '';

  static const COLLECTION = "location";
  static const STORE_NAME = "StoreName";
  static const STORE_ADDRESS = "StoreAddress";
  static const STORE_ID = "store_id";

  Location();

  Map<String, dynamic> serialize(String storeId) {
    return <String, dynamic>{
      STORE_NAME: this.StoreName,
      STORE_ADDRESS: this.StoreAddress,
      STORE_ID: storeId,
    };
  }

  static Location deserialize(Map<String, dynamic>? doc, String docId) {
    Location location = Location();
    location.StoreName = doc?[STORE_NAME];
    location.StoreAddress = doc?[STORE_ADDRESS];
    location.storeId = doc?[STORE_ID];
    return location;
  }

  static List<Location> deserializeToList(QuerySnapshot<Map<String, dynamic>> docs) {
    List<Location> locations = [];

    docs.docs.forEach((element) {
        locations.add(deserialize(element.data(), element.id));
    });
    return locations;
  }
}
