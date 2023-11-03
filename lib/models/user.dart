import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class UserModel extends ChangeNotifier {
  final db = FirebaseFirestore.instance;

  String? _uid;

  late DocumentReference<Map<String, dynamic>> _userDocRef;

  String _name = "";
  String _tagline = "";
  List<String> _clubIds = [];
  List<Club> _clubs = [];

  String get name => _name;
  String get tagline => _tagline;
  List<Club> get clubs => _clubs;
  bool get loaded => _uid != null;

  Future<bool> load(String uid) async {
    _uid = uid;

    _userDocRef = db.collection("users").doc(_uid);
    var userDoc = await _userDocRef.get();
    if (!userDoc.exists) {
      _userDocRef.set({"name": "", "tagline": "", "clubs": []});
      return false;
    }

    var data = userDoc.data();
    _name = data?["name"];
    _tagline = data?["tagline"];
    _clubIds = data?['clubs'] is Iterable ? List.from(data?['clubs']) : [];

    for (var clubId in _clubIds) {
      var doc = await db.collection("clubs").doc(clubId).get();
      doc.exists ? _clubs.add(Club(doc.data()!)) : null;
    }

    notifyListeners();
    return true;
  }

  void update({String? name, String? tagline}) {
    _name = name ?? "";
    _tagline = tagline ?? "";

    _userDocRef.update({"name": _name, "tagline": _tagline});

    notifyListeners();
  }

  Future<bool> joinClub(String code) async {
    final clubDocRef = db.collection("clubs").doc(code);
    var clubDoc = await clubDocRef.get();
    if (!clubDoc.exists) {
      return false;
    }
    clubDocRef.update({
      "users": FieldValue.arrayUnion([_uid])
    });
    _userDocRef.update({
      "clubs": FieldValue.arrayUnion([code])
    });
    _clubIds.add(code);
    _clubs.add(Club(clubDoc.data()!));
    notifyListeners();
    return true;
  }
}

class Club {
  String name = "";
  Club(Map<String, dynamic> data) {
    name = data["name"];
  }
}
