import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';

class UserModel extends ChangeNotifier {
  final db = FirebaseFirestore.instance;

  String? _uid;

  late DocumentReference<Map<String, dynamic>> _userDocRef;

  String _name = "";
  String _tagline = "";
  List<String> _clubIds = [];
  final List<Club> _clubs = [];

  String get name => _name;
  String get tagline => _tagline;
  List<Club> get clubs => _clubs;
  bool get loaded => _uid != null;

  Future<void> _getClub(String clubId) async {
    var doc = await db.collection("clubs").doc(clubId).get();
    if (doc.exists) {
      var latestMessageQuery = await db
          .collection("clubs")
          .doc(clubId)
          .collection("thread")
          .orderBy("time")
          .limit(1)
          .get();
      String latestMessage = '';
      if (latestMessageQuery.size > 0) {
        var latestMessageSnapshot = latestMessageQuery.docs[0];
        var userName = (await db
            .collection('users')
            .doc(latestMessageSnapshot.get('user_id'))
            .get())['name'];
        latestMessage = '$userName: ${latestMessageSnapshot.get('message')}';
      }
      var clubData = doc.data();
      _clubs.add(Club(doc.get("name"),
          lastMessage: latestMessage,
          img: clubData!.containsKey('img') ? clubData['img'] : ''));
    }
  }

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
      await _getClub(clubId);
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
    await _getClub(code);
    notifyListeners();
    return true;
  }

  Future<void> preloadImages(BuildContext context) async {
    List<Future<void>> futures = [];
    for (Club club in _clubs) {
      if (club.imgUrl.isNotEmpty) {
        futures.add(precacheImage(NetworkImage(club.imgUrl), context));
      }
    }
    Future.wait(futures);
  }
}

class Club {
  String name = "";
  String latestMessage = "";
  String imgUrl = "";
  Club(String name_, {String? lastMessage, String? img}) {
    name = name_;
    latestMessage = lastMessage ?? '';
    imgUrl = img ?? '';
  }
}
