import 'package:flutter/material.dart';

import 'package:whatsapp_clone/screens/firstscreen.dart';

import 'package:whatsapp_clone/screens/login_signup.dart';
import 'package:whatsapp_clone/screens/settings_screen.dart';
import 'package:whatsapp_clone/screens/tabscreen.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  MyApp({super.key});
  // String? name;

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        textTheme: TextTheme(),
        colorScheme: ColorScheme.fromSeed(
            seedColor: Color(0xFF190014),

            // inversePrimary: Color(0xFF190014),
            primary: Colors.white),
        useMaterial3: true,
      ),
      initialRoute: '/',
      routes: {
        '/': (context) => FirstScreen(),
        //  ChatScreen.chatroomroute: (context) => ChatScreen(),
        LoginSignUp.loginSignupRoute: (context) => LoginSignUp(),
        TabScreen.tabscreenRoute: (context) => TabScreen(),
        SettingsScreen.sesttingsscreenroute: (context) => SettingsScreen()
      },
    );
  }
}
