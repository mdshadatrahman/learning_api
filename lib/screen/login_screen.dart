import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:page_transition/page_transition.dart';
import 'package:rest_api/screen/home_screen.dart';
import 'package:rest_api/screen/register.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

import '../auth/app_url.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({Key? key}) : super(key: key);

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  TextEditingController usernameController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  bool _showPassword = true;
  bool _isLoading = false;
  final formKey = GlobalKey<FormState>();

  //Login
  Future login(String username, String password) async {
    final prefs = await SharedPreferences.getInstance();
    saveprefs(String token) async {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      prefs.setString('token', token);
    }

    Map<String, String> requestHeaders = {'Accept': 'application/json'};
    var request = http.MultipartRequest(
      'POST',
      Uri.parse(AppUrl.login),
    );
    request.fields.addAll({
      'username': username,
      'password': password,
    });
    request.headers.addAll(requestHeaders);

    request.send().then((result) async {
      http.Response.fromStream(result).then((response) {
        if (response.statusCode == 200) {
          var data = jsonDecode(response.body);
          print(data);
          setState(() {
            _isLoading = false;
          });
          Navigator.pushReplacement(
            context,
            PageTransition(
              child: const HomeScreen(),
              type: PageTransitionType.rightToLeft,
            ),
          );
          saveprefs(
            data['token'],
          );
          Fluttertoast.showToast(
            msg: 'Logged in successfully',
          );
        } else {
          setState(() {
            _isLoading = false;
          });
          Fluttertoast.showToast(
            msg: 'Error',
          );
        }
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    final height = MediaQuery.of(context).size.height;
    final width = MediaQuery.of(context).size.width;
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          centerTitle: true,
          title: const Text('Login'),
        ),
        body: Form(
          autovalidateMode: AutovalidateMode.onUserInteraction,
          key: formKey,
          child: Column(
            children: [
              SizedBox(height: height * 0.02),

              //Email
              Padding(
                padding: EdgeInsets.symmetric(
                  horizontal: width * 0.05,
                ),
                child: SizedBox(
                  // height: height * 0.06,
                  width: width,
                  child: TextFormField(
                    validator: (value) {
                      if (value != null && value.contains(' ')) {
                        return 'Username cannot contain space(s)';
                      } else {
                        return null;
                      }
                    },
                    keyboardType: TextInputType.text,
                    controller: usernameController,
                    decoration: const InputDecoration(
                      border: OutlineInputBorder(),
                      label: Text('Username'),
                    ),
                  ),
                ),
              ),

              SizedBox(height: height * 0.02),

              //Password
              Padding(
                padding: EdgeInsets.symmetric(
                  horizontal: width * 0.05,
                ),
                child: SizedBox(
                  height: height * 0.08,
                  width: width,
                  child: TextFormField(
                    validator: (value) {
                      if (value != null && value.length < 6) {
                        return 'Minimum 6 characters';
                      } else {
                        return null;
                      }
                    },
                    keyboardType: TextInputType.visiblePassword,
                    obscureText: _showPassword,
                    controller: passwordController,
                    decoration: InputDecoration(
                      suffix: IconButton(
                        onPressed: () {
                          setState(() {
                            _showPassword = !_showPassword;
                          });
                        },
                        icon: Icon(
                          Icons.remove_red_eye,
                          color: _showPassword
                              ? Colors.grey
                              : Theme.of(context).primaryColor,
                        ),
                      ),
                      border: const OutlineInputBorder(),
                      label: const Text('Password'),
                    ),
                  ),
                ),
              ),

              //Button
              SizedBox(height: height * 0.02),

              Padding(
                padding: EdgeInsets.symmetric(
                  horizontal: width * 0.05,
                ),
                child: SizedBox(
                  height: height * 0.05,
                  width: width * 0.9,
                  child: _isLoading
                      ? const Center(
                          child: CircularProgressIndicator(),
                        )
                      : ElevatedButton(
                          onPressed: () {
                            if (formKey.currentState!.validate()) {
                              setState(() {
                                _isLoading = true;
                              });
                              login(
                                usernameController.text,
                                passwordController.text,
                              );
                            }
                          },
                          child: const Text('LOGIN'),
                        ),
                ),
              ),
              SizedBox(height: height * 0.04),
              TextButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    PageTransition(
                      child: const RegisterScreen(),
                      type: PageTransitionType.rightToLeft,
                    ),
                  );
                },
                child: const Text(
                  'Register',
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
