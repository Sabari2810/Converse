import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_chat/models/UserModel.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AuthUser with ChangeNotifier {
  FirebaseAuth _auth = FirebaseAuth.instance;
  FirebaseFirestore _firestore = FirebaseFirestore.instance;

  String userid = "";
  String currentUserName = "";

  void setUserId(String uid) {
    this.userid = uid;
  }

  void setUserName(String userName) {
    this.currentUserName = userName;
  }

  Future<dynamic> registerUsingEmail(
      String username, String email, String password) async {
    try {
      var firebaseuser = await _auth.createUserWithEmailAndPassword(
          email: email, password: password);
      await firebaseuser.user!.updateDisplayName(username);
      if (firebaseuser.user!.uid != "") {
        var docrefid = await createNewUser(username, email, firebaseuser.user!.uid);
        this.setUserIdInLocalStorage(docrefid);
        notifyListeners();
      }
      return _createUserFromFirebaseUser(firebaseuser);
      // return null;
    } catch (e) {
      if (e is FirebaseAuthException) {
        if (e.code == "email-already-in-use") {
          return e.message;
        }
      }
      return null;
    }
  }

  Future<dynamic> sigInUsingEmail(String email, String password) async {
    try {
      UserCredential firebaseuser = await _auth.signInWithEmailAndPassword(
          email: email, password: password);
      // String id = await _firestore.collection("users").where("UserId",isEqualTo: firebaseuser.user!.uid).get().then((value) => value.docs[0].id);
      String id = await getUserDocRefId(firebaseuser.user!.uid);
      if (firebaseuser.user!.email != null) {
        _firestore.collection("users").doc(id).update({
          "isLoggedIn": true,
        });
        setUserName(firebaseuser.user!.displayName.toString());

        setUserIdInLocalStorage(id);
        notifyListeners();
        return _createUserFromFirebaseUser(firebaseuser);
      }
    } catch (e) {
      if (e is FirebaseAuthException) {
        if (e.code == "user-not-found") {
          return "Invalid User";
        } else if (e.code == "wrong-password") {
          return "Invalid Password";
        } else if (e.code == "too-many-requests") {
          return e.message;
        }
      }
      return null;
    }
  }

  Stream<UserModel> get onauthchanged {
    return _auth.authStateChanges().map(
          (user) => UserModel(
            id: user!.uid,
            email: user.email.toString(),
          ),
        );
  }

  UserModel _createUserFromFirebaseUser(UserCredential firebaseuser) {
    return UserModel(
        id: firebaseuser.user!.uid,
        email: firebaseuser.user!.email.toString(),
        displayName: firebaseuser.user!.displayName.toString());
  }

  void setUserIdInLocalStorage(String uid) async {
    SharedPreferences _preferences = await SharedPreferences.getInstance();
    _preferences.setString("flutter_chat_user_id", uid);
    getUserIdFromLocalStorage();
  }

  Future<String?> getUserIdFromLocalStorage() async {
    final prefs = await SharedPreferences.getInstance();
    var userid = prefs.getString("flutter_chat_user_id") ?? "";
    this.setUserId(userid);
    return prefs.getString("flutter_chat_user_id") ?? null;
  }

  Stream<bool> get getSession {
    return _firestore
        .collection("users")
        .doc(this.userid)
        .snapshots()
        .map((event) => event.get("isLoggedIn"));
  }

  void getUserNameFromFirebase() async {
    dynamic res = await _firestore.collection("users").doc(this.userid).get();
    dynamic res2 = res["UserName"];
    this.setUserName(res2);
  }

  logoutSession() async {
    _firestore
        .collection("users")
        .doc(this.userid)
        .update({"isLoggedIn": false});
  }

  Future<String> getUserDocRefId(String userid) async {
    return await _firestore
        .collection("users")
        .where("UserId", isEqualTo: userid)
        .get()
        .then((value) => value.docs[0].id);
  }

  Future<String> createNewUser(
      String username, String email, String uid) async {
    var res = await _firestore.collection("users").add(
      {
        "UserName": username,
        "UserId": uid,
        "Email": email,
        "isLoggedIn": true,
      },
    ).then((value) => value.id);
    return res;
  }
}
