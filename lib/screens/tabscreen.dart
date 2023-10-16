import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'package:whatsapp_clone/auth%20methods/authentication.dart';
import 'package:whatsapp_clone/screens/callingscreen.dart';
import 'package:whatsapp_clone/screens/chatlist.dart';
import 'package:whatsapp_clone/screens/login_signup.dart';
import 'package:whatsapp_clone/screens/settings_screen.dart';
import 'package:whatsapp_clone/screens/statusscreen.dart';

Future<String?> setname() async {
  final prefs = await SharedPreferences.getInstance();
  return prefs.getString("id");
}

class TabScreen extends StatefulWidget {
  static String tabscreenRoute = '/tabscreenroute';
  TabScreen({
    super.key,
  });

  @override
  State<TabScreen> createState() => _TabScreenState();
}

class _TabScreenState extends State<TabScreen> {
  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
        future: setname(),
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            return DefaultTabController(
              length: 3,
              child: Scaffold(
                  appBar: AppBar(
                    automaticallyImplyLeading: false,
                    iconTheme: IconThemeData(
                      color: Colors.white,
                    ),
                    actions: [
                      IconButton(
                        onPressed: () {},
                        icon: Icon(Icons.search),
                      ),
                      PopupMenuButton<String>(
                        offset: Offset(0, 48),
                        onSelected: (value) {
                          // Handle the selected menu item here
                          if (value == 'Option 1') {
                            // Perform action for Option 1
                          } else if (value == 'Option 2') {
                            // Perform action for Option 2
                          }
                        },
                        itemBuilder: (BuildContext context) {
                          return <PopupMenuEntry<String>>[
                            // Define the menu items
                            PopupMenuItem<String>(
                              value: 'Settings',
                              child: Text('Settings'),
                              onTap: () {
                                Navigator.pushReplacementNamed(context,
                                    SettingsScreen.sesttingsscreenroute);
                              },
                            ),
                            PopupMenuItem<String>(
                                value: 'Logout',
                                child: Text('Logout'),
                                onTap: () async {
                                  // final result =
                                  //     await AuthMethods().loginOut();

                                  // if (result == "Success") {
                                  final prefs =
                                      await SharedPreferences.getInstance();
                                  setState(() {
                                    prefs.setString("id", "");
                                    prefs.setString("to", "");
                                  });

                                  // BlocProvider.of<UserBloc>(context)
                                  //     .add(UserLoadedEvent(
                                  //         user:
                                  //             "null+null+null+null+null"));
                                  Navigator.pushReplacementNamed(
                                      context, LoginSignUp.loginSignupRoute);
                                }
                                //  else {
                                //   ScaffoldMessenger.of(context)
                                //       .showSnackBar(SnackBar(
                                //           content: Text(
                                //               "Something went wrong")));
                                // }

                                ),
                          ];
                        },
                      ),
                    ],
                    elevation: 0,
                    backgroundColor: Color(0xFF190014),
                    title: Text(
                      "Let's Talk",
                      style: TextStyle(
                          color: Colors.white, fontWeight: FontWeight.w500),
                    ),
                    bottom: TabBar(
                      tabs: [
                        Tab(
                          text: 'chats',
                        ),
                        Tab(text: 'status'),
                        Tab(text: 'calls'),
                      ],
                    ),
                  ),
                  backgroundColor: Color(0xFF190014),
                  body: TabBarView(
                    children: [
                      ChatListScreen(),
                      StatusScreen(),
                      CallingScreen(),
                    ],
                  )),
            );
          }
          return CircularProgressIndicator();
        });
  }
}
