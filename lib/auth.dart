import 'package:firebase_auth/firebase_auth.dart';
import 'package:fluttertoast/fluttertoast.dart';

class Auth {

  static Future<String?> signIn() async {
    try {
      UserCredential ucred = await FirebaseAuth.instance.signInAnonymously();
      if (ucred.user == null) {
        Fluttertoast.showToast(
          msg: "Failed login",
        );
      } else {
        print("Signed in anonymously uid:${ucred.user!.uid}");
      }
      return ucred.user?.uid;
    } on FirebaseAuthException catch (e) {
      switch (e.code) {
        case "operation-not-allowed":
          print("Anonymous auth hasn't been enabled for this project.");
          break;
        default:
          print("Unknown error.");
      }
    }
    return null;
  }

}