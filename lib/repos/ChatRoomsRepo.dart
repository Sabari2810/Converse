import 'dart:convert';
import 'dart:typed_data';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_chat/models/RoomsModel.dart';

class ChatRoomsRepo{

  FirebaseFirestore _firestore = FirebaseFirestore.instance;

  void createChatRoom(String title,Uint8List image){
    _firestore.collection("Rooms").add({
      "Title" : title,
      "Image" : base64.encode(image),
    });
  }

  Stream<List<RoomsModel>> get getChatRooms {
    return _firestore
        .collection("Rooms").orderBy("Title")
        .snapshots()
        .map((snapshots) => snapshots.docs
            .map(
              (e) => RoomsModel(
                title: e.get("Title"),
                chatRoomDocId: e.id,
                image: e.get("Image")
              ),
            )
            .toList());
  }
  
}