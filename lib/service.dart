import 'dart:math';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class Service {
  static final Service _instance = Service._internal();

  UserCredential? userCredential;
  String? uid;

  FirebaseFirestore db = FirebaseFirestore.instance;

  factory Service() {
    return _instance;
  }

  Service._internal() {
    signIn();
  }

  void signIn() async {
    try {
      userCredential = await FirebaseAuth.instance.signInAnonymously();
      uid = userCredential?.user?.uid;
      print("Signed in anonymously uid:$uid");
    } on FirebaseAuthException catch (e) {
      switch (e.code) {
        case "operation-not-allowed":
          print("Anonymous auth hasn't been enabled for this project.");
          break;
        default:
          print("Unknown error.");
      }
    }
  }

  Future<bool> joinClub(String code) async {
    final clubDocRef = db.collection("clubs").doc(code);
    var clubDoc = await clubDocRef.get();
    if (!clubDoc.exists) {
      return false;
    }
    clubDocRef.update({
      "users": FieldValue.arrayUnion([uid])
    });
    return true;
  }
}
