import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:monkey_management/model/data.dart';
import 'package:monkey_management/model/client.dart';
import 'package:monkey_management/model/option.dart';
import 'package:monkey_management/model/store.dart';

class FirebaseController {
  /*
  * Set accountType as Store first
  * see if the current user is in Client collection
  * if he/she is, change accountType to Client
  * Otherwise, he/she is still Store
  * */
  static Future<AccountType> getAccountType() async {
    var accountType = AccountType.STORE;

    try {
      await FirebaseFirestore.instance
          .collection(Client.COLLECTION)
          .doc(FirebaseAuth.instance.currentUser!.uid)
          .get()
          .then((DocumentSnapshot<Map<String, dynamic>> documentSnapshot) {
        if (documentSnapshot.exists) {
            accountType = AccountType
                .CLIENT; //Changed from account_type to accountType -Caitlyn
        }
      });
    } catch (e) {
      print(e);
    }
    return accountType;
  }

  static Future<User?> signIn(
      {required String? email, required String? password}) async {
    UserCredential userCredential =
        await FirebaseAuth.instance.signInWithEmailAndPassword(
      email: email!,
      password: password!,
    );

    return userCredential.user;
  }

  static Future<void> signOut() async {
    await FirebaseAuth.instance.signOut();
  }

  static Future<void> createNewClient(
      {required String email, required String password}) async {
    //UserCredential userCredential =
    await FirebaseAuth.instance.createUserWithEmailAndPassword(
      email: email,
      password: password,
    );

    // Implement in addClientProfile()
    // Create the user's profile with default settings.

    // final FirebaseAuth auth = FirebaseAuth.instance;
    // final User? user = auth.currentUser;
    //
    // final DocumentReference ref =
    //     FirebaseFirestore.instance.collection(Client.COLLECTION).doc(user!.uid);
    //
    // var userData = {
    //   // 'docId': user.uid,
    //   // 'username': '',
    //   // 'email': user.email,
    //   // 'firstName': '',
    //   // 'lastName': '',
    //   // 'phone': '',
    //   // 'address': '',
    //   // 'vehicleColor': '',
    //   // 'vehicleMake': '',
    //   // 'favLocation': '',
    // };
    // await ref.set(userData);

  }

  static Future<void> createNewStore(
      {required String email, required String password}) async {
    //UserCredential userCredential =
    await FirebaseAuth.instance.createUserWithEmailAndPassword(
      email: email,
      password: password,
    );

    // Implement in addStoreProfile
    //Create the user's profile with default settings.
    // final FirebaseAuth auth = FirebaseAuth.instance;
    // final User? user = auth.currentUser;
    //
    // final DocumentReference ref =
    //     FirebaseFirestore.instance.collection(Store.COLLECTION).doc(user!.uid);
    //
    // var userData = {
    //   // 'docId': user.uid,
    //   // 'accountType': 'CLIENT',
    //   // 'username': '',
    //   'email': user.email,
    //   // 'firstName': '',
    //   // 'lastName': '',
    //   // 'phone': '',
    //   // 'address': '',
    //   // 'vehicleColor': '',
    //   // 'vehicleMake': '',
    //   // 'favLocation': '',
    // };
    // await ref.set(userData);

  }

  //Get a client's profile from Firebase
  static Future<Client> getClientProfile(String uid) async {
    var result =
        await FirebaseFirestore.instance.collection(Client.COLLECTION).doc(uid).get();

    return Client.deserialize(result.data(), uid);
  }

  //Get a store's profile from Firebase
  // static Future<Client> getStoreProfile(String uid) async {
  //   var result =
  //   await FirebaseFirestore.instance.collection(Store.COLLECTION).doc(uid).get();
  //
  //   return Store.deserialize(result.data(), uid);
  // }



  static Future<void> addClientProfile(Client? profile) async {
    final FirebaseAuth auth = FirebaseAuth.instance;
    final User? user = auth.currentUser;

    DocumentReference ref =
        FirebaseFirestore.instance.collection(Client.COLLECTION).doc(user!.uid);

    await ref.set(profile!.serialize());
  }


  // static Future<void> addStoreProfile(Store? profile) async {
  //   final FirebaseAuth auth = FirebaseAuth.instance;
  //   final User? user = auth.currentUser;
  //
  //   DocumentReference ref =
  //   FirebaseFirestore.instance.collection(Client.COLLECTION).doc(user!.uid);
  //
  //   await ref.set(profile!.serialize());
  // }

  static Future<void> addOption(Option option) async {
    final User? currentUser = FirebaseAuth.instance.currentUser;


    DocumentReference ref =
    FirebaseFirestore.instance.collection(Option.COLLECTION).doc();

    await ref.set(option.serialize(currentUser!.uid));
  }
}
