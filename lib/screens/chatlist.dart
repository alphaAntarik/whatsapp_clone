import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'package:whatsapp_clone/auth%20methods/authentication.dart';

import 'package:whatsapp_clone/widgets/conversation_widget.dart';

class ChatListScreen extends StatefulWidget {
  const ChatListScreen({super.key});

  @override
  State<ChatListScreen> createState() => _ChatListScreenState();
}

class _ChatListScreenState extends State<ChatListScreen> {
  String? id = "";
  void setname() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      id = prefs.getString("id");
    });
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    setname();
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
        future: AuthMethods().getAllUsers(id!),
        builder: (context, snapshot) {
          if (snapshot.hasError) {
            return Text("${snapshot.error}");
          } else if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(
                child: Text(
              "Loading...",
              style: TextStyle(color: Colors.white),
            ));
          } else if (snapshot.hasData) {
            return ListView.builder(
                // shrinkWrap: true,
                padding: EdgeInsets.only(top: 16),
                //  physics: NeverScrollableScrollPhysics(),
                itemCount: snapshot.data!.length,
                itemBuilder: (context, index) {
                  return ConversationList(
                    user: snapshot.data![index],
                  );
                });
          }
          return Center(
              child: Text(
            "error occured",
            style: TextStyle(color: Colors.white),
          ));
        });
  }
}
