import 'dart:io';

import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:whatsapp_clone/models/get_img_model.dart';

import 'dart:convert';

import '../models/user_model.dart';

class AuthMethods {
  Future<UserModel> getUserById(
    String id,
  ) async {
    final http.Response response = await http.post(
      Uri.parse(
          'https://9dc3-103-101-213-67.ngrok-free.app/whatsapp_users/getbyid'),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: jsonEncode(<String, String>{'id': id}),
    );

    if (response.statusCode == 200) {
      return UserModel.fromJson(json.decode(response.body));
    } else {
      throw Exception('Failed to create album.');
    }
  }

  Future<UserModel> createAlbum(
      String email, String password, String name, String phonenumber) async {
    final http.Response response = await http.post(
      Uri.parse(
          'https://9dc3-103-101-213-67.ngrok-free.app/whatsapp_users/signup'),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: jsonEncode(<String, String>{
        'email': email,
        'name': name,
        'password': password,
        'phonenumber': phonenumber,
        'profileImage': ""
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
          'https://9dc3-103-101-213-67.ngrok-free.app/whatsapp_users/loginPhoneNumber'),
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

  Future<String> uploadPhoto(File? imagefile) async {
    final url = Uri.parse(
        'https://9dc3-103-101-213-67.ngrok-free.app/whatsapp_users/imageUpload'); // Replace with your API endpoint

    var request = http.MultipartRequest(
      'POST',
      url,
    );
    Map<String, String> headers = {"Content-type": "multipart/form-data"};
    request.files.add(
      http.MultipartFile(
        'image',
        imagefile!.readAsBytes().asStream(),
        imagefile.lengthSync(),
        filename: imagefile.path.split('/').last,
        //contentType: MediaType('image','jpeg'),
      ),
    );
    request.headers.addAll(headers);

    final response = await request.send();

    // final http.Response response = await http.post(
    //   Uri.parse(
    //       'https://9dc3-103-101-213-67.ngrok-free.app/whatsapp_users/imageUpload'),
    //   headers: <String, String>{
    //     'Content-Type': 'application/json; charset=UTF-8',
    //   },
    //   body: jsonEncode(<String, File>{
    //     // 'email': email,
    //     // 'name': name,
    //     "image": imagefile!,
    //   }),
    // );

    if (response.statusCode == 200) {
      final responseBody = await response.stream.bytesToString();
      print("Image uploaded successfully");
      print(responseBody);
      return json.decode(responseBody);
    } else {
      throw Exception('Failed to upload image.');
    }
  }

  Future<UserModel> updatePhoto(String id, File? img) async {
    final http.Response response = await http.put(
      Uri.parse(
          'https://9dc3-103-101-213-67.ngrok-free.app/whatsapp_users/update/${id}'),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: jsonEncode(<String, String>{
        // 'email': email,
        // 'name': name,
        "profileImage": await uploadPhoto(img),
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
          'https://9dc3-103-101-213-67.ngrok-free.app/whatsapp_users/loginEmail'),
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
