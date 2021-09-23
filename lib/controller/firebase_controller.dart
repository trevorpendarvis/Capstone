import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:monkey_management/model/data.dart';
import 'package:monkey_management/model/profile.dart';

class FirebaseController {
  static Future<AccountType> getAccountType() async {
    var isClient = AccountType.STORE;

    try {
      await FirebaseFirestore.instance
          .collection('accounts')
          .doc(FirebaseAuth.instance.currentUser!.uid)
          .get()
          .then((DocumentSnapshot<Map<String, dynamic>> documentSnapshot) {
        if (documentSnapshot.exists) {
          if (documentSnapshot['accountType'] == 'CLIENT')
            isClient = AccountType
                .CLIENT; //Changed from account_type to accountType -Caitlyn
        }
      });
    } catch (e) {
      print(e);
    }

    return isClient;
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

  static Future<void> createNewAccount(
      {required String email, required String password}) async {
    //UserCredential userCredential =
    await FirebaseAuth.instance.createUserWithEmailAndPassword(
      email: email,
      password: password,
    );

    //Create the user's profile with default settings.
    /*
    final FirebaseAuth auth = FirebaseAuth.instance;
    final User? user = auth.currentUser;

    final DocumentReference ref =
        FirebaseFirestore.instance.collection('accounts').doc(user!.uid);

    var userData = {
      'docId': user.uid,
      'accountType': 'CLIENT',
      'username': '',
      'email': user.email,
      'firstName': '',
      'lastName': '',
      'phone': '',
      'address': '',
      'vehicleColor': '',
      'vehicleMake': '',
      'favLocation': '',
    };
    await ref.set(userData);
    */
  }

  //Get a user's profile from Firebase
  static Future<Profile> getProfile(String uid) async {
    var result =
        await FirebaseFirestore.instance.collection('accounts').doc(uid).get();

    return Profile.deserialize(result.data(), uid);
  }

  static Future<void> signOut() async {
    await FirebaseAuth.instance.signOut();
  }

  static Future<void> addProfile(Profile? profile) async {
    final FirebaseAuth auth = FirebaseAuth.instance;
    final User? user = auth.currentUser;

    DocumentReference ref =
        await FirebaseFirestore.instance.collection('accounts').doc(user!.uid);

    await ref.set(profile!.serialize());
  }
}
