class Client {
  String? docId;
  String? userName;
  String? email;
  String? firstName;
  String? lastName;
  String? phone;
  String? address;
  String? vehicleColor;
  String? vehicleMake;
  String? favLocation;

  //For firestore document
  static const COLLECTION = "clients";
  static const USERNAME = "username";
  static const EMAIL = "email";
  static const FIRSTNAME = "firstName";
  static const LASTNAME = "lastName";
  static const PHONE = "phone";
  static const ADDRESS = "address";
  static const VEHICLE_COLOR = "vehicleColor";
  static const VEHICLE_MAKE = "vehicleMake";
  static const FAV_LOCATION = "favLocation";

  Client({
    this.docId,
    this.userName = '',
    this.email = '',
    this.firstName = '',
    this.lastName = '',
    this.phone = '',
    this.address = '',
    this.vehicleColor = '',
    this.vehicleMake = '',
    this.favLocation = '',
  });

  Client.clone(Client p) {
    this.docId = p.docId;
    this.userName = p.userName;
    this.email = p.email;
    this.firstName = p.firstName;
    this.lastName = p.lastName;
    this.phone = p.phone;
    this.address = p.address;
    this.vehicleColor = p.vehicleColor;
    this.vehicleMake = p.vehicleMake;
    this.favLocation = p.favLocation;
  }

  void assign(Client p) {
    this.docId = p.docId;
    this.userName = p.userName;
    this.email = p.email;
    this.firstName = p.firstName;
    this.lastName = p.lastName;
    this.phone = p.phone;
    this.address = p.address;
    this.vehicleColor = p.vehicleColor;
    this.vehicleMake = p.vehicleMake;
    this.favLocation = p.favLocation;
  }

  //From Dart object to Firestore doc
  Map<String, dynamic> serialize() {
    return <String, dynamic>{
      // ACCOUNT_TYPE: this.accountType,
      USERNAME: this.userName,
      EMAIL: this.email,
      FIRSTNAME: this.firstName,
      LASTNAME: this.lastName,
      PHONE: this.phone,
      ADDRESS: this.address,
      VEHICLE_COLOR: this.vehicleColor,
      VEHICLE_MAKE: this.vehicleMake,
      FAV_LOCATION: this.favLocation,
    };
  }

  static Client deserialize(Map<String, dynamic>? doc, String docId) {
    return Client(
      docId: docId,
      userName: doc?[USERNAME],
      email: doc?[EMAIL],
      firstName: doc?[FIRSTNAME], //Do I need all these "?"?
      lastName: doc?[LASTNAME],
      phone: doc?[PHONE],
      address: doc?[ADDRESS],
      vehicleColor: doc?[VEHICLE_COLOR],
      vehicleMake: doc?[VEHICLE_MAKE],
      favLocation: doc?[FAV_LOCATION],
    );
  }
}
