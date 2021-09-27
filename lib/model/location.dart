class Location {
  String StoreName = '';
  String StoreAddress = '';

  static const COLLECTION = "location";
  static const STORE_NAME = "StoreName";
  static const STORE_ADDRESS = "StoreAddress";

  Location();

  Map<String, dynamic> serialize(String storeId) {
    return <String, dynamic>{
      STORE_NAME: this.StoreName,
      STORE_ADDRESS: this.StoreAddress,
    };
  }

  static Location deserialize(Map<String, dynamic>? doc, String docId) {
    Location location = Location();
    location.StoreName = doc?[STORE_NAME];
    location.StoreAddress = doc?[STORE_ADDRESS];
    return location;
  }
}
