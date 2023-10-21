import 'package:flutter/material.dart';

import 'package:shared_preferences/shared_preferences.dart';

import 'package:whatsapp_clone/auth%20methods/authentication.dart';

import 'package:whatsapp_clone/models/user_model.dart';
import 'package:whatsapp_clone/screens/tabscreen.dart';

import 'package:whatsapp_clone/widgets/form_body.dart';
import 'package:whatsapp_clone/widgets/gap.dart';
import 'package:whatsapp_clone/widgets/mobile_form_field.dart';
import 'package:whatsapp_clone/widgets/passwordFormField.dart';

import '../widgets/email_form_field.dart';

import '../widgets/logo.dart';

class LoginSignUp extends StatefulWidget {
  static String loginSignupRoute = '/loginsignuproute';
  const LoginSignUp({super.key});

  @override
  State<LoginSignUp> createState() => _LoginSignUpState();
}

class _LoginSignUpState extends State<LoginSignUp> {
  bool islogin = false;
  bool islogin1 = false;
  bool isloginwithphone = false;
  TextEditingController email = TextEditingController();
  TextEditingController name = TextEditingController();
  //TextEditingController phonenumber = TextEditingController();
  TextEditingController password = TextEditingController();
  final focus = FocusNode();
  bool _isloading = false;
  String pnumber = '';
  void setnumber(String number) {
    setState(() {
      pnumber = number;
    });
  }

  final formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    void loginemail(String email, String password) async {
      setState(() {
        _isloading = true;
      });
      UserModel user = await AuthMethods().loginWithEmail(
        email,
        password,
      );

      if (user.email != null) {
        final prefs = await SharedPreferences.getInstance();
        setState(() {
          // BlocProvider.of<UserBloc>(context)
          //     .add(UserLoadedEvent(user: "${user.id}"));
          prefs.setString("id", "${user.id}");
          prefs.setString("name", "${user.name}");
          Navigator.pushReplacementNamed(context, TabScreen.tabscreenRoute);
          _isloading = false;
        });
      } else {
        ScaffoldMessenger.of(context)
            .showSnackBar(SnackBar(content: Text("Invalid gmail or password")));
        setState(() {
          _isloading = false;
        });
      }
    }

    void loginPhone(String phonenumber, String password) async {
      setState(() {
        _isloading = true;
      });
      UserModel user = await AuthMethods().loginWithPhone(
        phonenumber,
        password,
      );

      if (user.email != null) {
        final prefs = await SharedPreferences.getInstance();
        setState(() {
          // BlocProvider.of<UserBloc>(context)
          //     .add(UserLoadedEvent(user: "${user.id}"));
          prefs.setString("id", "${user.id}");
          prefs.setString("name", "${user.name}");
          Navigator.pushReplacementNamed(context, TabScreen.tabscreenRoute);
          _isloading = false;
        });
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text("Invalid phone number or password")));
        setState(() {
          _isloading = false;
        });
      }
    }

    void signup(
        String email, String password, String name, String phonenumber) async {
      setState(() {
        _isloading = true;
      });
      UserModel user =
          await AuthMethods().createAlbum(email, password, name, phonenumber);

      if (user.email != null) {
        final prefs = await SharedPreferences.getInstance();
        setState(() {
          // BlocProvider.of<UserBloc>(context)
          //     .add(UserLoadedEvent(user: "${user.id}"));
          prefs.setString("id", "${user.id}");
          prefs.setString("name", "${user.name}");
          Navigator.pushReplacementNamed(context, TabScreen.tabscreenRoute);
          _isloading = false;
        });
      } else {
        ScaffoldMessenger.of(context)
            .showSnackBar(SnackBar(content: Text("Invalid details")));
        setState(() {
          _isloading = false;
        });
      }
    }

    return Scaffold(
      backgroundColor: Color(0xFF190014),
      body: SingleChildScrollView(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(
              height: MediaQuery.of(context).size.height * 0.2,
            ),
            const Padding(
              padding: EdgeInsets.all(8.0),
              child: Slogan(),
            ),

            Container(
              height: MediaQuery.of(context).size.height * 0.4,
              alignment: Alignment.bottomCenter,
              child: FormBody(
                formKey: formKey,
                children: [
                  if (!islogin1 && !isloginwithphone || !islogin)
                    EmailFormField(
                      controller: email,
                      icon: const Icon(Icons.email_outlined),
                      labeltext: 'email',
                      type: TextInputType.emailAddress,
                    ),
                  if (islogin == false)
                    EmailFormField(
                      controller: name,
                      icon: const Icon(Icons.person),
                      labeltext: 'name',
                      type: TextInputType.name,
                    ),
                  if (islogin == false || isloginwithphone)
                    MovileFormField(
                      setNumber: setnumber,
                    ),
                  // EmailFormField(
                  //   controller: phonenumber,
                  //   icon: const Icon(Icons.phone_rounded),
                  //   labeltext: 'phonenumber',
                  //   type: TextInputType.number,
                  // ),
                  PasswordFormField(
                    controller: password,
                    //  obscure: obscure,
                  ),
                ],
              ),
            ),
            const Gap(),

            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      if (islogin == false)
                        ElevatedButton(
                          onPressed: () {
                            signup(email.text.trim(), password.text.trim(),
                                name.text, pnumber);
                          },
                          child: _isloading
                              ? CircularProgressIndicator(
                                  color: Color(0xFF190014),
                                )
                              : Text(
                                  "Signup",
                                  style: TextStyle(
                                    color: Color(0xFF190014),
                                  ),
                                ),
                        ),
                      TextButton(
                          onPressed: () {
                            setState(() {
                              islogin = !islogin;
                            });
                          },
                          child: Text(islogin == true
                              ? "Don't have an account"
                              : "Already have an account")),
                      if (islogin == true)
                        FilledButton(
                          onPressed: () {
                            if (isloginwithphone) {
                              loginPhone(
                                pnumber,
                                password.text.trim(),
                              );
                            } else {
                              loginemail(
                                email.text.trim(),
                                password.text.trim(),
                              );
                            }
                          },
                          child: _isloading
                              ? CircularProgressIndicator(
                                  color: Color(0xFF190014),
                                )
                              : Text(
                                  "Login",
                                  style: TextStyle(
                                    color: Color(0xFF190014),
                                  ),
                                ),
                        ),
                    ],
                  ),
                  if (islogin)
                    TextButton(
                        onPressed: () {
                          setState(() {
                            isloginwithphone = !isloginwithphone;
                            islogin1 = !islogin1;
                          });
                        },
                        child: isloginwithphone
                            ? Text("login with email")
                            : Text("login with phone"))
                ],
              ),
            ),
            //  const Gap(),
          ],
        ),
      ),
    );
  }
}
