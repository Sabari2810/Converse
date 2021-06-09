import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_chat/models/ChatModel.dart';
import 'package:flutter_chat/services/Database.dart';
import 'package:flutter_chat/viewmodels/ChatViewModel.dart';
import 'package:provider/provider.dart';

class ChatRoom extends StatelessWidget {
  final String title;
  ChatRoom({Key? key, this.title = ""}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(this.title),
        centerTitle: true,
      ),
      body: StreamProvider<List<ChatModel>>.value(
          initialData: [],
          value: ChatViewModel().chatRoom1,
          child: ChatRoomWidget()),
    );
  }
}

class ChatRoomWidget extends StatefulWidget {
  const ChatRoomWidget({Key? key}) : super(key: key);

  @override
  _ChatRoomWidgetState createState() => _ChatRoomWidgetState();
}

class _ChatRoomWidgetState extends State<ChatRoomWidget> {
  String _chatMessage = "";
  final controller = TextEditingController();

  @override
  Widget build(BuildContext context) {
    List<ChatModel> vm = Provider.of<List<ChatModel>>(context);
    return Scaffold(
      body: Column(
        children: [
          Expanded(
            child: ListView.builder(
              keyboardDismissBehavior: ScrollViewKeyboardDismissBehavior.onDrag,
              physics: BouncingScrollPhysics(),
              reverse: false,
              itemCount: vm.length,
              // shrinkWrap: true,
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
                          children: [
                            Text(vm.elementAt(index).getname),
                            Text(vm.elementAt(index).message),
                            Text(vm.elementAt(index).getDate)
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
              ChatViewModel().addChat("Chat Room 1", "Craig", _chatMessage,Timestamp.now());
              controller.text = "";
            }
          },
        ),
        SizedBox(width: 16)
      ],
    );
  }
}
