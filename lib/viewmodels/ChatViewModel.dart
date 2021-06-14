

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_chat/models/ChatModel.dart';
import 'package:flutter_chat/services/Database.dart';

class ChatViewModel{

  Stream<List<ChatModel>> get chatRoom1 {
    return Database().chatRoom1;
  }

  void addChat(String collectionname,String username,String message,Timestamp time){
    // Database().addMessage(collectionname, username, message , time);
  }

}