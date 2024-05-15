import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:mapfeature_project/NavigationBar.dart';
import 'package:mapfeature_project/helper/constants.dart';
import 'package:mapfeature_project/helper/show_snack_bar.dart';
import 'package:mapfeature_project/moodTracer/sentiment.dart';
import 'package:mapfeature_project/screens/OTP_Screen.dart';
import 'package:mapfeature_project/widgets/customButton.dart';
import 'package:mapfeature_project/widgets/customTextField.dart';
import 'package:mapfeature_project/widgets/customdivider.dart';
import 'package:mapfeature_project/widgets/passwordfield.dart';
import 'package:modal_progress_hud_nsn/modal_progress_hud_nsn.dart';

class SignUpScreen extends StatefulWidget {
  const SignUpScreen({Key? key}) : super(key: key);

  @override
  State<SignUpScreen> createState() => _SignUpScreenState();
}

class _SignUpScreenState extends State<SignUpScreen> {
  String? name;
  String? email;
  String? password;
  String? confirmPassword;
  bool isLoading = false;

  GlobalKey<FormState> formKey = GlobalKey();
  String? _confirmPasswordError;
  List<SentimentRecording> moodRecordings = [];
  String? userId;

  @override
  Widget build(BuildContext context) {
    return ModalProgressHUD(
      inAsyncCall: isLoading,
      child: Scaffold(
        body: Container(
          margin: const EdgeInsets.symmetric(vertical: 20, horizontal: 15),
          height: double.infinity,
          width: double.infinity,
          child: Form(
            key: formKey,
            child: ListView(
              children: [
                DividerImage(),
                const SizedBox(height: 10),
                Container(
                  width: 100,
                  decoration: BoxDecoration(
                    color: const Color(0xffF6F8F8),
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(10.0),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        const Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            Padding(
                              padding: EdgeInsets.only(right: 150, top: 20),
                              child: Text(
                                'Welcome!',
                                style: TextStyle(
                                  fontFamily: nunitoFont,
                                  fontWeight: FontWeight.w800,
                                  fontSize: 22,
                                  color: Color.fromARGB(255, 128, 133, 134),
                                ),
                              ),
                            ),
                            Text(
                              'Create Your Account ',
                              style: TextStyle(
                                fontFamily: nunitoFont,
                                fontWeight: FontWeight.w800,
                                fontSize: 21,
                                color: Color(0xff1F5D6B),
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 30),
                        CustomFormTextField(
                          onChanged: (data) {
                            name = data;
                          },
                          hintText: 'Full Name',
                        ),
                        const SizedBox(height: 20),
                        CustomFormTextField(
                          onChanged: (data) {
                            email = data;
                          },
                          hintText: 'Email',
                          validator: (data) {
                            if (data!.isEmpty) {
                              return 'Field is required';
                            }

                            if (!isEmailValid(data)) {
                              return 'Invalid email address';
                            }

                            return null;
                          },
                        ),
                        const SizedBox(height: 20),
                        PasswordField(
                          onChanged: (data) {
                            password = data;
                          },
                          hintText: 'Password',
                          minLength: 6,
                          onValidate: (data) {
                            if (data == null || data.isEmpty) {
                              return 'Field is required';
                            }

                            // Add your custom password validation rules here
                            if (data.length < 8) {
                              return 'Password must be at least 8 characters long';
                            }
                            if (!data.contains(RegExp(r'[A-Z]'))) {
                              return 'Password must contain at least one uppercase letter';
                            }
                            if (!data.contains(RegExp(r'[a-z]'))) {
                              return 'Password must contain at least one lowercase letter';
                            }
                            if (!data.contains(RegExp(r'[0-9]'))) {
                              return 'Password must contain at least one digit';
                            }

                            return null;
                          },
                        ),
                        const SizedBox(height: 20),
                        PasswordField(
                          onChanged: (data) {
                            confirmPassword = data;
                          },
                          hintText: 'Confirm Password',
                          onValidate: (data) {
                            if (password != null &&
                                confirmPassword != null &&
                                password != confirmPassword) {
                              return 'Passwords do not match';
                            }
                            return null;
                          },
                        ),
                        const SizedBox(height: 20),
                        CustomButton(
                          onTap: () async {
                            if (formKey.currentState!.validate()) {
                              isLoading = true;
                              setState(() {});
                              try {
                                await registerUser();
                                // Show a snackbar to inform the user to check their email
                                showSnackBar(context,
                                    'Please check your email for the verification OTP.');
                              } catch (ex) {
                                showSnackBar(context, 'There was an error');
                              }
                              isLoading = false;
                              setState(() {});
                            } else {
                              if (password != null &&
                                  confirmPassword != null &&
                                  password != confirmPassword) {
                                setState(() {
                                  _confirmPasswordError =
                                      'Passwords do not match';
                                });
                              } else {
                                setState(() {
                                  _confirmPasswordError = null;
                                });
                              }
                            }
                          },
                          text: 'SIGN UP',
                        ),
                        const SizedBox(height: 20),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            const Text(
                              'Already have an account?',
                              style: TextStyle(
                                  fontFamily: latoFont,
                                  fontWeight: FontWeight.w700,
                                  color: Color.fromARGB(255, 136, 136, 136)),
                            ),
                            GestureDetector(
                              onTap: () {
                                Navigator.pop(context);
                              },
                              child: const Text(
                                '  Login',
                                style: TextStyle(
                                  fontWeight: FontWeight.w900,
                                  fontFamily: latoFont,
                                  color: Color(0xff1F5D6B),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Future<void> registerUser() async {
    if (!mounted) return;

    setState(() {
      isLoading = true;
    });

    try {
      final response = await http.post(
        Uri.parse(
            'https://mental-health-ef371ab8b1fd.herokuapp.com/api/register'),
        headers: <String, String>{
          'Accept': 'application/json',
        },
        body: <String, String>{
          'name': name!,
          'email': email!,
          'password': password!,
        },
      );

      if (response.statusCode == 200) {
        final responseData = json.decode(response.body);
        final userId = responseData['id'].toString();

        // Navigate to the OTP screen with the user ID
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => OtpScreen(userId: userId),
          ),
        );
      } else if (response.statusCode == 422) {
        showSnackBar(context, 'Email already in use');
        throw Exception('Email already in use');
      } else if (response.statusCode == 400) {
        showSnackBar(context, 'Email already exists but not confirmed');
        throw Exception('Email already exists but not confirmed');
      } else {
        showSnackBar(context, 'Failed to register user');
        throw Exception('Failed to register user');
      }
    } catch (e) {
      print(e.toString());
      showSnackBar(context, 'Error: $e');
    } finally {
      if (mounted) {
        setState(() {
          isLoading = false;
        });
      }
    }
  }

  bool isEmailValid(String email) {
    final emailRegex = RegExp(
        r'^[a-zA-Z0-9.a-zA-Z0-9.!#$%&’*+/=?^_`{|}~-]+@[a-zA-Z0-9]+\.[a-zA-Z]+');
    return emailRegex.hasMatch(email);
  }
}
