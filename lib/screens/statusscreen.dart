import 'package:flutter/material.dart';

import 'package:shared_preferences/shared_preferences.dart';
import 'package:socket_io_client/socket_io_client.dart';
import 'package:whatsapp_clone/widgets/addstatus.dart';
import 'package:whatsapp_clone/widgets/camera_gallery.dart';
import 'package:whatsapp_clone/widgets/show_status_widget.dart';

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
      'type': 'text',
    };
    socket.emit('newStatus', message);
    _messageController.clear();
  }

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
                        isStatus: true,
                        isChat: false,
                        to: '',
                      ),
                      SizedBox(
                        width: MediaQuery.of(context).size.width * 0.05,
                      ),
                      Camera_Gallery(
                        icon: Icons.photo,
                        label: 'Gallery',
                        isStatus: true,
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

    // Organize and sort the data
    Map<String, List<StatusModel>> groupedData = {};

    for (StatusModel item in messages) {
      String firstLetter = item.name!.substring(0, 1).toLowerCase();
      groupedData[firstLetter] ??= [];
      groupedData[firstLetter]!.add(item);
    }

    // Sort the groups
    groupedData.forEach((key, value) {
      value.sort((a, b) => a.name!.compareTo(b.name!));
    });

    List<Widget> widgets = [];

    groupedData.forEach((key, value) {
      widgets.add(ListTile(
        title: Text(
          key.toUpperCase(),
          style: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
      ));

      final reversedValue = value.reversed.toList();

      widgets.addAll(reversedValue.map((status) => ListTile(
            title: SingleStatus(status: status),
          )));
    });
    return Stack(
      children: [
        // The ListView with status entries
        Positioned.fill(
          child: ListView(
            padding: EdgeInsets.only(top: 16),
            children: groupedData.entries.map((entry) {
              // final key = entry.key; // The first letter of the username
              final value =
                  entry.value; // List of StatusModel for this subgroup
              return GestureDetector(
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => ShowStatusWidget(
                        groupedData: entry,
                      ),
                    ),
                  );
                },
                child: Stack(
                  children: value
                      .map((status) => ListTile(
                            title: SingleStatus(status: status),
                          ))
                      .toList(),
                ),
              );
            }).toList(),
          ),
        ),

        // The button at the bottom right corner
        Positioned(
          bottom: 16, // Adjust the vertical position as needed
          right: 16, // Adjust the horizontal position as needed
          child: Column(
            children: [
              Container(
                decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(30)),
                child: IconButton(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => AddStatus(
                          controller: _messageController,
                          onPressedCallback: sendStatus,
                        ),
                      ),
                    );
                  },
                  icon: Icon(
                    Icons.edit,
                    size: 30,
                  ),
                ),
              ),
              Padding(
                padding: EdgeInsets.only(top: 10),
                child: Container(
                  decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(30)),
                  child: IconButton(
                    onPressed: () {
                      _showCredentialsBottomSheet();
                    },
                    icon: Icon(
                      Icons.camera_alt_outlined,
                      size: 30,
                    ),
                  ),
                ),
              ),
            ],
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
