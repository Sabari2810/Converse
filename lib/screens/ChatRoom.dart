import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_chat/models/ChatModel.dart';
import 'package:flutter_chat/repos/ChatRoomRepo.dart';
import 'package:flutter_chat/utils/palette.dart';
import 'package:provider/provider.dart';

class ChatRoomWithProvider extends StatelessWidget {
  // const ({ Key? key }) : super(key: key);

  String title;
  String chatRoomDocId;
  String userDocId;
  String displayName;
  String image;

  ChatRoomWithProvider(
      {this.title = "",
      this.chatRoomDocId = "",
      this.userDocId = "",
      this.displayName = "",
      this.image = ""});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
        create: (context) => ChatRoomRepo(),
        child: ChatRoom(
          title: title,
          chatRoomDocId: chatRoomDocId,
          userDocId: userDocId,
          displayName: displayName,
          image: image,
        ));
  }
}

class ChatRoom extends StatelessWidget {
  final String title;
  final String chatRoomDocId;
  final String userDocId;
  final String displayName;
  final String image;

  ChatRoom(
      {Key? key,
      this.title = "",
      this.chatRoomDocId = "",
      this.userDocId = "",
      this.displayName = "",
      this.image = ""})
      : super(key: key);

  late ChatRoomRepo _chatRoomRepo;

  @override
  Widget build(BuildContext context) {
    _chatRoomRepo = Provider.of<ChatRoomRepo>(context);

    _chatRoomRepo.setCurrentChatRoom(title);
    _chatRoomRepo.setCurrentChatRoomDocId(chatRoomDocId);

    return Scaffold(
      backgroundColor: Palette().bodyColor,
      appBar: AppBar(
        backgroundColor: Palette().appBarColor,
        title: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              height: 50,
              width: 50,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(100),
                image: DecorationImage(
                  fit: BoxFit.fill,
                  image: MemoryImage(
                    base64.decode(image)
                  )
                )
              ),
            ),
            SizedBox(
              width: 8.0,
            ),
            Text(
              this.title,
              style: TextStyle(color: Colors.black),
            ),
          ],
        ),
        leading: BackButton(
          color: Colors.black,
        ),
        actions: [
          IconButton(
            onPressed: () {
              // AuthUser().signOut();
            },
            icon: Icon(
              Icons.more_vert_sharp,
              color: Colors.black,
            ),
          )
        ],
      ),
      body: StreamProvider<List<ChatModel>>.value(
        initialData: [],
        catchError: (_, __) => [],
        value: _chatRoomRepo.chatRoomChats,
        child: ChatRoomWidget(
          userDocId: userDocId,
          displayName: displayName,
        ),
      ),
    );
  }
}

class ChatRoomWidget extends StatefulWidget {
  String userDocId;
  String displayName;

  ChatRoomWidget({this.userDocId = "", this.displayName = ""});

  @override
  _ChatRoomWidgetState createState() => _ChatRoomWidgetState();
}

class _ChatRoomWidgetState extends State<ChatRoomWidget> {
  String _chatMessage = "";
  final _messageController = TextEditingController();
  late ChatRoomRepo _chatRoomRepo;
  late List<ChatModel> _chats;

  @override
  Widget build(BuildContext context) {
    _chats = Provider.of<List<ChatModel>>(context);
    _chatRoomRepo = Provider.of<ChatRoomRepo>(context);

    return Column(
      children: [
        Expanded(
          child: ListView.builder(
            keyboardDismissBehavior: ScrollViewKeyboardDismissBehavior.onDrag,
            physics: BouncingScrollPhysics(),
            reverse: true,
            itemCount: _chats.length,
            shrinkWrap: true,
            itemBuilder: (context, index) {
              return Align(
                alignment: _chats.elementAt(index).userDocId == widget.userDocId
                    ? Alignment.centerRight
                    : Alignment.centerLeft,
                child: Container(
                  color: Colors.transparent,
                  margin: EdgeInsets.only(left: 10.0),
                  child: Card(
                    elevation: 0,
                    color: Colors.transparent,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(15.0),
                    ),
                    child: Container(
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(10.0),
                        color: Colors.grey.shade200,
                      ),
                      padding: EdgeInsets.all(10.0),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          removeProfileDet(index)
                              ? Container()
                              : CircleAvatar(
                                  child:
                                      Text(_chats.elementAt(index).getname[0]),
                                ),
                          SizedBox(
                            width: 10,
                          ),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              removeProfileDet(index)
                                  ? Container()
                                  : Text(
                                      _chats.elementAt(index).getname,
                                    ),
                              SizedBox(
                                height: 3,
                              ),
                              Text(
                                _chats.elementAt(index).message,
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              );
            },
          ),
        ),
        _textInput(context),
        SizedBox(
          height: 3,
        )
      ],
    );
  }

  Widget _textInput(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        SizedBox(width: 20),
        Flexible(
          child: TextFormField(
            controller: _messageController,
            keyboardType: TextInputType.text,
            obscureText: false,
            onChanged: (val) {
              setState(() {
                _chatMessage = val;
              });
            },
            decoration: InputDecoration(
              focusedBorder: InputBorder.none,
              // border: OutlineInputBorder(
              //   borderRadius: BorderRadius.circular(20),
              // ),
              border: InputBorder.none,
              labelStyle: TextStyle(color: Colors.grey.shade100),
              isDense: true,
              hintText: 'Send message',
            ),
          ),
        ),
        SizedBox(width: 12),
        IconButton(
          icon: Icon(Icons.send_rounded),
          onPressed: () {
            if (_chatMessage != "") {
              _chatRoomRepo.addMessage(widget.displayName, _chatMessage,
                  Timestamp.now(), widget.userDocId);
              _messageController.text = "";
            }
          },
        ),
        SizedBox(width: 16)
      ],
    );
  }

  bool removeProfileDet(int currentIndex) {
    if (currentIndex < _chats.length - 1) {
      if (_chats.elementAt(currentIndex).userDocId ==
          _chats.elementAt(currentIndex + 1).userDocId) {
        return true;
      } else {
        return false;
      }
    } else {
      return false;
    }
  }
}
