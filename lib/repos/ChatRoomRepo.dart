import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_chat/models/ChatModel.dart';

class ChatRoomRepo with ChangeNotifier {
  FirebaseFirestore _firestore = FirebaseFirestore.instance;

  String currentChatRoom = "";
  String currentChatRoomDocId = "";

  void setCurrentChatRoom(String chatroom) {
    this.currentChatRoom = chatroom;
  }

  void setCurrentChatRoomDocId(String chatroom) {
    this.currentChatRoomDocId = chatroom;
  }

  Stream<List<ChatModel>> get chatRoomChats {
    return _firestore
        .collection("Rooms")
        .doc(this.currentChatRoomDocId)
        .collection("chats")
        .orderBy("Timestamp",descending: true)
        .snapshots()
        .map(
          (snapshot) => snapshot.docs
              .map(
                (doc) => ChatModel(
                  name: doc.get("Name"),
                  message: doc.get("Message"),
                  timestamp: doc.get("Timestamp"),
                ),
              )
              .toList(),
        );
  }

  void addMessage(
      String username, String message, Timestamp time) {
    _firestore
        .collection("Rooms").doc(this.currentChatRoomDocId).collection("chats")
        .add({"Name": username, "Message": message, "Timestamp": time});
  }

}
