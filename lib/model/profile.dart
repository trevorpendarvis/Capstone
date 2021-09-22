
class Profile {
  String? docId;
  //AccountType? accountType;
  String? accountType; //?
  String? username;
  String? email;
  String? firstName;
  String? lastName;
  String? phone;
  String? address;
  String? vehicleColor;
  String? vehicleMake;
  String? favLocation;

//   //For firestore document
  //static const UID = "uid";
  static const ACCOUNT_TYPE = "accountType";
  static const USERNAME = "username";
  static const EMAIL = "email";
  static const FIRSTNAME = "firstName";
  static const LASTNAME = "lastName";
  static const PHONE = "phone";
  static const ADDRESS = "address";
  static const VEHICLE_COLOR = "vehicleColor";
  static const VEHICLE_MAKE = "vehicleMake";
  static const FAV_LOCATION = "favLocation";

  Profile({
    this.docId,
    this.accountType = '',
    this.username = '',
    this.email = '',
    this.firstName = '',
    this.lastName = '',
    this.phone = '',
    this.address = '',
    this.vehicleColor = '',
    this.vehicleMake = '',
    this.favLocation = '',
  });

  Profile.clone(Profile p) {
    this.docId = p.docId;
    this.accountType = p.accountType;
    this.username = p.username;
    this.email = p.email;
    this.firstName = p.firstName;
    this.lastName = p.lastName;
    this.phone = p.phone;
    this.address = p.address;
    this.vehicleColor = p.vehicleColor;
    this.vehicleMake = p.vehicleMake;
    this.favLocation = p.favLocation;
  }

  void assign(Profile p) {
    this.docId = p.docId;
    this.accountType = p.accountType;
    this.username = p.username;
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
      ACCOUNT_TYPE: this.accountType,
      USERNAME: this.username,
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

  static Profile deserialize(Map<String, dynamic>? doc, String docId) {
    return Profile(
      docId: docId,
      accountType: doc?[ACCOUNT_TYPE], //AccountType.CLIENT, 
      username: doc?[USERNAME],
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
