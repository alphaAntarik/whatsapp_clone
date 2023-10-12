import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:image_picker/image_picker.dart';
import 'package:whatsapp_clone/screens/show_image_screen.dart';

class Camera_Gallery extends StatefulWidget {
  final IconData icon;
  final String label;
  Camera_Gallery({super.key, required this.icon, required this.label});

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
                builder: (context) => ShowImage(imagefile: _image)));
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
                builder: (context) => ShowImage(imagefile: _image)));
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        if (widget.label == "Camera") {
          getImageFromCamera();
        } else {
          getImageFromGallery();
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
