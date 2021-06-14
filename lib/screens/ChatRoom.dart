import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_chat/models/ChatModel.dart';
import 'package:flutter_chat/repos/ChatRoomRepo.dart';
import 'package:flutter_chat/services/Auth.dart';
import 'package:flutter_chat/services/Database.dart';
import 'package:flutter_chat/viewmodels/ChatViewModel.dart';
import 'package:provider/provider.dart';

class ChatRoomWithProvider extends StatelessWidget {
  // const ({ Key? key }) : super(key: key);

  final String title;
  final String chatRoomDocId;

  ChatRoomWithProvider({this.title = "", this.chatRoomDocId = ""});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
        create: (context) => ChatRoomRepo(),
        child: ChatRoom(
          title: title,
          chatRoomDocId: chatRoomDocId,
        ));
  }
}

class ChatRoom extends StatelessWidget {
  final String title;
  final String chatRoomDocId;
  ChatRoom({Key? key, this.title = "", this.chatRoomDocId = ""})
      : super(key: key);

  late ChatRoomRepo _chatRoomRepo;

  @override
  Widget build(BuildContext context) {
    _chatRoomRepo = Provider.of<ChatRoomRepo>(context);
    _chatRoomRepo.setCurrentChatRoom(title);
    _chatRoomRepo.setCurrentChatRoomDocId(chatRoomDocId);

    return Scaffold(
      appBar: AppBar(
        title: Text(this.title),
        centerTitle: true,
        actions: [
          IconButton(
              onPressed: () {
                AuthUser().signOut();
              },
              icon: Icon(Icons.logout))
        ],
      ),
      body: StreamProvider<List<ChatModel>>.value(
        initialData: [],
        value: _chatRoomRepo.chatRoomChats,
        child: ChatRoomWidget(),
      ),
    );
  }
}

class ChatRoomWidget extends StatefulWidget {
  // const ChatRoomWidget({Key? key}) : super(key: key);

  @override
  _ChatRoomWidgetState createState() => _ChatRoomWidgetState();
}

class _ChatRoomWidgetState extends State<ChatRoomWidget> {
  String _chatMessage = "";
  final controller = TextEditingController();
  late ChatRoomRepo _chatRoomRepo;

  @override
  Widget build(BuildContext context) {
    List<ChatModel> vm = Provider.of<List<ChatModel>>(context);
    _chatRoomRepo = Provider.of<ChatRoomRepo>(context);

    return Scaffold(
      body: Column(
        children: [
          Expanded(
            child: ListView.builder(
              keyboardDismissBehavior: ScrollViewKeyboardDismissBehavior.onDrag,
              physics: BouncingScrollPhysics(),
              reverse: true,
              itemCount: vm.length,
              shrinkWrap: true,
              itemBuilder: (context, index) {
                return Align(
                  alignment: index.isOdd
                      ? Alignment.centerLeft
                      : Alignment.centerRight,
                  child: Container(
                    color: Colors.transparent,
                    margin: EdgeInsets.only(left: 10.0),
                    child: Card(
                      child: Container(
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(10.0),
                          color: Colors.green,
                        ),
                        padding: EdgeInsets.all(10.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(vm.elementAt(index).getname),
                            Text(vm.elementAt(index).message),
                            Align(
                              alignment: Alignment.centerRight,
                              child: Text(
                                vm.elementAt(index).getDate,
                              ),
                            )
                          ],
                        ),
                      ),
                    ),
                  ),
                );
              },
            ),
          ),
          _textInput(context)
        ],
      ),
    );
  }

  Widget _textInput(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        SizedBox(width: 16),
        Flexible(
          child: TextFormField(
            controller: controller,
            keyboardType: TextInputType.text,
            maxLines: 2,
            obscureText: false,
            onChanged: (val) {
              setState(() {
                _chatMessage = val;
              });
            },
            decoration: InputDecoration(
              focusedBorder: InputBorder.none,
              border: InputBorder.none,
              labelStyle: TextStyle(color: Colors.grey.shade100),
              hintText: 'Send message',
            ),
          ),
        ),
        SizedBox(width: 12),
        IconButton(
          icon: Icon(Icons.send_rounded),
          onPressed: () {
            if (_chatMessage != "") {
              _chatRoomRepo.addMessage("Sabari", _chatMessage, Timestamp.now());
            }
          },
        ),
        SizedBox(width: 16)
      ],
    );
  }
}
