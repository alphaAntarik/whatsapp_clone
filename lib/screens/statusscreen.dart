import 'package:flutter/material.dart';

import 'package:shared_preferences/shared_preferences.dart';
import 'package:socket_io_client/socket_io_client.dart';
import 'package:whatsapp_clone/widgets/addstatus.dart';

import '../appConfig.dart';
import '../models/status_model.dart';
import '../widgets/single_status_widget.dart';

class StatusScreen extends StatefulWidget {
  const StatusScreen({super.key});

  @override
  State<StatusScreen> createState() => _StatusScreenState();
}

class _StatusScreenState extends State<StatusScreen> {
  final TextEditingController _messageController = TextEditingController();
  List<StatusModel> messages = [];

  final socket = io('${AppConfig.baseUrl}/status', <String, dynamic>{
    'transports': ['websocket'],
  });

  @override
  void initState() {
    super.initState();

    socket.emit("previousStatus");
    socket.on('oldStatus', (status) {
      setState(() {
        messages = (status as List)
            .map((message) => StatusModel.fromJson(message))
            .toList();
      });
    });

    socket.on('newStatus', (message) {
      final data = message as Map<String, dynamic>;
      _handleNewStatus(data);
    });
  }

  void _handleNewStatus(Map<String, dynamic> data) {
    setState(() {
      final newStatus = StatusModel.fromJson(data);
      messages.insert(0, newStatus); // Add new status at the beginning
    });
  }

  void sendStatus() async {
    final prefs = await SharedPreferences.getInstance();
    final details = prefs.getString("id");
    final name = prefs.getString("name");
    final message = {
      'user_id': details,
      'name': name,
      'status': _messageController.text,
      'dateonly': DateTime.now().toLocal().toString(),
      'timestamp': DateTime.now().toString(),
    };
    socket.emit('newStatus', message);
    _messageController.clear();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        IconButton(
            onPressed: () {
              Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => AddStatus(
                            controller: _messageController,
                            onPressedCallback: sendStatus,
                          )));
            },
            icon: Icon(
              Icons.add,
              size: 40,
            )),
        // Padding(
        //   padding: const EdgeInsets.all(8.0),
        //   child: Row(
        //     children: [
        //       Expanded(
        //         child: TextField(
        //           controller: _messageController,
        //           decoration: InputDecoration(labelText: 'Enter a status'),
        //         ),
        //       ),
        //       ElevatedButton(
        //         onPressed: sendStatus,
        //         child: Text('Send'),
        //       ),
        //     ],
        //   ),
        // ),
        Expanded(
          child: ListView.builder(
            itemCount: messages.length,
            itemBuilder: (context, index) {
              final status = messages[index];
              return SingleStatus(status: status)
                  // ListTile(
                  //   title: Text(status.status ?? ""),
                  //   subtitle: Text(status.dateonly ?? ""),
                  // )

                  ;
            },
          ),
        ),
      ],
    );
  }

  @override
  void dispose() {
    socket.disconnect();
    super.dispose();
  }
}
