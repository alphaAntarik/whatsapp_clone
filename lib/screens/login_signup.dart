import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'package:whatsapp_clone/auth%20methods/authentication.dart';

import 'package:whatsapp_clone/models/user_model.dart';
import 'package:whatsapp_clone/screens/tabscreen.dart';

import 'package:whatsapp_clone/widgets/form_body.dart';
import 'package:whatsapp_clone/widgets/gap.dart';
import 'package:whatsapp_clone/widgets/passwordFormField.dart';

import '../bloc/user_bloc.dart';
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
  TextEditingController phonenumber = TextEditingController();
  TextEditingController password = TextEditingController();
  final focus = FocusNode();

  final formKey = GlobalKey<FormState>();
  @override
  Widget build(BuildContext context) {
    // bool obscure = true;

    // final obscure = useState(true);

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
            // const Spacer(),
            // if (islogin == true)
            //   SizedBox(
            //     height: MediaQuery.of(context).size.height * 0.08,
            //   ),
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
                    EmailFormField(
                      controller: phonenumber,
                      icon: const Icon(Icons.phone_rounded),
                      labeltext: 'phonenumber',
                      type: TextInputType.number,
                    ),
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
                          onPressed: () async {
                            UserModel user = await AuthMethods().createAlbum(
                                email.text.trim(),
                                password.text.trim(),
                                name.text.trim(),
                                phonenumber.text.trim());

                            if (user.email != null) {
                              // final prefs =
                              //     await SharedPreferences.getInstance();
                              // prefs.setString("email", user.email ?? "");
                              // prefs.setString("name", user.name ?? "");
                              // prefs.setString(
                              //     "phonenumber", user.phonenumber ?? "");
                              // prefs.setString(
                              //     "profileImage", user.profileImage!);
                              BlocProvider.of<UserBloc>(context).add(
                                  UserLoadedEvent(
                                      user:
                                          "${user.name}+${user.email}+${user.phonenumber}+${user.profileImage}"));
                              Navigator.pushReplacementNamed(
                                  context, TabScreen.tabscreenRoute);
                            } else {
                              ScaffoldMessenger.of(context).showSnackBar(
                                  SnackBar(content: Text("Invalid details")));
                            }
                            //  context.router.push(const SignUpRoute());
                          },
                          child: Text(
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
                          onPressed: () async {
                            if (isloginwithphone) {
                              UserModel user =
                                  await AuthMethods().loginWithPhone(
                                //   email.text.trim(),
                                //   name.text.trim(),
                                phonenumber.text.trim(),
                                password.text.trim(),
                              );

                              if (user.email != null) {
                                // final prefs =
                                //     await SharedPreferences.getInstance();
                                // prefs.setString("email", user.email ?? "");
                                // prefs.setString("name", user.name ?? "");
                                // prefs.setString(
                                //     "phonenumber", user.phonenumber ?? "");
                                // prefs.setString(
                                //     "profileImage", user.profileImage!);
                                BlocProvider.of<UserBloc>(context).add(
                                    UserLoadedEvent(
                                        user:
                                            "${user.name}+${user.email}+${user.phonenumber}+${user.profileImage}"));
                                Navigator.pushReplacementNamed(
                                    context, TabScreen.tabscreenRoute);
                              } else {
                                ScaffoldMessenger.of(context).showSnackBar(
                                    SnackBar(
                                        content: Text(
                                            "Invalid phone number or password")));
                              }
                            } else {
                              UserModel user =
                                  await AuthMethods().loginWithEmail(
                                email.text.trim(),
                                password.text.trim(),
                                //   name.text.trim(),
                                //  phonenumber.text.trim()
                              );
                              // final prefs =
                              //     await SharedPreferences.getInstance();
                              // prefs.setString("email", user.email ?? "");
                              // prefs.setString("name", user.name ?? "");
                              // prefs.setString(
                              //     "phonenumber", user.phonenumber ?? "");
                              // prefs.setString(
                              //     "profileImage", user.profileImage!);

                              if (user.email != null) {
                                // final prefs =
                                //     await SharedPreferences.getInstance();
                                // prefs.setString("email", user.email ?? "");
                                // prefs.setString("name", user.name ?? "");
                                // prefs.setString(
                                //     "phonenumber", user.phonenumber ?? "");
                                // prefs.setString(
                                //     "profileImage", user.profileImage!);
                                BlocProvider.of<UserBloc>(context).add(
                                    UserLoadedEvent(
                                        user:
                                            "${user.name}+${user.email}+${user.phonenumber}+${user.profileImage}"));
                                Navigator.pushReplacementNamed(
                                    context, TabScreen.tabscreenRoute);
                              } else {
                                ScaffoldMessenger.of(context).showSnackBar(
                                    SnackBar(
                                        content:
                                            Text("Invalid gmail or password")));
                              }
                            }
                          },
                          child: Text(
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
