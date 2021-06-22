import 'dart:convert';
import 'dart:typed_data';

import 'package:cloud_firestore/cloud_firestore.dart';

class ChatRoomsRepo{

  FirebaseFirestore _firestore = FirebaseFirestore.instance;

  void createChatRoom(String title,Uint8List image){
    _firestore.collection("Rooms").add({
      "Title" : title,
      "Image" : base64.encode(image),
    });
  }
  
}