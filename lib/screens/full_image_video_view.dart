import 'dart:io';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:open_file/open_file.dart';
import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:video_player/video_player.dart';

import 'package:whatsapp_clone/models/chat_model.dart';
import 'package:whatsapp_clone/models/user_model.dart';

import '../appConfig.dart';

class FullImageVideo extends StatefulWidget {
  final ChatModel chat;
  final UserModel user;

  const FullImageVideo({super.key, required this.chat, required this.user});

  @override
  State<FullImageVideo> createState() => _FullImageVideoState();
}

class _FullImageVideoState extends State<FullImageVideo> {
  VideoPlayerController? _controllerv;
  bool isPlaying = false;
  double _onProgress = 0.0;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    if (widget.chat.typeOfMessage!.split("+***+").first == "mp4") {
      _controllerv = VideoPlayerController.networkUrl(Uri.parse(
          '${AppConfig.baseUrl}/whatsapp_users/images/${widget.chat.message}'))
        ..initialize().then((_) {
          setState(() {});
        });
    }
  }

  Future<bool> requestStoragePermissionOnce() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();

    // Check if the permission has been granted before
    final bool hasPermission = prefs.getBool('storage_permission') ?? false;

    if (hasPermission) {
      // Permission has already been granted
      return true;
    } else {
      // Request storage permission
      final PermissionStatus storagePermissionStatus =
          await Permission.storage.status;
      if (!storagePermissionStatus.isGranted) {
        final PermissionStatus requestedStatus =
            await Permission.storage.request();
        if (requestedStatus.isGranted) {
          // Permission has been granted, set the flag in shared preferences
          prefs.setBool('storage_permission', true);
          return true;
        }
      }
      return false;
    }
  }

  String basename(String path) {
    List<String> parts = path.split(Platform.pathSeparator);
    return parts.isNotEmpty ? parts.last : path;
  }

  String basenameWithoutExtension(String path) {
    String fileName = basename(path); // Get the base file name
    int index =
        fileName.lastIndexOf('.'); // Find the last dot (.) in the file name
    if (index != -1) {
      // Remove the extension if it exists
      return fileName.substring(0, index);
    }
    return fileName; // No extension found
  }

  // String? downloadPath;
  void downloadFile(String url, String fileName) async {
    try {
      Dio dio = Dio();
      final Directory? tempDir = await getExternalStorageDirectory();

      // Sanitize the file name to remove special characters and spaces
      fileName = basenameWithoutExtension(fileName);
      fileName = fileName.replaceAll(RegExp(r'[^\w\s.]+'), '_');

      final filePath =
          "${tempDir!.path}/files/$fileName.${widget.chat.typeOfMessage!.split("+***+").first}";

      if (await Directory("${tempDir.path}/files").exists()) {
        // Directory already exists.
      } else {
        await Directory("${tempDir.path}/files").create(recursive: true);
      }

      await dio.download(
        url,
        filePath,
        onReceiveProgress: (count, total) {
          setState(() {
            _onProgress = count / total;
          });
        },
      );

      setState(() {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text("Downloading completed: $filePath")),
        );
        openDownloadedFile(filePath);
        _onProgress = 101.0;
      });
    } catch (e) {
      print("Error downloading file: $e");
    }
  }

  void openDownloadedFile(String filePath) {
    OpenFile.open(filePath);
  }

  // Future<String?> setname() async {

  void openfile(String fp) {
    OpenFile.open(fp);
    print("fff $fp");
  }

  @override
  void dispose() {
    // TODO: implement dispose
    _controllerv!.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.black54.withOpacity(0.2),
        iconTheme: IconThemeData(color: Colors.white),
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              widget.user.name!,
              style: TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.w500,
                  backgroundColor: Colors.black87,
                  fontSize: 20),
            ),
            Text(
              widget.chat.dateonly!,
              style: TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.w500,
                  backgroundColor: Colors.black87,
                  fontSize: 10),
            ),
          ],
        ),
      ),
      extendBodyBehindAppBar: true,
      backgroundColor: Color(0xFF190014),
      body: Stack(
        children: [
          Center(
            child: widget.chat.typeOfMessage!.split("+***+").first == 'mp4'
                ? // Initialize the variable to false

                GestureDetector(
                    onTap: () {
                      if (_controllerv != null) {
                        if (isPlaying) {
                          _controllerv!.pause();
                        } else {
                          _controllerv!.play();
                        }
                        setState(() {
                          isPlaying = !isPlaying; // Toggle the state
                        });
                      }
                    },
                    child: AspectRatio(
                      aspectRatio: _controllerv!.value.aspectRatio,
                      child: Stack(
                        alignment: Alignment.center,
                        children: [
                          VideoPlayer(_controllerv!),
                          Container(
                            height: 70,
                            width: 70,
                            decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(30),
                                color: Colors.black54),
                            child: Center(
                              child: Icon(
                                isPlaying ? Icons.pause : Icons.play_arrow,
                                color: Colors.white,
                                size: 30,
                              ),
                            ),
                          ),
                          Positioned(
                            bottom:
                                0, // Position the VideoProgressIndicator at the bottom of the video
                            left: 0,
                            right: 0,
                            child: Container(
                              width: double.infinity,
                              child: VideoProgressIndicator(_controllerv!,
                                  allowScrubbing: true),
                            ),
                          ),
                        ],
                      ),
                    ),
                  )
                : Image.network(
                    '${AppConfig.baseUrl}/whatsapp_users/images/${widget.chat.message}',
                    // width: MediaQuery.of(context).size.width * 0.4,
                    // height: MediaQuery.of(context).size.height * 0.3,
                    fit: BoxFit.cover,
                  ),
          ),
          Positioned(
            top: 100,
            right: 10,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                Padding(
                  padding: EdgeInsets.only(bottom: 8),
                  child: Container(
                    height: 70,
                    width: 70,
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(30),
                        color: Colors.black54),
                    child: Center(
                        child: IconButton(
                      onPressed: () {},
                      icon: Icon(
                        Icons.share,
                        color: Colors.white,
                        size: 30,
                      ),
                    )),
                  ),
                ),
                Container(
                  height: 70,
                  width: 70,
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(30),
                      color: Colors.black54),
                  child: Center(
                      child: IconButton(
                    onPressed: () async {
                      ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(content: Text("Downloading started")));

                      bool isPermissionGranted =
                          await requestStoragePermissionOnce();
                      if (isPermissionGranted) {
                        downloadFile(
                            '${AppConfig.baseUrl}/whatsapp_users/images/${widget.chat.message}',
                            widget.chat.message!);
                      } else {
                        ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(content: Text("Permission needed")));
                      }
                    },
                    icon: _onProgress > 0.0 && _onProgress <= 100
                        ? Stack(
                            alignment: Alignment.center,
                            children: [
                              CircularProgressIndicator(
                                value: _onProgress,
                              ),
                              Text(
                                '${(_onProgress * 100).toInt()}%',
                                style: TextStyle(
                                    fontSize: 10, color: Colors.white),
                              ),
                            ],
                          )
                        : Icon(
                            Icons.download,
                            color: Colors.white,
                            size: 30,
                          ),
                  )),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
