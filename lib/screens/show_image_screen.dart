import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:whatsapp_clone/auth%20methods/authentication.dart';

import 'package:whatsapp_clone/models/user_model.dart';
import 'package:whatsapp_clone/screens/settings_screen.dart';

class ShowImage extends StatefulWidget {
  final File? imagefile;
  ShowImage({super.key, required this.imagefile});

  @override
  State<ShowImage> createState() => _ShowImageState();
}

class _ShowImageState extends State<ShowImage> {
  Future<String?> setname() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString("id");
  }

  @override
  Widget build(BuildContext context) {
    void photo_uploaded(
      File? image,
      String id,
    ) async {
      UserModel user = await AuthMethods().updatePhoto(id, image);

      if (user.id != "") {
        ScaffoldMessenger.of(context)
            .showSnackBar(SnackBar(content: Text("uploaded")));
        Navigator.pushReplacementNamed(
            context, SettingsScreen.sesttingsscreenroute);
      } else {
        ScaffoldMessenger.of(context)
            .showSnackBar(SnackBar(content: Text("Failed to upload")));
      }
    }

    return Scaffold(
        appBar: AppBar(
          iconTheme: IconThemeData(color: Colors.white),
          backgroundColor: Color(0xFF190014),
        ),
        // extendBodyBehindAppBar: true,
        backgroundColor: Color(0xFF190014),
        body: FutureBuilder(
            future: setname(),
            builder: (context, snapshot) {
              if (snapshot.hasData) {
                return Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      ClipRRect(
                        borderRadius: BorderRadius.circular(20.0),
                        child: Image.file(
                          widget.imagefile!,
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
                            IconButton(
                                onPressed: () {
                                  photo_uploaded(
                                      widget.imagefile, snapshot.data!);
                                },
                                icon: Icon(
                                  Icons.check,
                                  size: 30,
                                  color: Colors.white,
                                ))
                          ],
                        ),
                      )
                    ],
                  ),
                );
              }
              return CircularProgressIndicator();
            }));
  }
}
