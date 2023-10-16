// import 'dart:convert';

// import 'package:intl/intl.dart';
// import 'package:shared_preferences/shared_preferences.dart';
// import 'package:socket_io_client/socket_io_client.dart' as io;
// import 'package:whatsapp_clone/models/chat_model.dart';

// class ChatService {
//   static ChatService? _instance;
//   late io.Socket socket;
//   Function(ChatModel)? onMessageReceived;

//   ChatService._() {
//     socket =
//         io.io('https://21a2-103-51-148-103.ngrok-free.app/', <String, dynamic>{
//       'transports': ['websocket'],
//       'autoConnect': false,
//     });

//     socket.connect();
//     socket.on('chat message', (data) {
//       final message = ChatModel(
//           from: data["from"],
//           message: data["message"],
//           to: data["to"],
//           dateonly: data['dateonly'],
//           timestamp: data['timestamp'],
//           typeOfMessage: data['typeOfMessage'],
//           id: data["id"]);
//       onMessageReceived!(message);
//     });
//   }

//   factory ChatService() {
//     if (_instance == null) {
//       _instance = ChatService._();
//     }
//     return _instance!;
//   }

//   void init(Function(ChatModel) messageHandler) {
//     onMessageReceived = messageHandler;
//   }

//   void sendMessage(String message) async {
//     final prefs = await SharedPreferences.getInstance();
//     final details = prefs.getString("details");
//     final to = prefs.getString("to");
//     DateTime now = DateTime.now();
//     String formattedDate = DateFormat('yyyy-MM-dd').format(now);
//     String formattedTime = DateFormat('HH:mm:ss').format(now);
//     socket.emit(
//         'chat message',
//         jsonEncode(<String, String>{
//           "from": details!.split("+").last,
//           "to": to!,
//           "message": message,
//           "dateonly": formattedDate,
//           "timestamp": formattedTime,
//           "typeOfMessage": "text",
//         }));
//   }
// }
