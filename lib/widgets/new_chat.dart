import 'dart:io';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_file_downloader/flutter_file_downloader.dart';

import 'package:open_file/open_file.dart';
import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'package:url_launcher/url_launcher.dart';
import 'package:video_player/video_player.dart';

import 'package:whatsapp_clone/screens/full_image_video_view.dart';

import '../appConfig.dart';
import '../models/chat_model.dart';
import '../models/user_model.dart';

class NewChat extends StatefulWidget {
  const NewChat({super.key, required this.message, required this.user});

  final ChatModel message;
  final UserModel user;

  @override
  State<NewChat> createState() => _NewChatState();
}

class _NewChatState extends State<NewChat> {
  VideoPlayerController? _controllerv;
  double _onProgress = 0.0;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    if (widget.message.typeOfMessage!.split("+***+").first == "mp4") {
      _controllerv = VideoPlayerController.networkUrl(Uri.parse(
          '${AppConfig.baseUrl}/whatsapp_users/images/${widget.message.message}'))
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

  void openPdf(String pdfUrl) async {
    if (await canLaunch(pdfUrl)) {
      await launch(pdfUrl);
    } else {
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text("no app to open")));
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
      // Dio dio = Dio();
      final Directory? tempDir = await getExternalStorageDirectory();

      // Sanitize the file name to remove special characters and spaces
      fileName = basenameWithoutExtension(fileName);
      fileName = fileName.replaceAll(RegExp(r'[^\w\s.]+'), '_');

      final filePath =
          "${tempDir!.path}/files/$fileName.${widget.message.typeOfMessage!.split("+***+").first}";

      if (await Directory("${tempDir.path}/files").exists()) {
        // Directory already exists.
      } else {
        await Directory("${tempDir.path}/files").create(recursive: true);
      }

      FileDownloader.downloadFile(
          url: url,
          onProgress: (name, progress) {
            setState(() {
              _onProgress = progress;
            });
          },
          onDownloadCompleted: (value) {
            print('path  $value ');
            setState(() {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: Text("Downloading completed: $filePath")),
              );
              openDownloadedFile(filePath);
              _onProgress = 101.0;
            });
          });
      // await dio.download(
      //   url,
      //   filePath,
      //   onReceiveProgress: (count, total) {
      //     setState(() {
      //       _onProgress = count / total;
      //     });
      //   },
      // );

      // setState(() {
      //   ScaffoldMessenger.of(context).showSnackBar(
      //     SnackBar(content: Text("Downloading completed: $filePath")),
      //   );
      //   openDownloadedFile(filePath);
      //   _onProgress = 101.0;
      // });
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
  Widget build(BuildContext context) {
    return Container(
      //width: MediaQuery.of(context).size.width * 0.4,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(
            widget.message.typeOfMessage!.split("+***+").first == 'text'
                ? 20
                : 2),
        color: (Colors.grey.shade200),
      ),
      padding: EdgeInsets.all(
          widget.message.typeOfMessage!.split("+***+").first == 'text'
              ? 16
              : 2),
      child: ConstrainedBox(
        constraints: BoxConstraints(
          maxWidth: widget.message.typeOfMessage!
                      .split("+***+")
                      .first
                      .split("+***+")
                      .first ==
                  'text'
              ? MediaQuery.of(context).size.width * 0.5
              : MediaQuery.of(context).size.width * 0.6,
        ),
        child: Wrap(
          alignment: WrapAlignment
              .start, // Controls text alignment within the container
          runAlignment:
              WrapAlignment.start, // Controls text alignment in a new line
          direction: Axis.horizontal, // Text direction
          spacing: 8.0, // Spacing between items (adjust as needed)
          runSpacing: 8.0, // Spacing between lines
          children: <Widget>[
            if (widget.message.typeOfMessage!.split("+***+").first == 'text')
              Text(
                '${widget.message.message}',
                style: TextStyle(
                  color: Color(0xFF190014),
                ),
              ),
            if (widget.message.typeOfMessage!.split("+***+").first == 'png' ||
                widget.message.typeOfMessage!.split("+***+").first == 'jpg' ||
                widget.message.typeOfMessage!.split("+***+").first == 'jpeg')
              GestureDetector(
                onTap: () {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => FullImageVideo(
                          chat: widget.message,
                          user: widget.user,
                        ),
                      ));
                },
                child: Column(
                  children: [
                    Image.network(
                      '${AppConfig.baseUrl}/whatsapp_users/images/${widget.message.message}',
                      // width: MediaQuery.of(context).size.width * 0.4,
                      // height: MediaQuery.of(context).size.height * 0.3,
                      fit: BoxFit.cover,
                    ),
                    if (widget.message.typeOfMessage!.contains("+***+"))
                      Text(
                        widget.message.typeOfMessage!.split("+***+").last,
                        style: TextStyle(
                          color: Color(0xFF190014),
                        ),
                      ),
                  ],
                ),
              ),
            if (widget.message.typeOfMessage!.split("+***+").first == 'mp4')
              GestureDetector(
                onTap: () {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => FullImageVideo(
                          chat: widget.message,
                          user: widget.user,
                        ),
                      ));
                },
                child: Column(
                  children: [
                    Container(
                      height: MediaQuery.of(context).size.height * 0.3,
                      child: AspectRatio(
                        aspectRatio: _controllerv!.value.aspectRatio,
                        child: VideoPlayer(_controllerv!),
                      ),
                    ),
                    if (widget.message.typeOfMessage!.contains("+***+"))
                      Text(
                        widget.message.typeOfMessage!.split("+***+").last,
                        style: TextStyle(
                          color: Color(0xFF190014),
                        ),
                      ),
                  ],
                ),
              ),
            if (widget.message.typeOfMessage!.split("+***+").first == 'pdf' ||
                widget.message.typeOfMessage!.split("+***+").first == 'doc' ||
                widget.message.typeOfMessage!.split("+***+").first == 'docx' ||
                widget.message.typeOfMessage!.split("+***+").first == 'xls' ||
                widget.message.typeOfMessage!.split("+***+").first == 'xlsx' ||
                widget.message.typeOfMessage!.split("+***+").first == 'ppt' ||
                widget.message.typeOfMessage!.split("+***+").first == 'mp3' ||
                widget.message.typeOfMessage!.split("+***+").first == 'pptx' ||
                widget.message.typeOfMessage!.split("+***+").first == '*')
              GestureDetector(
                onTap: () async {
                  if (widget.message.typeOfMessage!.split("+***+").first ==
                      'pdf') {
                    openPdf(
                        '${AppConfig.baseUrl}/whatsapp_users/images/${widget.message.message}');
                  } else {
                    // bool _ispermission =
                    //     await AuthMethods().isPermissionGranted();
                    // if (!_ispermission) {
                    //   ScaffoldMessenger.of(context).showSnackBar(
                    //       SnackBar(content: Text("Permission needed")));
                    // } else {
                    // String getPath = await AuthMethods().getPath();
                    // // setState(() {
                    // filePath = '$getPath/${widget.message.message}';
                    // bool ifAlreadyDownloaded = await File(filePath).exists();
                    // // });
                    // setState(() {
                    //   fileExists = ifAlreadyDownloaded;
                    // });
                    // if (fileExists) {
                    //   openfile(filePath);
                    // } else {
                    //   startDownload(
                    //     widget.message.message!,
                    //     '${AppConfig.baseUrl}/whatsapp_users/images/${widget.message.message}',
                    //   );
                    // }

                    ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(content: Text("Downloading started")));

                    bool isPermissionGranted =
                        await requestStoragePermissionOnce();
                    if (isPermissionGranted) {
                      downloadFile(
                          '${AppConfig.baseUrl}/whatsapp_users/images/${widget.message.message}',
                          widget.message.message!);
                    } else {
                      ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(content: Text("Permission needed")));
                    }

                    //   openfile(downloadPath!);
                    // openPdf(
                    //     '${AppConfig.baseUrl}/whatsapp_users/images/${widget.message.message}');
                  }
                },
                child: Column(
                  children: [
                    Container(
                        height: MediaQuery.of(context).size.height * 0.1,
                        child: Container(
                          width: MediaQuery.of(context).size.width * 0.2,
                          height: MediaQuery.of(context).size.height * 0.1,
                          color: Color(0xFF190014),
                          child: Center(
                            child: _onProgress > 0.0 &&
                                    _onProgress <= 100 &&
                                    widget.message.typeOfMessage!
                                            .split("+***+")
                                            .first !=
                                        'pdf'
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
                                : Text(
                                    ".${widget.message.typeOfMessage!.split("+***+").first}",
                                    maxLines: 2,
                                    overflow: TextOverflow.ellipsis,
                                    style: TextStyle(
                                        color: Colors.white, fontSize: 20),
                                  ),
                          ),
                        )),
                    if (widget.message.typeOfMessage!.contains("+***+"))
                      Text(
                        widget.message.typeOfMessage!.split("+***+").last,
                        style: TextStyle(
                          color: Color(0xFF190014),
                        ),
                      ),
                  ],
                ),
              ),
          ],
          //runAlignment: WrapAlignment.start,
          textDirection: TextDirection.ltr, // Change as needed
          //  maxWidth: MediaQuery.of(context).size.width * 0.5, // Max width before wrapping
        ),
      ),
    );
  }
}
