import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:whatsapp_clone/models/user_model.dart';

import '../appConfig.dart';
import '../screens/individual_chat_screen.dart';

class ConversationList extends StatefulWidget {
  final UserModel user;
  ConversationList({required this.user});
  @override
  _ConversationListState createState() => _ConversationListState();
}

class _ConversationListState extends State<ConversationList> {
//   Future<String?> setname() async {
//   final prefs = await SharedPreferences.getInstance();
//   return prefs.getString("id");
// }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () async {
        final prefs = await SharedPreferences.getInstance();
        final String? senderId;
        // setState(() {

        senderId = prefs.getString("id");
        // });
        Navigator.push(
            context,
            MaterialPageRoute(
                builder: (context) => ChatScreen(
                      usermodel: widget.user,
                      senderId: senderId,
                    )));
      },
      child: Container(
        padding: EdgeInsets.only(left: 16, right: 16, top: 5, bottom: 5),
        child: Row(
          children: <Widget>[
            Expanded(
              child: Row(
                children: <Widget>[
                  CircleAvatar(
                    child: widget.user.profileImage != ""
                        ? ClipOval(
                            child: Image.network(
                              '${AppConfig.baseUrl}/whatsapp_users/images/${widget.user.profileImage!}',
                              fit: BoxFit.cover,
                              width: 60,
                              height: 60,
                            ),
                          )
                        : Icon(
                            Icons.person,
                            color: Colors.white,
                          ),
                    maxRadius: 30,
                  ),
                  SizedBox(
                    width: 16,
                  ),
                  Expanded(
                    child: Container(
                      color: Colors.transparent,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          Text(
                            widget.user.name!,
                            style: TextStyle(fontSize: 16, color: Colors.white),
                          ),
                          SizedBox(
                            height: 6,
                          ),
                          // Text(
                          //   widget.user.lastmessage ?? "",
                          //   style: TextStyle(
                          //     fontSize: 13,
                          //     color: Colors.grey.shade600,
                          //     // fontWeight: widget.isMessageRead
                          //     //     ? FontWeight.bold
                          //     //     : FontWeight.normal
                          //   ),
                          // ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
            // Text(
            //   widget.time,
            //   style: TextStyle(
            //       fontSize: 12,
            //       fontWeight: widget.isMessageRead
            //           ? FontWeight.bold
            //           : FontWeight.normal),
            // ),
          ],
        ),
      ),
    );
  }
}
