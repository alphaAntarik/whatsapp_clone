import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';

import '../models/user_model.dart';

class AuthMethods {
  Future<UserModel> createAlbum(
      String email, String password, String name, String phonenumber) async {
    final http.Response response = await http.post(
      Uri.parse(
          'https://8871-103-101-213-67.ngrok-free.app/whatsapp_users/signup'),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: jsonEncode(<String, String>{
        'email': email,
        'name': name,
        'password': password,
        'phonenumber': phonenumber
      }),
    );

    if (response.statusCode == 200) {
      return UserModel.fromJson(json.decode(response.body));
    } else {
      throw Exception('Failed to create album.');
    }
  }

  Future<UserModel> loginWithPhone(
    String phonenumber,
    String password,
  ) async {
    final http.Response response = await http.post(
      Uri.parse(
          'https://8871-103-101-213-67.ngrok-free.app/whatsapp_users/loginPhoneNumber'),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: jsonEncode(<String, String>{
        // 'email': email,
        // 'name': name,
        'phonenumber': phonenumber,
        'password': password,
      }),
    );

    if (response.statusCode == 200) {
      return UserModel.fromJson(json.decode(response.body));
    } else {
      throw Exception('Failed to create album.');
    }
  }

  Future<UserModel> loginWithEmail(
    String email,
    String password,
  ) async {
    final http.Response response = await http.post(
      Uri.parse(
          'https://8871-103-101-213-67.ngrok-free.app/whatsapp_users/loginEmail'),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: jsonEncode(<String, String>{
        'email': email,
        // 'name': name,
        //'phonenumber': email,
        'password': password,
      }),
    );

    if (response.statusCode == 200) {
      return UserModel.fromJson(json.decode(response.body));
    } else {
      throw Exception('Failed to create album.');
    }
  }

  Future<String> loginOut() async {
    final prefs = await SharedPreferences.getInstance();
    prefs.setString("email", "");
    prefs.setString("name", "");
    prefs.setString("phonenumber", "");
    prefs.setString("profileImage", "");
    return 'Success';
  }
}
