import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:whatsapp_clone/appConfig.dart';

import 'package:whatsapp_clone/screens/tabscreen.dart';

import '../auth methods/authentication.dart';

import '../widgets/adddp.dart';

class SettingsScreen extends StatefulWidget {
  static String sesttingsscreenroute = '/sesttingsscreenroute';
  const SettingsScreen({super.key});

  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  Future<String?> setname() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString("id");
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: Icon(
            Icons.arrow_back,
            color: Colors.white,
          ),
          onPressed: () {
            Navigator.of(context)
                .pushReplacementNamed(TabScreen.tabscreenRoute);
          },
        ),
        title: Text(
          'User Details',
          style: TextStyle(color: Colors.white),
        ),
        backgroundColor: Color(0xFF190014),
      ),
      backgroundColor: Color(0xFF190014),
      body: Center(
          child: FutureBuilder(
              future: setname(),
              builder: (context, snapshot) {
                if (snapshot.hasData) {
                  return FutureBuilder(
                    future: AuthMethods().getUserById(snapshot.data!),
                    builder: (context, snap) {
                      if (snap.hasData) {
                        if (snap.data!.profileImage != "") {
                          return Column(
                            children: [
                              Stack(
                                children: [
                                  Container(
                                    width: 120,
                                    height: 120,
                                    decoration: BoxDecoration(
                                      shape: BoxShape.circle,
                                      border: Border.all(
                                        color: Colors.grey, // Border color
                                        width: 1, // Border width
                                      ),
                                    ),
                                    child: ClipOval(
                                      child: Image.network(
                                        '${AppConfig.baseUrl}/whatsapp_users/images/${snap.data!.profileImage}',
                                        width: 120,
                                        height: 120,
                                        fit: BoxFit.cover,
                                      ),
                                    ),
                                  ),
                                  AddDP(),
                                ],
                              ),
                              SizedBox(height: 16.0),
                              Text(
                                snap.data!.name!,
                                style: TextStyle(
                                    fontSize: 20.0, color: Colors.white),
                              ),
                              SizedBox(
                                  height: MediaQuery.of(context).size.height *
                                      0.02),
                              Container(
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(
                                      16), // Defines a circular shape
                                  color: Color.fromARGB(255, 52, 0,
                                      39), // Customize the background color
                                ),
                                width: MediaQuery.of(context).size.width * 0.8,
                                height:
                                    MediaQuery.of(context).size.height * 0.3,
                                child: Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: Column(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceEvenly,
                                    crossAxisAlignment:
                                        CrossAxisAlignment.center,
                                    children: [
                                      Column(
                                        mainAxisAlignment:
                                            MainAxisAlignment.end,
                                        children: [
                                          Container(
                                            width: MediaQuery.of(context)
                                                    .size
                                                    .width *
                                                0.8,
                                            height: MediaQuery.of(context)
                                                    .size
                                                    .height *
                                                0.05,
                                            child: Text(
                                              "Contact details",
                                              style: TextStyle(
                                                color: Colors.white,
                                                fontSize: MediaQuery.of(context)
                                                        .size
                                                        .height *
                                                    0.04,
                                              ),
                                              textAlign: TextAlign.center,
                                            ),
                                          ),
                                          Divider(
                                            color: Colors.grey,
                                          ),
                                        ],
                                      ),
                                      Container(
                                        width:
                                            MediaQuery.of(context).size.width *
                                                0.9,
                                        child: Text(
                                          "email: ${snap.data!.email}",
                                          style: TextStyle(
                                            fontSize: 20.0,
                                            color: Colors.white,
                                          ),
                                          textAlign: TextAlign.left,
                                          maxLines: 1,
                                          overflow: TextOverflow.ellipsis,
                                          softWrap: true,
                                        ),
                                      ),
                                      SizedBox(
                                        height:
                                            MediaQuery.of(context).size.height *
                                                0.05,
                                        child: Container(
                                          width: MediaQuery.of(context)
                                                  .size
                                                  .width *
                                              0.9,
                                          child: Text(
                                            "phone number: ${snap.data!.phonenumber}",
                                            style: TextStyle(
                                              fontSize: 20.0,
                                              color: Colors.white,
                                            ),
                                            textAlign: TextAlign.left,
                                            maxLines: 1,
                                            overflow: TextOverflow.ellipsis,
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ],
                          );
                        } else {
                          return Column(
                            children: [
                              Stack(
                                children: [
                                  CircleAvatar(
                                    radius: 60.0,
                                    backgroundColor: Colors.grey,
                                    child: Icon(
                                      Icons.person,
                                      color: Color(0xFF190014),
                                      size: 100,
                                    ),
                                  ),
                                  AddDP(),
                                ],
                              ),
                              SizedBox(height: 16.0),
                              Text(
                                snap.data!.name!,
                                style: TextStyle(
                                    fontSize: 20.0, color: Colors.white),
                              ),
                              SizedBox(
                                  height: MediaQuery.of(context).size.height *
                                      0.02),
                              Container(
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(
                                      16), // Defines a circular shape
                                  color: Color.fromARGB(255, 52, 0,
                                      39), // Customize the background color
                                ),
                                width: MediaQuery.of(context).size.width * 0.8,
                                height:
                                    MediaQuery.of(context).size.height * 0.3,
                                child: Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: Column(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceEvenly,
                                    crossAxisAlignment:
                                        CrossAxisAlignment.center,
                                    children: [
                                      Column(
                                        mainAxisAlignment:
                                            MainAxisAlignment.end,
                                        children: [
                                          Container(
                                            width: MediaQuery.of(context)
                                                    .size
                                                    .width *
                                                0.8,
                                            height: MediaQuery.of(context)
                                                    .size
                                                    .height *
                                                0.05,
                                            child: Text(
                                              "Contact details",
                                              style: TextStyle(
                                                color: Colors.white,
                                                fontSize: MediaQuery.of(context)
                                                        .size
                                                        .height *
                                                    0.04,
                                              ),
                                              textAlign: TextAlign.center,
                                            ),
                                          ),
                                          Divider(
                                            color: Colors.grey,
                                          ),
                                        ],
                                      ),
                                      Container(
                                        width:
                                            MediaQuery.of(context).size.width *
                                                0.9,
                                        child: Text(
                                          "email: ${snap.data!.email}",
                                          style: TextStyle(
                                            fontSize: 20.0,
                                            color: Colors.white,
                                          ),
                                          textAlign: TextAlign.left,
                                          maxLines: 1,
                                          overflow: TextOverflow.ellipsis,
                                          softWrap: true,
                                        ),
                                      ),
                                      SizedBox(
                                        height:
                                            MediaQuery.of(context).size.height *
                                                0.05,
                                        child: Container(
                                          width: MediaQuery.of(context)
                                                  .size
                                                  .width *
                                              0.9,
                                          child: Text(
                                            "phone number: ${snap.data!.phonenumber}",
                                            style: TextStyle(
                                              fontSize: 20.0,
                                              color: Colors.white,
                                            ),
                                            textAlign: TextAlign.left,
                                            maxLines: 1,
                                            overflow: TextOverflow.ellipsis,
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ],
                          );
                        }
                      }
                      return CircularProgressIndicator();
                    },
                  );
                }
                return Container();
              })),
    );
  }
}
