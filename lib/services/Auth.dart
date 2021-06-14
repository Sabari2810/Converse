import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_chat/models/UserModel.dart';
import 'package:flutter_chat/services/Database.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AuthUser with ChangeNotifier {
  FirebaseAuth _auth = FirebaseAuth.instance;
  FirebaseFirestore _firestore = FirebaseFirestore.instance;

  String userid = "";

  void setUserId(String uid) {
    this.userid = uid;
  }

  Future<dynamic> registerUsingEmail(
      String username, String email, String password) async {
    try {
      var firebaseuser = await _auth.createUserWithEmailAndPassword(
          email: email, password: password);
      if (firebaseuser.user!.uid != "") {
        var docrefid = await Database()
            .createNewUser(username, email, firebaseuser.user!.uid, password);
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
      if (firebaseuser.user!.email != null) {
        _firestore.collection("users").doc(this.userid).update({
          "isLoggedIn": true,
        });
        return _createUserFromFirebaseUser(firebaseuser);
      }
    } catch (e) {
      if (e is FirebaseAuthException) {
        if (e.code == "user-not-found") {
          return e.code;
        }
      }
      return null;
    }
  }

  Future<void> signOut() async {
    await _auth.signOut();
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
    );
  }

  void setUserIdInLocalStorage(String uid) async {
    SharedPreferences _preferences = await SharedPreferences.getInstance();
    _preferences.setString("flutter_chat_user_id", uid);
  }

  Future<String?> getUserIdFromLocalStorage() async {
    final prefs = await SharedPreferences.getInstance();
    this.setUserId(prefs.getString("flutter_chat_user_id")!);
    return prefs.getString("flutter_chat_user_id");
  }

  Stream<bool> get getSession {
    // return _firestore.collection("users")
    //     .where("UserId", isEqualTo: userid)
    //     .snapshots()
    //     .map(
    //       (e) => e.docs[0].get("isLoggedIn"),
    //     );
    return _firestore
        .collection("users")
        .doc(this.userid)
        .snapshots()
        .map((event) => event.get("isLoggedIn"));
  }

  logoutSession() async {
    _firestore
        .collection("users")
        .doc(this.userid)
        .update({"isLoggedIn": false});
  }
}
