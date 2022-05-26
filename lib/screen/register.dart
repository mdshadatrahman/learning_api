import 'package:email_validator/email_validator.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:http/http.dart' as http;

import '../auth/app_url.dart';

class RegisterScreen extends StatefulWidget {
  const RegisterScreen({Key? key}) : super(key: key);

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  TextEditingController usernameController = TextEditingController();
  bool _isLoading = false;
  bool _showPassword = true;
  final formKey = GlobalKey<FormState>();

  //Register
  Future register(String username, String email, String password) async {
    String status = 'success';
    Map<String, String> requestHeaders = {'Accept': 'application/json'};
    var request = http.MultipartRequest(
      'POST',
      Uri.parse(AppUrl.register),
    );
    request.fields.addAll({
      'username': username,
      'email': email,
      'password': password,
    });
    request.headers.addAll(requestHeaders);

    request.send().then((result) async {
      http.Response.fromStream(result).then((response) {
        print(response.body);
        if (response.statusCode == 200) {
          setState(() {
            _isLoading = false;
          });
          Fluttertoast.showToast(
            msg: 'Registration Successful, you can login now.',
          );
          Navigator.pop(context);
          // Navigator.pushReplacement(
          //   context,
          //   PageTransition(
          //     child: const LoginScreen(),
          //     type: PageTransitionType.rightToLeft,
          //   ),
          // );
        } else {
          setState(() {
            _isLoading = false;
          });
          Fluttertoast.showToast(
            msg: 'Registration failed.',
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
          title: const Text('Register'),
        ),
        body: SingleChildScrollView(
          child: Form(
            autovalidateMode: AutovalidateMode.onUserInteraction,
            key: formKey,
            child: Column(
              children: [
                SizedBox(height: height * 0.02),

                //username
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
                          return 'username can not contain space(s)';
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
                        if (value != null && !EmailValidator.validate(value)) {
                          return 'Invalid Email';
                        } else {
                          return null;
                        }
                      },
                      keyboardType: TextInputType.emailAddress,
                      controller: emailController,
                      decoration: const InputDecoration(
                        border: OutlineInputBorder(),
                        label: Text('Email'),
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
                            onPressed: () async {
                              if (formKey.currentState!.validate()) {
                                setState(() {
                                  _isLoading = true;
                                });
                                register(
                                  usernameController.text,
                                  emailController.text,
                                  passwordController.text,
                                );
                              }
                            },
                            child: const Text('Register'),
                          ),
                  ),
                ),
                SizedBox(height: height * 0.1),
                TextButton(
                  onPressed: () {
                    Navigator.pop(context);
                    // Navigator.pushReplacement(
                    //   context,
                    //   PageTransition(
                    //     child: const RegisterScreen(),
                    //     type: PageTransitionType.leftToRight,
                    //   ),
                    // );
                  },
                  child: const Text(
                    'Login',
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
