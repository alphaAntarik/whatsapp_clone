import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:whatsapp_clone/auth%20methods/authentication.dart';
import 'package:whatsapp_clone/bloc/user_bloc.dart';
import 'package:whatsapp_clone/models/user_model.dart';
import 'package:whatsapp_clone/screens/settings_screen.dart';

class ShowImage extends StatelessWidget {
  final File? imagefile;
  ShowImage({super.key, required this.imagefile});

  @override
  Widget build(BuildContext context) {
    void photo_uploaded(
      File? image,
      String id,
    ) async {
      UserModel user = await AuthMethods().updatePhoto(id, image);
      BlocProvider.of<UserBloc>(context).add(UserLoadedEvent(
          user:
              "${user.name}+${user.email}+${user.phonenumber}+${user.profileImage}+${user.id}"));
      final prefs = await SharedPreferences.getInstance();
      prefs.setString("details",
          "${user.name}+${user.email}+${user.phonenumber}+${user.profileImage}+${user.id}");

      Navigator.pushReplacementNamed(
          context, SettingsScreen.sesttingsscreenroute);
    }

    return Scaffold(
      appBar: AppBar(
        iconTheme: IconThemeData(color: Colors.white),
        backgroundColor: Color(0xFF190014),
      ),
      // extendBodyBehindAppBar: true,
      backgroundColor: Color(0xFF190014),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            ClipRRect(
              borderRadius: BorderRadius.circular(20.0),
              child: Image.file(
                imagefile!,
                width: 300,
                height: 300,
                fit: BoxFit.cover,
              ),
            ),
            SizedBox(
              height: MediaQuery.of(context).size.height * 0.2,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  IconButton(
                      onPressed: () {
                        Navigator.pop(context);
                      },
                      icon: Icon(
                        Icons.close,
                        size: 30,
                        color: Colors.white,
                      )),
                  BlocBuilder<UserBloc, UserState>(builder: (context, state) {
                    if (state is UserLoadedState) {
                      return IconButton(
                          onPressed: () {
                            photo_uploaded(
                                imagefile, state.details.split("+").last);
                          },
                          icon: Icon(
                            Icons.check,
                            size: 30,
                            color: Colors.white,
                          ));
                    } else {
                      return CircularProgressIndicator();
                    }
                  })
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}
