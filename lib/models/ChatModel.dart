import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';

class ChatModel{
 final String name;
 final String message;
 final Timestamp timestamp;
 final String userDocId;

ChatModel({required this.name,required this.message,required this.timestamp,required this.userDocId});


get getname{
  return name;
}

String get getDate{
  DateTime datetime = timestamp.toDate();
  return datetime.toIso8601String();
}

}