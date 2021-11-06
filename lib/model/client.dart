class Client {
  String? docId;
  //String? userName;
  String? email;
  String? firstName;
  String? lastName;
  String? phone;
  String? address;
  String? vehicleColor;
  String? vehicleMake;
  String? favLocation;
  String? cardNum;
  String? cardName;
  String? cardExp;
  String? cardCVV;

  //For firestore document
  static const COLLECTION = "clients";
  //static const USERNAME = "username";
  static const EMAIL = "email";
  static const FIRSTNAME = "firstName";
  static const LASTNAME = "lastName";
  static const PHONE = "phone";
  static const ADDRESS = "address";
  static const VEHICLE_COLOR = "vehicleColor";
  static const VEHICLE_MAKE = "vehicleMake";
  static const FAV_LOCATION = "favLocation";
  static const CARD_NUM = "cardNum";
  static const CARD_NAME = "cardName";
  static const CARD_EXP = "cardExp";
  static const CARD_CVV = "cardCVV";

  Client({
    this.docId,
    //this.userName = '',
    this.email = '',
    this.firstName = '',
    this.lastName = '',
    this.phone = '',
    this.address = '',
    this.vehicleColor = '',
    this.vehicleMake = '',
    this.favLocation = '',
    this.cardNum = '',
    this.cardName = '',
    this.cardExp = '',
    this.cardCVV = '',
  });

  Client.clone(Client p) {
    this.docId = p.docId;
    //this.userName = p.userName;
    this.email = p.email;
    this.firstName = p.firstName;
    this.lastName = p.lastName;
    this.phone = p.phone;
    this.address = p.address;
    this.vehicleColor = p.vehicleColor;
    this.vehicleMake = p.vehicleMake;
    this.favLocation = p.favLocation;
    this.cardNum = p.cardNum;
    this.cardName = p.cardName;
    this.cardExp = p.cardExp;
    this.cardCVV = p.cardCVV;
  }

  void assign(Client p) {
    this.docId = p.docId;
    //this.userName = p.userName;
    this.email = p.email;
    this.firstName = p.firstName;
    this.lastName = p.lastName;
    this.phone = p.phone;
    this.address = p.address;
    this.vehicleColor = p.vehicleColor;
    this.vehicleMake = p.vehicleMake;
    this.favLocation = p.favLocation;
    this.cardNum = p.cardNum;
    this.cardName = p.cardName;
    this.cardExp = p.cardExp;
    this.cardCVV = p.cardCVV;
  }

  //From Dart object to Firestore doc
  Map<String, dynamic> serialize() {
    return <String, dynamic>{
      // ACCOUNT_TYPE: this.accountType,
      //USERNAME: this.userName,
      EMAIL: this.email,
      FIRSTNAME: this.firstName,
      LASTNAME: this.lastName,
      PHONE: this.phone,
      ADDRESS: this.address,
      VEHICLE_COLOR: this.vehicleColor,
      VEHICLE_MAKE: this.vehicleMake,
      FAV_LOCATION: this.favLocation,
      CARD_NUM: this.cardNum,
      CARD_NAME: this.cardName,
      CARD_EXP: this.cardExp,
      CARD_CVV: this.cardCVV,
    };
  }

  static Client deserialize(Map<String, dynamic>? doc, String docId) {
    return Client(
      docId: docId,
      //userName: doc?[USERNAME] ?? '',
      email: doc?[EMAIL] ?? '',
      firstName: doc?[FIRSTNAME] ?? '', //Do I need all these "?"?
      lastName: doc?[LASTNAME] ?? '',
      phone: doc?[PHONE] ?? '',
      address: doc?[ADDRESS] ?? '',
      vehicleColor: doc?[VEHICLE_COLOR] ?? '',
      vehicleMake: doc?[VEHICLE_MAKE] ?? '',
      favLocation: doc?[FAV_LOCATION] ?? '',
      cardNum: doc?[CARD_NUM] ?? '',
      cardName: doc?[CARD_NAME] ?? '',
      cardExp: doc?[CARD_EXP] ?? '',
      cardCVV: doc?[CARD_CVV] ?? '',
    );
  }
}
