// import 'dart:convert';

// import '../models/chat_model.dart';
// import 'package:http/http.dart' as http;

// class GetOldChats {
//   Future<List<ChatModel>> getOldChats(String from, String to) async {
//     final http.Response response = await http.post(
//       Uri.parse(
//           'https://21a2-103-51-148-103.ngrok-free.app/whatsapp_chats/getchats'),
//       headers: <String, String>{
//         'Content-Type': 'application/json; charset=UTF-8',
//       },
//       body: jsonEncode(<String, String>{
//         'from': from,
//         'to': to,
//       }),
//     );

//     if (response.statusCode == 200) {
//       var responseData = json.decode(response.body);
//       List<ChatModel> chats = [];
//       for (var singleChat in responseData) {
//         ChatModel chat = ChatModel(
//           id: singleChat["_id"],
//           from: singleChat["from"],
//           to: singleChat["to"],
//           message: singleChat["message"],
//           dateonly: singleChat["dateonly"],
//           timeonly: singleChat["timeonly"],
//           typeOfMessage: singleChat["typeOfMessage"],
//         );

//         //Adding user to the list.
//         chats.add(chat);
//       }
//       return chats;
//     } else {
//       throw Exception('Failed to fetch chats.');
//     }
//   }
// }
