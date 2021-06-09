import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_chat/models/ChatModel.dart';
import 'package:flutter_chat/models/RoomsModel.dart';

class Database {
  FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Stream<List<RoomsModel>> get getChatRooms {
    return _firestore.collection("Rooms").snapshots().map((snapshots) => snapshots.docs.map((e) => RoomsModel(title : e.get("Title"))).toList());
  }

  Stream<List<ChatModel>> get chatRoom1{
    try{
    return _firestore.collection("Chat Room 1").orderBy("Timestamp").snapshots().map((snapshot) => snapshot.docs.map((doc) => ChatModel(name: doc.get("Name"),message: doc.get("Message"),timestamp: doc.get("Timestamp"))).toList());
    }
    catch(e){
      throw e;
    }
  }

  void addMessage(String collectionname,String username,String message,Timestamp time){
    _firestore.collection(collectionname).add({"Name" : username,"Message" : message,"Timestamp" : time});
  }

  void addChatRoom(String title){
    _firestore.collection("Rooms").add({"Title" : title});
  }

}
