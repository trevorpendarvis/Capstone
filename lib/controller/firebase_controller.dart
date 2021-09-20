import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:monkey_management/model/data.dart';

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
          if (documentSnapshot['account_type'] == 'CLIENT') isClient = AccountType.CLIENT;
        }
      });
    } catch (e) {
      print(e);
    }

    return isClient;
  }

  static Future<User?> signIn(
      {required String email,  required String password}) async {
    UserCredential userCredential =
    await FirebaseAuth.instance.signInWithEmailAndPassword(
      email: email,
      password: password,
    );

    return userCredential.user;
  }

  static Future<void> createNewAccount(
      {required String email, required String password}) async {
    UserCredential userCredential =
    await FirebaseAuth.instance.createUserWithEmailAndPassword(
      email: email,
      password: password,
    );
  }

  static Future<void> signOut() async {
    await FirebaseAuth.instance.signOut();
  }
}