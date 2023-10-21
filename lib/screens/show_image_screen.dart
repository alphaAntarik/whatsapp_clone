import 'dart:io';

import 'package:flutter/material.dart';

import 'package:image_cropper/image_cropper.dart';
import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:socket_io_client/socket_io_client.dart';
import 'package:video_player/video_player.dart';
import 'package:whatsapp_clone/appConfig.dart';
import 'package:whatsapp_clone/auth%20methods/authentication.dart';

import 'package:whatsapp_clone/models/user_model.dart';
import 'package:whatsapp_clone/screens/settings_screen.dart';
import 'package:whatsapp_clone/screens/tabscreen.dart';

class ShowImage extends StatefulWidget {
  final File? imagefile;
  final bool isStatus;
  final bool isChat;
  final String to;
  ShowImage(
      {super.key,
      required this.imagefile,
      required this.isStatus,
      required this.isChat,
      required this.to});

  @override
  State<ShowImage> createState() => _ShowImageState();
}

class _ShowImageState extends State<ShowImage> {
  TextEditingController controller = TextEditingController();
  VideoPlayerController? _controllerv;

  Socket? socket;
  // io('${AppConfig.baseUrl}/status', <String, dynamic>{
  //   'transports': ['websocket'],
  // });
  // final socket1 = io('${AppConfig.baseUrl}/chat', <String, dynamic>{
  //   'transports': ['websocket'],
  // });
  @override
  void initState() {
    // TODO: implement initState

    if (widget.imagefile!.path.split(".").last == "mp4") {
      _controllerv = VideoPlayerController.file(widget.imagefile!)
        ..initialize().then((_) {
          setState(() {});
        });
    }
    socket = widget.isChat
        ? io('${AppConfig.baseUrl}/chat', <String, dynamic>{
            'transports': ['websocket'],
          })
        : io('${AppConfig.baseUrl}/status', <String, dynamic>{
            'transports': ['websocket'],
          });
  }

  void sendStatus(File? imgfile, String caption) async {
    final prefs = await SharedPreferences.getInstance();
    final details = prefs.getString("id");
    final name = prefs.getString("name");
    final message = {
      'user_id': details,
      'name': name,
      'status': await AuthMethods().uploadPhoto(imgfile),
      'dateonly': DateTime.now().toLocal().toString(),
      'timestamp': DateTime.now().toString(),
      'type': caption,
    };
    socket!.emit('newStatus', message);
    ScaffoldMessenger.of(context)
        .showSnackBar(SnackBar(content: Text("status uploaded")));
    Navigator.pushReplacementNamed(context, TabScreen.tabscreenRoute);
  }

  void sendChatMessage(File? imgfile, String caption) async {
    //  final message = messageController.text;
    final prefs = await SharedPreferences.getInstance();
    // final details = prefs.getString("id");
    final details = prefs.getString("id");
    DateTime now = DateTime.now();
    String formattedDate = DateFormat('yyyy-MM-dd').format(now);

    socket!.emit('newChatMessage', {
      "from": details,
      "to": widget.to,
      "message": await AuthMethods().uploadPhoto(imgfile),
      "dateonly": formattedDate,
      'timestamp': DateTime.now().toString(),
      "typeOfMessage": '${imgfile!.path.split(".").last}+***+$caption',
    });
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("sent")));
    Navigator.pop(context);
    // await AuthMethods()
    //     .updatelast(widget.senderId!, message, widget.senderId!);
  }

  Future<String?> setname() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString("id");
  }

  File? img;

  Future _cropImage(File? imagefile) async {
    if (imagefile != null) {
      CroppedFile? cropped = await ImageCropper()
          .cropImage(sourcePath: imagefile.path, aspectRatioPresets: [
        CropAspectRatioPreset.square,
        CropAspectRatioPreset.ratio3x2,
        CropAspectRatioPreset.original,
        CropAspectRatioPreset.ratio4x3,
        CropAspectRatioPreset.ratio16x9
      ], uiSettings: [
        AndroidUiSettings(
            toolbarTitle: 'Crop',
            cropGridColor: Colors.black,
            initAspectRatio: CropAspectRatioPreset.original,
            lockAspectRatio: false),
        IOSUiSettings(title: 'Crop')
      ]);

      if (cropped != null) {
        setState(() {
          img = File(cropped.path);
        });
      }
    }
  }

  @override
  void dispose() {
    // TODO: implement dispose
    _controllerv!.dispose();
    controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    void photo_uploaded(
      File? image,
      String id,
    ) async {
      if (widget.isStatus) {
        sendStatus(image, controller.text);
      } else if (widget.isChat) {
        sendChatMessage(image, controller.text);
      } else {
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
                  child: SingleChildScrollView(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        ClipRRect(
                          borderRadius: BorderRadius.circular(20.0),
                          child: widget.imagefile!.path.split(".").last ==
                                      "mp4" &&
                                  widget.isChat
                              ? Stack(
                                  children: [
                                    GestureDetector(
                                      onTap: () {
                                        if (_controllerv != null) {
                                          if (_controllerv!.value.isPlaying) {
                                            _controllerv!.pause();
                                          } else {
                                            _controllerv!.play();
                                          }
                                        }
                                      },
                                      child: Container(
                                        height:
                                            MediaQuery.of(context).size.height *
                                                0.4,
                                        child: AspectRatio(
                                          aspectRatio:
                                              _controllerv!.value.aspectRatio,
                                          child: VideoPlayer(_controllerv!),
                                        ),
                                      ),
                                    ),
                                  ],
                                )
                              : widget.imagefile!.path.split(".").last ==
                                          'pdf' ||
                                      widget.imagefile!.path.split(".").last ==
                                          'doc' ||
                                      widget.imagefile!.path.split(".").last ==
                                          'docx' ||
                                      widget.imagefile!.path.split(".").last ==
                                          'xls' ||
                                      widget.imagefile!.path.split(".").last ==
                                          'xlsx' ||
                                      widget.imagefile!.path.split(".").last ==
                                          'ppt' ||
                                      widget.imagefile!.path.split(".").last ==
                                          'mp3' ||
                                      widget.imagefile!.path.split(".").last ==
                                          'pptx' ||
                                      widget.imagefile!.path.split(".").last ==
                                          '*'
                                  ? Text(
                                      ".${widget.imagefile!.path.split(".").last}",
                                      maxLines: 2,
                                      overflow: TextOverflow.ellipsis,
                                      style: TextStyle(
                                          color: Colors.white, fontSize: 20),
                                    )
                                  : Image.file(
                                      img == null ? widget.imagefile! : img!,
                                      width: 300,
                                      height: 300,
                                      fit: BoxFit.cover,
                                    ),
                        ),
                        if (!widget.isChat || !widget.isStatus)
                          SizedBox(
                            height: MediaQuery.of(context).size.height * 0.1,
                            width: MediaQuery.of(context).size.width * 0.8,
                            child: TextFormField(
                              expands: true,
                              maxLines: null,
                              decoration: InputDecoration(
                                  hintText: 'caption',
                                  hintStyle: TextStyle(color: Colors.grey)),
                              style: TextStyle(
                                color: Colors.white,
                              ),
                              controller: controller,
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
                              if (widget.imagefile!.path
                                          .split(".")
                                          .last ==
                                      "png" ||
                                  widget.imagefile!.path.split(".").last ==
                                      "jpg" ||
                                  widget.imagefile!.path.split(".").last ==
                                      "jpeg")
                                IconButton(
                                    onPressed: () {
                                      _cropImage(widget.imagefile);
                                    },
                                    icon: Icon(
                                      Icons.crop,
                                      size: 30,
                                      color: Colors.white,
                                    )),
                              IconButton(
                                  onPressed: () {
                                    img == null
                                        ? photo_uploaded(
                                            widget.imagefile, snapshot.data!)
                                        : photo_uploaded(img, snapshot.data!);
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
                  ),
                );
              }
              return CircularProgressIndicator();
            }));
  }
}
