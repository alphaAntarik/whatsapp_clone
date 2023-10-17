import 'package:flutter/material.dart';

class AddStatus extends StatelessWidget {
  final TextEditingController controller;
  final Function onPressedCallback;
  const AddStatus(
      {super.key, required this.controller, required this.onPressedCallback});

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text('Enter Text'),
      content: TextField(
        decoration: InputDecoration(
          labelText: 'write your thoughts',
          labelStyle: TextStyle(color: Colors.black),
        ),
        controller: controller,
      ),
      actions: [
        TextButton(
          onPressed: () {
            onPressedCallback();
            Navigator.of(context).pop(); // Close the dialog
          },
          child: Text('OK'),
        ),
      ],
    );
  }
}
