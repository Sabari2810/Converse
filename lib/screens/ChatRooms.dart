import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_chat/models/RoomsModel.dart';
import 'package:flutter_chat/repos/ChatRoomRepo.dart';
import 'package:flutter_chat/screens/ChatRoom.dart';
import 'package:flutter_chat/services/Auth.dart';
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
    AuthUser _authUser = Provider.of<AuthUser>(context);

    return Scaffold(
      appBar: AppBar(
        title: Text("Flutter Chat"),
        centerTitle: true,
        actions: [
          TextButton.icon(
            onPressed: () {
              _authUser.logoutSession();
            },
            icon: Icon(
              Icons.logout,
              color: Colors.white,
            ),
            label: Text(
              "LogOut",
              style: TextStyle(color: Colors.white),
            ),
          )
        ],
      ),
      body: Container(
        margin: EdgeInsets.only(left: 20.0, right: 20.0),
        child: Center(
          child: ListView.builder(
            shrinkWrap: true,
            itemCount: rooms.length,
            itemBuilder: (context, index) {
              return Card(
                child: Container(
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      colors: [
                        Colors.green.shade400,
                        Colors.green.shade400,
                        Colors.green.shade400
                      ],
                    ),
                    borderRadius: BorderRadius.circular(5.0),
                  ),
                  child: Column(
                    children: [
                      ListTile(
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => ChatRoomWithProvider(
                                title: rooms.elementAt(index).title.toString(),
                                chatRoomDocId: rooms.elementAt(index).chatRoomDocId,
                              ),
                            ),
                          );
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
      ),
    );
  }
}
