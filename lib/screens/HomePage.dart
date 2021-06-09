import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_chat/models/RoomsModel.dart';
import 'package:flutter_chat/screens/ChatRoom.dart';
import 'package:flutter_chat/screens/ChatRoom.dart';
import 'package:provider/provider.dart';

class ChatRooms extends StatefulWidget {
  const ChatRooms({Key? key}) : super(key: key);

  @override
  _ChatRoomsState createState() => _ChatRoomsState();
}

class _ChatRoomsState extends State<ChatRooms> {
  @override
  Widget build(BuildContext context) {
    
    List<RoomsModel> rooms = Provider.of<List<RoomsModel>>(context);

    return Container(
      margin: EdgeInsets.only(left: 20.0, right: 20.0),
      child: Center(
        child: ListView.builder(
          shrinkWrap: true,
          itemCount: rooms.length,
          itemBuilder: (context, index) {
            return Card(
              child: Container(
                decoration: BoxDecoration(
                    gradient: LinearGradient(colors: [
                      Colors.green.shade400,
                      Colors.green.shade400,
                      Colors.green.shade400
                    ]),
                    borderRadius: BorderRadius.circular(5.0)),
                child: Column(
                  children: [
                    ListTile(
                      onTap: () {
                        Navigator.push(
                            context,
                            CupertinoPageRoute(
                                builder: (context) => ChatRoom(
                                    title: rooms
                                        .elementAt(index)
                                        .title
                                        .toString())));
                      },
                      title: Text(
                        rooms.elementAt(index).title.toString(),
                        style: TextStyle(color: Colors.white),
                      ),
                    ),
                  ],
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}
