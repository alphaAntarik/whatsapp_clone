import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../bloc/user_bloc.dart';

class SettingsScreen extends StatelessWidget {
  static String sesttingsscreenroute = '/sesttingsscreenroute';
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('User Details'),
        backgroundColor: Color(0xFF190014),
      ),
      backgroundColor: Color(0xFF190014),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            BlocBuilder<UserBloc, UserState>(
              builder: (context, state) {
                if (state is UserLoadedState) {
                  return CircleAvatar(
                    radius: 60.0,
                    child: Text(state.details.split("+")[3]),
                  );
                }
                return CircleAvatar(
                    radius: 60.0,
                    backgroundColor: Colors.white,
                    child: Icon(Icons.person, color: Color(0xFF190014)));
              },
            ),
            SizedBox(height: 16.0),
            BlocBuilder<UserBloc, UserState>(
              builder: (context, state) {
                if (state is UserLoadedState) {
                  return Text(
                    state.details.split("+")[1],
                    style: TextStyle(
                      fontSize: 24.0,
                      fontWeight: FontWeight.bold,
                    ),
                  );
                }
                return Text(
                  "userName",
                  style: TextStyle(
                    fontSize: 24.0,
                    fontWeight: FontWeight.bold,
                  ),
                );
              },
            ),
            SizedBox(height: 8.0),
            BlocBuilder<UserBloc, UserState>(
              builder: (context, state) {
                if (state is UserLoadedState) {
                  return Text(
                    state.details.split("+")[0],
                    style: TextStyle(
                      fontSize: 16.0,
                    ),
                  );
                }
                return Text(
                  "userEmail",
                  style: TextStyle(
                    fontSize: 16.0,
                  ),
                );
              },
            ),
            SizedBox(height: 8.0),
            BlocBuilder<UserBloc, UserState>(
              builder: (context, state) {
                if (state is UserLoadedState) {
                  return Text(
                    state.details.split("+")[2],
                    style: TextStyle(
                      fontSize: 16.0,
                    ),
                  );
                }
                return Text(
                  "userPhoneNumber",
                  style: TextStyle(
                    fontSize: 16.0,
                  ),
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}
