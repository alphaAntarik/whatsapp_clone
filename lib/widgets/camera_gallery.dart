import 'dart:io';

import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:image_picker/image_picker.dart';
import 'package:whatsapp_clone/screens/show_image_screen.dart';

class Camera_Gallery extends StatefulWidget {
  final IconData icon;
  final String label;
  final isStatus;
  final bool isChat;
  final String to;
  Camera_Gallery(
      {super.key,
      required this.icon,
      required this.label,
      required this.isStatus,
      required this.isChat,
      required this.to});

  @override
  State<Camera_Gallery> createState() => _Camera_GalleryState();
}

class _Camera_GalleryState extends State<Camera_Gallery> {
  File? _image;
  final picker = ImagePicker();

  //Image Picker function to get image from gallery
  Future getImageFromGallery() async {
    final pickedFile = await picker.pickImage(source: ImageSource.gallery);

    setState(() {
      if (pickedFile != null) {
        _image = File(pickedFile.path);
        Navigator.push(
            context,
            MaterialPageRoute(
                builder: (context) => ShowImage(
                      imagefile: _image,
                      isStatus: widget.isStatus,
                      isChat: widget.isChat,
                      to: widget.to,
                    )));
      }
    });
  }

  Future getVideoFromGallery() async {
    final pickedFile = await FilePicker.platform.pickFiles(
      type: FileType.video,
    );

    setState(() {
      if (pickedFile != null) {
        _image = File(pickedFile.files.single.path!);
        Navigator.push(
            context,
            MaterialPageRoute(
                builder: (context) => ShowImage(
                      imagefile: _image,
                      isStatus: widget.isStatus,
                      isChat: widget.isChat,
                      to: widget.to,
                    )));
      }
    });
  }

  //Image Picker function to get image from camera
  Future getImageFromCamera() async {
    final pickedFile = await picker.pickImage(source: ImageSource.camera);

    setState(() {
      if (pickedFile != null) {
        _image = File(pickedFile.path);
        Navigator.push(
            context,
            MaterialPageRoute(
                builder: (context) => ShowImage(
                      imagefile: _image,
                      isStatus: widget.isStatus,
                      isChat: widget.isChat,
                      to: widget.to,
                    )));
      }
    });
  }

  Future getVideoFromCamera() async {
    final pickedFile = await picker.pickVideo(source: ImageSource.camera);

    setState(() {
      if (pickedFile != null) {
        _image = File(pickedFile.path);
        Navigator.push(
            context,
            MaterialPageRoute(
                builder: (context) => ShowImage(
                      imagefile: _image,
                      isStatus: widget.isStatus,
                      isChat: widget.isChat,
                      to: widget.to,
                    )));
      }
    });
  }

  Future getPdf() async {
    final pickedFile = await FilePicker.platform.pickFiles(
      type: FileType.custom,
      allowedExtensions: ['pdf'],
    );

    setState(() {
      if (pickedFile != null) {
        _image = File(pickedFile.files.single.path!);
        Navigator.push(
            context,
            MaterialPageRoute(
                builder: (context) => ShowImage(
                      imagefile: _image,
                      isStatus: widget.isStatus,
                      isChat: widget.isChat,
                      to: widget.to,
                    )));
      }
    });
  }

  Future getDocs() async {
    final pickedFile = await FilePicker.platform.pickFiles(
      type: FileType.custom,
      allowedExtensions: [
        'pdf',
        'doc',
        'docx',
        'xls',
        'xlsx',
        'ppt',
        'mp3',
        'pptx',
        '*',
        'mp4',
        'jpg',
        'jpeg',
        'png'
      ],
    );

    setState(() {
      if (pickedFile != null) {
        _image = File(pickedFile.files.single.path!);
        Navigator.push(
            context,
            MaterialPageRoute(
                builder: (context) => ShowImage(
                      imagefile: _image,
                      isStatus: widget.isStatus,
                      isChat: widget.isChat,
                      to: widget.to,
                    )));
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        if (widget.label == "Camera") {
          getImageFromCamera();
        } else if (widget.label == "Gallery") {
          getImageFromGallery();
        } else if (widget.label == "Video") {
          getVideoFromGallery();
        } else if (widget.label == 'Capture Video') {
          getVideoFromCamera();
        } else if (widget.label == 'Pdf') {
          getPdf();
        } else if (widget.label == 'Documents') {
          getDocs();
        }
      },
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            widget.icon,
            color: Colors.white,
            size: MediaQuery.of(context).size.height * 0.07,
          ),
          Text(
            widget.label,
            style: TextStyle(color: Colors.white),
          ),
        ],
      ),
    );
  }
}
