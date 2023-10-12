import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'package:whatsapp_clone/auth%20methods/authentication.dart';
import 'package:whatsapp_clone/screens/login_signup.dart';
import 'package:whatsapp_clone/screens/settings_screen.dart';

import '../bloc/user_bloc.dart';

Future<String> setdetails(String details) async {
  final prefs = await SharedPreferences.getInstance();
  prefs.setString("details", details);
  return details;
  // prefs.setString("name", user.name ?? "");
  // prefs.setString(
  //     "phonenumber", user.phonenumber ?? "");
  // prefs.setString(
  //     "profileImage", user.profileImage!);
}

class TabScreen extends StatelessWidget {
  static String tabscreenRoute = '/tabscreenroute';
  TabScreen({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<UserBloc, UserState>(
      builder: (context, state) {
        if (state is UserLoadedState) {
          if (state.details != "null+null+null+null+null") {
            return FutureBuilder(
                future: setdetails(state.details),
                builder: (context, snapshot1) {
                  if (snapshot1.hasData) {
                    return Scaffold(
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
                                      final result =
                                          await AuthMethods().loginOut();

                                      if (result == "Success") {
                                        final prefs = await SharedPreferences
                                            .getInstance();
                                        prefs.setString("details", "");
                                        Navigator.pushReplacementNamed(context,
                                            LoginSignUp.loginSignupRoute);
                                      } else {
                                        ScaffoldMessenger.of(context)
                                            .showSnackBar(SnackBar(
                                                content: Text(
                                                    "Something went wrong")));
                                      }
                                    },
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
                                color: Colors.white,
                                fontWeight: FontWeight.w500),
                          ),
                        ),
                        backgroundColor: Color(0xFF190014),
                        body: Column(
                          children: [
                            // Text(
                            //           "",
                            //             style: TextStyle(color: Colors.white),
                            //           )

                            // Text(name!.split("+")[1]),
                            // Text(name!.split("+")[2]),
                            // TextButton(
                            //     onPressed: () {
                            //       Navigator.pushReplacement(context,
                            //           MaterialPageRoute(builder: (context) => LoginSignUp()));
                            //     },
                            //     child: Text("Logout"))
                          ],
                        ));
                  }
                  return CircularProgressIndicator();
                });
          }
        }
        return CircularProgressIndicator();
      },
    );
  }
}
