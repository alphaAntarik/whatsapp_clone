import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:whatsapp_clone/screens/tabscreen.dart';

import '../auth methods/authentication.dart';
import '../bloc/user_bloc.dart';
import '../widgets/adddp.dart';

class SettingsScreen extends StatelessWidget {
  static String sesttingsscreenroute = '/sesttingsscreenroute';
  const SettingsScreen({super.key});

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
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: <Widget>[
            SizedBox(
              height: 40,
            ),
            BlocBuilder<UserBloc, UserState>(builder: (context, state) {
              if (state is UserLoadedState) {
                return state.details.split("+")[4] != "null"
                    ? Stack(
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
                                child: FutureBuilder(
                                    future: AuthMethods().getUserById(
                                        state.details.split("+").last),
                                    builder: (context, snap) {
                                      if (snap.hasData) {
                                        BlocProvider.of<UserBloc>(context).add(
                                            UserLoadedEvent(
                                                user:
                                                    "${snap.data!.name}+${snap.data!.email}+${snap.data!.phonenumber}+${snap.data!.profileImage}+${snap.data!.id}"));
                                        return Image.network(
                                          'https://9dc3-103-101-213-67.ngrok-free.app/whatsapp_users/images/${snap.data!.profileImage}',
                                          width: 120,
                                          height: 120,
                                          fit: BoxFit.cover,
                                        );
                                      } else if (snap.connectionState ==
                                          ConnectionState.waiting) {
                                        return CircularProgressIndicator();
                                      } else if (snap.hasError) {
                                        return Text(
                                          "error",
                                          style: TextStyle(color: Colors.white),
                                        );
                                      }
                                      return CircleAvatar(
                                          radius: 60.0,
                                          backgroundColor: Colors.grey,
                                          child: Icon(
                                            Icons.person,
                                            color: Color(0xFF190014),
                                            size: 100,
                                          ));
                                    })
                                // Image.network(
                                //   'https://9dc3-103-101-213-67.ngrok-free.app/whatsapp_users/images/${state.details.split("+")[4]}',
                                //   width: 120,
                                //   height: 120,
                                //   fit: BoxFit.cover,
                                // ),
                                ),
                          ),
                          AddDP(),
                        ],
                      )
                    : Stack(
                        children: [
                          CircleAvatar(
                              radius: 60.0,
                              backgroundColor: Colors.grey,
                              child: Icon(
                                Icons.person,
                                color: Color(0xFF190014),
                                size: 100,
                              )),
                          AddDP()
                        ],
                      );
              }
              return CircleAvatar(
                  radius: 60.0,
                  backgroundColor: Colors.white,
                  child: Icon(
                    Icons.person,
                    color: Color(0xFF190014),
                  ));
            }),
            SizedBox(height: 16.0),
            BlocBuilder<UserBloc, UserState>(
              builder: (context, state) {
                if (state is UserLoadedState) {
                  return Text(
                    state.details.split("+")[0],
                    style: TextStyle(fontSize: 20.0, color: Colors.white),
                  );
                }
                return Text(
                  "userName",
                  style: TextStyle(fontSize: 20.0, color: Colors.white),
                );
              },
            ),
            SizedBox(height: MediaQuery.of(context).size.height * 0.02),
            Container(
              decoration: BoxDecoration(
                borderRadius:
                    BorderRadius.circular(16), // Defines a circular shape
                color: Color.fromARGB(
                    255, 52, 0, 39), // Customize the background color
              ),
              width: MediaQuery.of(context).size.width * 0.8,
              height: MediaQuery.of(context).size.height * 0.3,
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Column(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        Container(
                          // color: Colors.black,
                          width: MediaQuery.of(context).size.width * 0.8,
                          height: MediaQuery.of(context).size.height * 0.05,
                          child: Text(
                            "Contact details",
                            style: TextStyle(
                                color: Colors.white,
                                fontSize:
                                    MediaQuery.of(context).size.height * 0.04),
                            textAlign: TextAlign.center,
                          ),
                        ),
                        Divider(
                          color: Colors.grey,
                        ),
                      ],
                    ),

                    BlocBuilder<UserBloc, UserState>(
                      builder: (context, state) {
                        if (state is UserLoadedState) {
                          return Container(
                            width: MediaQuery.of(context).size.width * 0.9,
                            child: Text(
                              "email: ${state.details.split("+")[1]}",
                              style: TextStyle(
                                  fontSize: 20.0, color: Colors.white),
                              textAlign: TextAlign.left,
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                              softWrap: true,
                            ),
                          );
                        }
                        return Text(
                          "userEmail",
                          style: TextStyle(
                            fontSize: 20.0,
                            color: Colors.white,
                          ),
                          textAlign: TextAlign.left,
                        );
                      },
                    ),
                    // SizedBox(height: 8.0),
                    SizedBox(
                      height: MediaQuery.of(context).size.height * 0.05,
                      child: BlocBuilder<UserBloc, UserState>(
                        builder: (context, state) {
                          if (state is UserLoadedState) {
                            return Container(
                              width: MediaQuery.of(context).size.width * 0.9,
                              child: Text(
                                "phone number: ${state.details.split("+")[3]}",
                                style: TextStyle(
                                    fontSize: 20.0, color: Colors.white),
                                textAlign: TextAlign.left,
                              ),
                            );
                          }
                          return Text(
                            "phone number",
                            style: TextStyle(
                              fontSize: 20.0,
                              color: Colors.white,
                            ),
                            textAlign: TextAlign.left,
                          );
                        },
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
