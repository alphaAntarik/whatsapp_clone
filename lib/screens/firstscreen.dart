import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:whatsapp_clone/bloc/user_bloc.dart';
import 'package:whatsapp_clone/screens/login_signup.dart';
import 'package:whatsapp_clone/screens/tabscreen.dart';

Future<String?> setname() async {
  final prefs = await SharedPreferences.getInstance();
  return prefs.getString("details");
}

class FirstScreen extends StatelessWidget {
  const FirstScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: FutureBuilder(
          future: setname(),
          builder: (context, snaphot) {
            if (snaphot.hasData) {
              if (snaphot.data!.isNotEmpty) {
                BlocProvider.of<UserBloc>(context)
                    .add(UserLoadedEvent(user: snaphot.data!));
                return TabScreen();
              } else {
                return LoginSignUp();
              }
            } else if (!snaphot.hasData) {
              return LoginSignUp();
            }
            return CircularProgressIndicator();
          }),
    );
  }
}
