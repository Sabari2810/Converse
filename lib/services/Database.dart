import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_chat/models/RoomsModel.dart';

class Database {
  FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Stream<List<RoomsModel>> get getChatRooms {
    return _firestore.collection("Rooms").snapshots().map((snapshots) => snapshots.docs.map((e) => RoomsModel(title : e.get("Title"))).toList());
  }

  void addChatRoom(String title){
    _firestore.collection("Rooms").add({"Title" : title});
  }

}
