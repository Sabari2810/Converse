import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_chat/models/RoomsModel.dart';
import 'package:flutter_chat/repos/ChatRoomsRepo.dart';
import 'package:flutter_chat/screens/ChatRoom.dart';
import 'package:flutter_chat/services/Auth.dart';
import 'package:flutter_chat/utils/palette.dart';
import 'package:flutter_chat/utils/toast.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';

class ChatRooms extends StatefulWidget {
  const ChatRooms({Key? key}) : super(key: key);

  @override
  _ChatRoomsState createState() => _ChatRoomsState();
}

class _ChatRoomsState extends State<ChatRooms> {
  final GlobalKey<FormState> _formkey = GlobalKey<FormState>();

  final picker = ImagePicker();
  dynamic _image = "";
  String _channelname = "";

  @override
  Widget build(BuildContext context) {
    List<RoomsModel> rooms = Provider.of<List<RoomsModel>>(context);
    AuthUser _authUser = Provider.of<AuthUser>(context);

    return Scaffold(
      persistentFooterButtons: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            Column(
              children: [
                Icon(Icons.search),
                Text("Search"),
              ],
            ),
            Column(
              children: [
                Icon(Icons.person_outline_outlined),
                Text("Profile"),
              ],
            ),
            GestureDetector(
              onTap: (){
                _authUser.logoutSession();
              },
              child: Column(
                children: [
                  Icon(Icons.logout),
                  Text("Log out"),
                ],
              ),
            ),
          ],
        ),
      ],
      body: SingleChildScrollView(
        child: Column(
          children: [
            SafeArea(
              child: Padding(
                padding:
                    const EdgeInsets.only(left: 10.0, top: 15.0, right: 20.0),
                child: Row(
                  children: [
                    Expanded(
                      child: Text(
                        "Chat Rooms",
                        style: TextStyle(
                          fontSize: 30.0,
                          fontWeight: FontWeight.w900,
                        ),
                      ),
                    ),
                    GestureDetector(
                      onTap: () {
                        showAddChatRoom();
                      },
                      child: Container(
                        padding: EdgeInsets.only(left: 10, right: 10),
                        decoration: BoxDecoration(
                          color: Palette().appBarColor,
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: Row(
                          children: [
                            Icon(
                              Icons.add,
                              size: 20,
                            ),
                            SizedBox(
                              width: 3,
                            ),
                            Text("Add")
                          ],
                        ),
                      ),
                    )
                  ],
                ),
              ),
            ),
            Padding(
              padding: EdgeInsets.only(top: 10, left: 10, right: 10),
              child: TextFormField(
                decoration: InputDecoration(
                  isDense: true,
                  hintText: "Search...",
                  prefixIcon: Icon(
                    Icons.search,
                  ),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(20),
                  ),
                ),
              ),
            ),
            GridView.builder(
              shrinkWrap: true,
              scrollDirection: Axis.vertical,
              physics: ScrollPhysics(),
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 4, childAspectRatio: 0.2 / 0.2),
              itemCount: rooms.length,
              itemBuilder: (context, index) {
                return Column(
                  children: [
                    GestureDetector(
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => ChatRoomWithProvider(
                              title: rooms.elementAt(index).title.toString(),
                              chatRoomDocId:
                                  rooms.elementAt(index).chatRoomDocId,
                              userDocId: _authUser.userid,
                              displayName: _authUser.currentUserName,
                              image: rooms.elementAt(index).image,
                            ),
                          ),
                        );
                      },
                      onLongPress: () {
                        showToast(context, rooms.elementAt(index).title);
                      },
                      child: Container(
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(20),
                          image: DecorationImage(
                              fit: BoxFit.fill,
                              image: MemoryImage(
                                base64.decode(
                                  rooms.elementAt(index).image,
                                ),
                              )),
                        ),
                        height: 70,
                        width: 70,
                        margin: EdgeInsets.all(10),
                        padding: EdgeInsets.all(10),
                      ),
                    ),
                  ],
                );
              },
            ),
          ],
        ),
      ),
    );
  }

  void showAddChatRoom() {
    showModalBottomSheet(
        isScrollControlled: true,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(50),
            topRight: Radius.circular(50),
          ),
        ),
        context: context,
        builder: (context) {
          return StatefulBuilder(builder: (context, StateSetter stateSetter) {
            return Container(
              padding: MediaQuery.of(context).viewInsets,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Padding(
                    padding: EdgeInsets.only(
                        left: 8.0, right: 8.0, bottom: 8.0, top: 12.0),
                    child: Text(
                      "Create a chat room",
                      style: TextStyle(
                          fontSize: 30.0, fontWeight: FontWeight.w900),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: GestureDetector(
                      onTap: () async {
                        dynamic res = await _selectImage();
                        if (res != null) {
                          stateSetter(() {
                            _image = res;
                          });
                        }
                      },
                      child: Stack(
                        alignment: Alignment.center,
                        children: [
                          _image.length > 0
                              ? Container(
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(100),
                                    image: DecorationImage(
                                      fit: BoxFit.fill,
                                      image: MemoryImage(_image),
                                    ),
                                  ),
                                  height: 100,
                                  width: 100,
                                )
                              : Container(
                                  decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(100),
                                      color: Palette().appBarColor),
                                  height: 100,
                                  width: 100,
                                  margin: EdgeInsets.all(10),
                                  padding: EdgeInsets.all(10),
                                ),
                          Icon(
                            Icons.add_a_photo_outlined,
                          ),
                        ],
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(
                        left: 50.0, right: 50.0, top: 12.0),
                    child: Form(
                      key: _formkey,
                      child: Column(
                        children: [
                          TextFormField(
                            onChanged: (val) {
                              _channelname = val;
                            },
                            validator: (val) => val!.length == 0
                                ? "Enter a channel name"
                                : null,
                            decoration: InputDecoration(
                              isDense: true,
                              border: OutlineInputBorder(),
                              hintText: "Channel Name",
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(top: 15.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        GestureDetector(
                          onTap: () {
                            if (_formkey.currentState!.validate()) {
                              ChatRoomsRepo()
                                  .createChatRoom(_channelname, _image);
                            }
                          },
                          child: Container(
                            padding: EdgeInsets.all(10),
                            decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(15),
                                color: Palette().appBarColor),
                            child: Text(
                              "Create",
                              style: TextStyle(
                                fontSize: 17,
                              ),
                            ),
                          ),
                        ),
                        GestureDetector(
                          onTap: () {
                            Navigator.pop(context);
                          },
                          child: Container(
                            padding: EdgeInsets.all(10),
                            decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(15),
                                color: Palette().appBarColor),
                            child: Text(
                              "Close",
                              style: TextStyle(
                                fontSize: 17,
                              ),
                            ),
                          ),
                        )
                      ],
                    ),
                  ),
                  SizedBox(
                    height: 30,
                  )
                ],
              ),
            );
          });
        });
  }

  Future<dynamic> _selectImage() async {
    final file = await picker.getImage(source: ImageSource.camera);
    var res = await file!.readAsBytes();
    print(base64.encode(res));
    if (res != List.empty()) {
      return res;
    } else {
      return null;
    }
  }
}
