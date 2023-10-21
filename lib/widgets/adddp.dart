import 'package:flutter/material.dart';
import 'package:whatsapp_clone/widgets/camera_gallery.dart';

void _showCredentialsBottomSheet(BuildContext context) {
  showModalBottomSheet(
    backgroundColor: Color(0xFF27001F),
    context: context,
    builder: (BuildContext context) {
      return Container(
        height: MediaQuery.of(context).size.height * 0.25,
        child: Column(
          children: [
            Padding(
                padding: EdgeInsets.only(
                  top: 25,
                ),
                child: Text("Choose any",
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 20,

                      // height: 0,
                    ))),
            Divider(
              thickness: 2,
              color: Colors.grey,
            ),
            Container(
              height: MediaQuery.of(context).size.height * 0.15,
              width: MediaQuery.of(context).size.width * 0.9,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Camera_Gallery(
                    icon: Icons.camera,
                    label: 'Camera',
                    isStatus: false,
                    isChat: false,
                    to: '',
                  ),
                  SizedBox(
                    width: MediaQuery.of(context).size.width * 0.05,
                  ),
                  Camera_Gallery(
                    icon: Icons.photo,
                    label: 'Gallery',
                    isStatus: false,
                    isChat: false,
                    to: '',
                  ),
                ],
              ),
            )
          ],
        ),
      );
    },
  );
}

class AddDP extends StatelessWidget {
  const AddDP({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    void _showCredentialsBottomSheet() {
      showModalBottomSheet(
        backgroundColor: Color(0xFF27001F),
        context: context,
        builder: (BuildContext context) {
          return Container(
            height: MediaQuery.of(context).size.height * 0.25,
            child: Column(
              children: [
                Padding(
                    padding: EdgeInsets.only(
                      top: 25,
                    ),
                    child: Text("Choose any",
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 20,

                          // height: 0,
                        ))),
                Divider(
                  thickness: 2,
                  color: Colors.grey,
                ),
                Container(
                  height: MediaQuery.of(context).size.height * 0.15,
                  width: MediaQuery.of(context).size.width * 0.9,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      Camera_Gallery(
                        icon: Icons.camera,
                        label: 'Camera',
                        isStatus: false,
                        isChat: false,
                        to: '',
                      ),
                      SizedBox(
                        width: MediaQuery.of(context).size.width * 0.05,
                      ),
                      Camera_Gallery(
                        icon: Icons.photo,
                        label: 'Gallery',
                        isStatus: false,
                        isChat: false,
                        to: '',
                      ),
                    ],
                  ),
                )
              ],
            ),
          );
        },
      );
    }

    return Positioned(
      bottom: 0,
      right: 0,
      child: InkWell(
        onTap: () {
          _showCredentialsBottomSheet();
        },
        child: CircleAvatar(
          backgroundColor: Colors.amberAccent,
          radius: 18.0,
          child: Icon(
            Icons.camera_alt_outlined,
            color: Color(0xFF190014),
          ),
        ),
      ),
    );
  }
}
