import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:whatsapp_clone/screens/firstscreen.dart';
import 'package:whatsapp_clone/screens/login_signup.dart';
import 'package:whatsapp_clone/screens/settings_screen.dart';
import 'package:whatsapp_clone/screens/tabscreen.dart';

import 'bloc/user_bloc.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  MyApp({super.key});
  // String? name;

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => UserBloc(),
      child: MaterialApp(
        title: 'Flutter Demo',
        theme: ThemeData(
          textTheme: TextTheme(
              // displayLarge: const TextStyle(
              //   fontSize: 72,
              //   fontWeight: FontWeight.bold,
              // ),
              // // ···
              // titleLarge: GoogleFonts.oswald(
              //   fontSize: 30,
              //   //  fontStyle: FontStyle.italic,
              // ),
              // bodyMedium: GoogleFonts.merriweather(),
              // displaySmall: GoogleFonts.pacifico(),
              ),
          colorScheme: ColorScheme.fromSeed(
              seedColor: Color(0xFF190014),

              // inversePrimary: Color(0xFF190014),
              primary: Colors.white),
          useMaterial3: true,
        ),
        initialRoute: '/',
        routes: {
          '/': (context) => FirstScreen(),
          LoginSignUp.loginSignupRoute: (context) => LoginSignUp(),
          TabScreen.tabscreenRoute: (context) => TabScreen(),
          SettingsScreen.sesttingsscreenroute: (context) => SettingsScreen()
        },
      ),
    );
  }
}
