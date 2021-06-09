import 'package:flutter/material.dart';
import 'package:flutter_chat/models/RoomsModel.dart';
import 'package:flutter_chat/screens/HomePage.dart';
import 'package:flutter_chat/services/Database.dart';
import 'package:provider/provider.dart';

class Wrapper extends StatefulWidget {
  const Wrapper({Key? key}) : super(key: key);

  @override
  _WrapperState createState() => _WrapperState();
}

class _WrapperState extends State<Wrapper> {
  @override
  Widget build(BuildContext context) {
    Database().getChatRooms;
    return Scaffold(
      appBar: AppBar(
        title: Text(
          "Flutter Chat",
          textAlign: TextAlign.center,
        ),
        centerTitle: true,
        backgroundColor: Colors.green,
      ),
      body: Container(
        decoration: BoxDecoration(color: Colors.black),
        child: StreamProvider<List<RoomsModel>>.value(
          initialData: [],
          value: Database().getChatRooms,
          child: ChatRooms(),
        ),
      ),
    );
  }
}
