import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../models/chat_model.dart';
import '../models/user_model.dart';

class NewChat extends StatelessWidget {
  const NewChat({super.key, required this.message, required this.user});

  final ChatModel message;
  final UserModel user;

  // Future<String?> setname() async {
  //   final prefs = await SharedPreferences.getInstance();
  //   return prefs.getString("id");
  // }

  @override
  Widget build(BuildContext context) {
    return Container(
      //width: MediaQuery.of(context).size.width * 0.4,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(20),
        color: (Colors.grey.shade200),
      ),
      padding: EdgeInsets.all(16),
      child: ConstrainedBox(
        constraints: BoxConstraints(
          maxWidth: MediaQuery.of(context).size.width * 0.5,
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
            Text(
              '${message.message}',
              style: TextStyle(
                color: Color(0xFF190014),
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
