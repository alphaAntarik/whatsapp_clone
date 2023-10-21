import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:whatsapp_clone/appConfig.dart';
import 'package:whatsapp_clone/auth%20methods/authentication.dart';
import 'package:whatsapp_clone/models/chat_model.dart';
import 'package:whatsapp_clone/models/user_model.dart';
import 'package:whatsapp_clone/widgets/camera_gallery.dart';

import '../auth methods/chat_service.dart';
import '../widgets/new_chat.dart';
import 'package:socket_io_client/socket_io_client.dart';
// class ChatScreen extends StatefulWidget {
//   final UserModel usermodel;

//   const ChatScreen({super.key, required this.usermodel});
// //  static String chatroomroute = "/chatroomroute";
//   @override
//   _ChatScreenState createState() => _ChatScreenState();
// }

// class _ChatScreenState extends State<ChatScreen> {
//   final TextEditingController _messageController = TextEditingController();
//   final List<ChatModel> _messages = [];
//   final ChatService _chatService = ChatService();

//   @override
//   void initState() {
//     super.initState();
//     _chatService.init(onMessageReceived);
//   }

//   void onMessageReceived(ChatModel message) {
//     setState(() {
//       _messages.add(message);
//     });

//     _scrollController.animateTo(
//       MediaQuery.of(context).size.height,
//       duration: Duration(milliseconds: 300),
//       curve: Curves.easeOut,
//     );
//   }

//   void _sendMessage() {
//     final message = _messageController.text;
//     if (message.isNotEmpty) {
//       _chatService.sendMessage(message);
//       _messageController.clear();
//     }
//   }

//   final ScrollController _scrollController = ScrollController();
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       resizeToAvoidBottomInset: false,
//       appBar: AppBar(
//         leading: const BackButton(
//           color: Colors.white,
//         ),
//         title: Text(
//           '${widget.usermodel.name}',
//           style: TextStyle(color: Colors.white),
//         ),
//         backgroundColor: Color(0xFF190014),
//       ),
//       backgroundColor: Color(0xFF190014),
//       body: Column(
//         children: <Widget>[
//           Expanded(
//             child: SingleChildScrollView(
//               controller: _scrollController,
//               child: ListView.builder(
//                 shrinkWrap: true,
//                 physics: NeverScrollableScrollPhysics(),

//                 reverse: false, // Start at the bottom
//                 itemCount: _messages.length,
//                 itemBuilder: (context, index) {
//                   final message = _messages[index];
//                   return ListTile(
//                     title: NewChat(
//                       message: message,
//                     ),
//                   );
//                 },
//               ),
//             ),
//           ),

//           Stack(
//             children: <Widget>[
//               Align(
//                 alignment: Alignment.bottomLeft,
//                 child: Container(
//                   padding: EdgeInsets.only(left: 10, bottom: 10, top: 10),
//                   height: 60,
//                   width: double.infinity,
//                   color: Color(0xFF190014),
//                   child: Row(
//                     children: <Widget>[
//                       GestureDetector(
//                         onTap: () {},
//                         child: Container(
//                           height: 30,
//                           width: 30,
//                           decoration: BoxDecoration(
//                             color: Colors.lightBlue,
//                             borderRadius: BorderRadius.circular(30),
//                           ),
//                           child: Icon(
//                             Icons.add,
//                             color: Colors.white,
//                             size: 20,
//                           ),
//                         ),
//                       ),
//                       SizedBox(
//                         width: 15,
//                       ),
//                       Expanded(
//                         child: TextFormField(
//                           onFieldSubmitted: (_) => _sendMessage(),
//                           style: TextStyle(color: Colors.white),
//                           controller: _messageController,
//                           onTap: () {
//                             setState(() {
//                               _scrollController.animateTo(
//                                 MediaQuery.of(context).size.height,
//                                 duration: Duration(milliseconds: 300),
//                                 curve: Curves.easeOut,
//                               );
//                             });
//                           },
//                           decoration: InputDecoration(
//                               fillColor: Colors.white,
//                               focusedBorder: OutlineInputBorder(
//                                 borderSide: const BorderSide(
//                                     color: Colors.white, width: 2.0),
//                                 borderRadius: BorderRadius.circular(6.0),
//                               ),
//                               hintText: "Write message...",
//                               hintStyle: TextStyle(color: Colors.white),
//                               border: InputBorder.none),
//                         ),
//                       ),
//                       SizedBox(
//                         width: 15,
//                       ),
//                       FloatingActionButton(
//                         onPressed: _sendMessage,
//                         child: Icon(
//                           Icons.send,
//                           color: Colors.white,
//                           size: 18,
//                         ),
//                         backgroundColor: Colors.blue,
//                         elevation: 0,
//                       ),
//                     ],
//                   ),
//                 ),
//               ),
//             ],
//           ),

//           // Padding(
//           //   padding: const EdgeInsets.all(8.0),
//           //   child: Row(
//           //     children: <Widget>[
//           //       Expanded(
//           //         child: TextField(
//           //           controller: _messageController,
//           //           decoration: InputDecoration(labelText: 'Message'),
//           //         ),
//           //       ),
//           //       IconButton(
//           //         icon: Icon(Icons.send),
//           //         onPressed: _sendMessage,
//           //       ),
//           //     ],
//           //   ),
//           // ),
//           // SizedBox(height: MediaQuery.of(context).viewInsets.bottom + 20),
//           Padding(
//               padding: EdgeInsets.only(
//                   bottom: MediaQuery.of(context).viewInsets.bottom))
//         ],
//       ),
//     );
//   }
// }

class ChatScreen extends StatefulWidget {
  final UserModel usermodel;
  final String? senderId;
  // final Function(String) sendmessage;

  const ChatScreen({
    super.key,
    required this.usermodel,
    required this.senderId,
    //  required this.sendmessage,
  });
  @override
  _ChatScreenState createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  // Adjust to your server's URL
  final socket = io('${AppConfig.baseUrl}/chat', <String, dynamic>{
    'transports': ['websocket'],
  });

  TextEditingController messageController = TextEditingController();
  //final ScrollController _scrollController = ScrollController();

  List<ChatModel> chats = [];
  // void lastmessage(String message, String id, String userid) async {
  //   final s = await AuthMethods().updatelast(id, message, userid);
  //   print(s);
  // }

  @override
  void initState() {
    super.initState();
    socket.connect();

    // Join the chat room and fetch old chats
    socket.emit("joinChatRoom", {
      "sender": widget.senderId,
      "receiver": widget.usermodel.id,
    });
    socket.on('oldChats', (data) {
      setState(() {
        for (var singleChat in data) {
          ChatModel chat = ChatModel(
            from: singleChat["from"],
            to: singleChat["to"],
            message: singleChat["message"],
            dateonly: singleChat["dateonly"],
            timestamp: singleChat["timestamp"],
            typeOfMessage: singleChat["typeOfMessage"],
            id: singleChat["_id"],
          );

          chats.add(chat);
        }
      });
    });

    // Listen for new chat messages
    socket.on('newChatMessage', (data1) {
      final data = data1 as Map<String, dynamic>;
      _handleNewStatus(data);
      // setState(() {
      //   chats.add(ChatModel(
      //     from: data["from"],
      //     to: data["to"],
      //     message: data["message"],
      //     dateonly: data["dateonly"],
      //     timestamp: data["timestamp"],
      //     typeOfMessage: data["typeOfMessage"],
      //     id: data["_id"],
      //   ));
      // });
    });
  }

  void _handleNewStatus(Map<String, dynamic> data) {
    setState(() {
      final newStatus = ChatModel.fromJson(data);
      chats.add(newStatus); // Add new status at the beginning
    });
  }

  void sendChatMessage() async {
    final message = messageController.text;
    final prefs = await SharedPreferences.getInstance();
    // final details = prefs.getString("id");
    prefs.setString("to", widget.usermodel.id!);
    DateTime now = DateTime.now();
    String formattedDate = DateFormat('yyyy-MM-dd').format(now);

    if (message.isNotEmpty) {
      socket.emit('newChatMessage', {
        "from": widget.senderId,
        "to": widget.usermodel.id,
        "message": message,
        "dateonly": formattedDate,
        'timestamp': DateTime.now().toString(),
        "typeOfMessage": "text",
      });
      // await AuthMethods()
      //     .updatelast(widget.senderId!, message, widget.senderId!);

      messageController.clear();
    }
  }

  @override
  Widget build(BuildContext context) {
    void _showCredentialsBottomSheet(UserModel usermodel) {
      showModalBottomSheet(
        backgroundColor: Color(0xFF27001F),
        context: context,
        builder: (BuildContext context) {
          return Container(
            height: MediaQuery.of(context).size.height * 0.3,
            child: Column(
              children: [
                Padding(
                    padding: EdgeInsets.only(
                      top: 25,
                    ),
                    child: Text("Choose any",
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 20,

                          // height: 0,
                        ))),
                Divider(
                  thickness: 2,
                  color: Colors.grey,
                ),
                Container(
                  height: MediaQuery.of(context).size.height * 0.2,
                  width: MediaQuery.of(context).size.width * 0.9,
                  child: Column(
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          Camera_Gallery(
                            icon: Icons.camera,
                            label: 'Camera',
                            isStatus: false,
                            isChat: true,
                            to: usermodel.id!,
                          ),
                          // SizedBox(
                          //   width: MediaQuery.of(context).size.width * 0.05,
                          // ),
                          Camera_Gallery(
                            icon: Icons.photo,
                            label: 'Gallery',
                            isStatus: false,
                            isChat: true,
                            to: usermodel.id!,
                          ),
                          //  SizedBox(
                          //   width: MediaQuery.of(context).size.width * 0.05,
                          // ),
                          Camera_Gallery(
                            icon: Icons.video_camera_back,
                            label: 'Capture Video',
                            isStatus: false,
                            isChat: true,
                            to: usermodel.id!,
                          ),
                        ],
                      ),
                      // SizedBox(
                      //   height: MediaQuery.of(context).size.height * 0.1,
                      // ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          Camera_Gallery(
                            icon: Icons.video_camera_back,
                            label: 'Video',
                            isStatus: false,
                            isChat: true,
                            to: usermodel.id!,
                          ),
                          Camera_Gallery(
                            icon: Icons.note_add,
                            label: 'Documents',
                            isStatus: false,
                            isChat: true,
                            to: usermodel.id!,
                          ),
                          Camera_Gallery(
                            icon: Icons.picture_as_pdf,
                            label: 'Pdf',
                            isStatus: false,
                            isChat: true,
                            to: usermodel.id!,
                          ),
                        ],
                      ),
                    ],
                  ),
                )
              ],
            ),
          );
        },
      );
    }

    return Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: AppBar(
        leading: const BackButton(
          color: Colors.white,
        ),
        title: Text(
          '${widget.usermodel.name}',
          style: TextStyle(color: Colors.white),
        ),
        backgroundColor: Color(0xFF190014),
      ),
      backgroundColor: Color(0xFF190014),
      body: Stack(
        children: [
          if (widget.usermodel.profileImage != "")
            Opacity(
              opacity: 0.3,
              child: Image.network(
                '${AppConfig.baseUrl}/whatsapp_users/images/${widget.usermodel.profileImage}',
                width: MediaQuery.of(context).size.width,
                height: MediaQuery.of(context).size.height,
                fit: BoxFit.cover,
              ),
            ),
          Column(
            children: [
              Expanded(
                child: ListView.builder(
                  // controller: _scrollController,
                  itemCount: chats.length,
                  itemBuilder: (context, index) {
                    final chat = chats[index];

                    return ListTile(
                      title: Align(
                        alignment: widget.senderId == chat.from
                            ? Alignment.centerRight
                            : Alignment.centerLeft,
                        child: NewChat(
                          message: chat,
                          user: widget.usermodel,
                        ),
                      ),
                    );
                  },
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Row(
                  children: [
                    IconButton(
                      icon: Icon(
                        Icons.add,
                        color: Colors.white,
                      ),
                      onPressed: () {
                        _showCredentialsBottomSheet(widget.usermodel);
                      },
                    ),
                    Expanded(
                      child: TextFormField(
                        style: TextStyle(color: Colors.white),
//                           controller: _messageController,
//                           onTap: () {
//                             setState(() {
//                               _scrollController.animateTo(
//                                 MediaQuery.of(context).size.height,
//                                 duration: Duration(milliseconds: 300),
//                                 curve: Curves.easeOut,
//                               );
//                             });
//                           },
                        decoration: InputDecoration(
                            fillColor: Colors.white,
                            focusedBorder: OutlineInputBorder(
                              borderSide: const BorderSide(
                                  color: Colors.white, width: 2.0),
                              borderRadius: BorderRadius.circular(6.0),
                            ),
                            hintText: "Write message...",
                            hintStyle: TextStyle(color: Colors.white),
                            border: InputBorder.none),

                        controller: messageController,
                        // decoration: InputDecoration(labelText: 'Message'),
                      ),
                    ),
                    IconButton(
                      icon: Icon(
                        Icons.send,
                        color: Colors.white,
                      ),
                      onPressed: sendChatMessage,
                    ),
                  ],
                ),
              ),
              Padding(
                  padding: EdgeInsets.only(
                      bottom: MediaQuery.of(context).viewInsets.bottom))
            ],
          ),
        ],
      ),
    );
  }

  @override
  void dispose() {
    socket.dispose();
    super.dispose();
  }
}
