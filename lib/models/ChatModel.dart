import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';

class ChatModel{
 final String name;
 final String message;
 final Timestamp timestamp;

ChatModel({required this.name,required this.message,required this.timestamp});


get getname{
  return name;
}

String get getDate{
  DateTime datetime = timestamp.toDate();
  return datetime.hour.toString()+datetime.minute.toString()+datetime.second.toString();
}

}