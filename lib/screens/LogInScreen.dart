import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:mapfeature_project/NavigationBar.dart';
import 'package:mapfeature_project/helper/constants.dart';
import 'package:mapfeature_project/helper/show_snack_bar.dart';
import 'package:mapfeature_project/moodTracer/sentiment.dart';
import 'package:mapfeature_project/screens/resetpassScreen.dart';
import 'package:mapfeature_project/widgets/customButton.dart';
import 'package:mapfeature_project/widgets/customTextField.dart';
import 'package:mapfeature_project/widgets/customdivider.dart';
import 'package:mapfeature_project/widgets/passwordfield.dart';
import 'package:modal_progress_hud_nsn/modal_progress_hud_nsn.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';

class LogInScreen extends StatefulWidget {
  final String? token;

  const LogInScreen({Key? key, this.token}) : super(key: key);

  @override
  State<LogInScreen> createState() => _LogInScreenState();
}

class _LogInScreenState extends State<LogInScreen> {
  bool isLoading = false;
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  String? email;
  String? password;
  List<SentimentRecording> moodRecordings = [];
  String? userId;

  late SharedPreferences sharedPreferences;

  @override
  void initState() {
    super.initState();

    SharedPreferences.getInstance().then((prefs) {
      sharedPreferences = prefs;

      validateToken();
    });
  }

  Future<void> validateToken() async {
    try {
      showDialog(
        // barrierColor: Colors.white,
        context: context,
        barrierDismissible: false,
        builder: (BuildContext context) {
          return AlertDialog(
            backgroundColor: Colors.white,
            surfaceTintColor: Colors.white,
            content: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                const SizedBox(
                  height: 30,
                ),
                Image.asset('images/photo_2024-05-16_19-12-57.jpg'),
                const SizedBox(
                  height: 25,
                ),
                SpinKitWave(
                  color: primaryColor,
                  size: 50.0,
                ),
                const SizedBox(height: 20),
                const Text(
                  'Validating Token...',
                  style: TextStyle(
                    fontWeight: FontWeight.w900,
                    fontSize: 20.0,
                    fontFamily: AlegreyaFont,
                    color: Color(0xff1F5D6B),
                  ),
                ),
                const SizedBox(
                  height: 25,
                ),
              ],
            ),
          );
        },
      );

      String? token = getToken();
      if (token != null && token.isNotEmpty) {
        final response = await http.get(
          Uri.parse(
              'https://mental-health-ef371ab8b1fd.herokuapp.com/api/checktoken'),
          headers: <String, String>{
            'Content-Type': 'application/json',
            'Authorization': 'Bearer $token',
          },
        );

        if (response.statusCode == 200) {
          Navigator.pop(context); // Dismiss the AlertDialog
          Map<String, dynamic> responseData = jsonDecode(response.body);
          String userId = responseData['id'].toString();
          String name = responseData['name'];
          String userEmail = responseData['email'];

          // Token is valid, navigate to home screen
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(
              builder: (context) => NavigationTabs(
                userId: userId,
                moodRecordings: moodRecordings,
                onMoodSelected: (moodRecording) {
                  if (mounted) {
                    setState(() {
                      moodRecordings.add(moodRecording);
                    });
                  }
                },
                selectedMoodPercentage: 0.0,
                token: token,
                name: name,
                email: userEmail,
              ),
            ),
          );

          return; // Exit  after navigation
        }
      }
      // If token is invalid or not present, dismiss AlertDialog and show the login screen
      Navigator.pop(context); // Dismiss the AlertDialog
      // Navigator.pushReplacementNamed(context, 'login');
    } catch (e) {
      print(e.toString());
      // If token is invalid or not present, dismiss AlertDialog and show the login screen
      Navigator.pop(context); // Dismiss the AlertDialog
      // Navigator.pushReplacementNamed(context, 'login');
    }
  }

  Future<void> setToken(String token) async {
    await sharedPreferences.setString('token', token);
  }

  String getToken() {
    return sharedPreferences.getString('token') ?? '';
  }

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
            key: _formKey,
            child: ListView(
              children: [
                const SizedBox(height: 20),
                DividerImage(),
                const SizedBox(height: 35),
                Container(
                  height: 500,
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
                          children: [
                            Padding(
                              padding: EdgeInsets.only(right: 210, top: 20),
                              child: Text(
                                'Hello !',
                                style: TextStyle(
                                  fontWeight: FontWeight.w700,
                                  fontFamily: nunitoFont,
                                  fontSize: 25,
                                  color: Color.fromARGB(255, 128, 133, 134),
                                ),
                              ),
                            ),
                            Text(
                              'WELCOME BACK',
                              style: TextStyle(
                                fontWeight: FontWeight.w700,
                                fontFamily: nunitoFont,
                                fontSize: 24,
                                color: Color(0xff1F5D6B),
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 30),
                        CustomFormTextField(
                          onChanged: (data) {
                            email = data;
                          },
                          hintText: '  Email',
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Email cannot be empty';
                            }
                            if (!RegExp(
                                    r"[a-z0-9!#$%&'*+/=?^_`{|}~-]+(?:\.[a-z0-9!#$%&'*+/=?^_`{|}~-]+)*@(?:[a-z0-9](?:[a-z0-9-]*[a-z0-9])?\.)+[a-z0-9](?:[a-z0-9-]*[a-z0-9])?")
                                .hasMatch(value)) {
                              return 'Invalid email format';
                            }
                            return null;
                          },
                        ),
                        const SizedBox(height: 10),
                        PasswordField(
                          onChanged: (data) {
                            password = data;
                          },
                          hintText: '  Password',
                        ),
                        const SizedBox(height: 20),
                        InkWell(
                          onTap: () async {
                            if (email != null) {
                              try {
                                await forgetPassword(email!);

                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) =>
                                        ResetPasswordScreen(email: email!),
                                  ),
                                );
                              } catch (e) {
                                print(e.toString());
                                showSnackBar(
                                    context, 'Failed to reset password');
                              }
                            } else {
                              showSnackBar(context, 'Please enter your email');
                            }
                          },
                          child: const Text(
                            'Forgot Password ? ',
                            style: TextStyle(
                              fontWeight: FontWeight.w600,
                              fontFamily: nunitoFont,
                              fontSize: 15,
                              color: Color(0xff1F5D6B),
                            ),
                          ),
                        ),
                        const SizedBox(height: 20),
                        CustomButton(
                          onTap: () async {
                            if (_formKey.currentState!.validate()) {
                              _formKey.currentState!.save();
                              setState(() {
                                isLoading = true;
                              });
                              try {
                                await loginUser();
                              } catch (ex) {
                                print(ex);
                                showSnackBar(context, 'There was an error');
                              }
                              setState(() {
                                isLoading = false;
                              });
                            }
                          },
                          text: '    Log in    ',
                        ),
                        const SizedBox(height: 30),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            const Text(
                              "Don't have an account?",
                              style: TextStyle(
                                fontWeight: FontWeight.w600,
                                fontFamily: latoFont,
                                color: Color.fromARGB(255, 136, 136, 136),
                              ),
                            ),
                            GestureDetector(
                              onTap: () {
                                Navigator.pushNamed(context, 'signup');
                              },
                              child: const Text(
                                ' Sign up',
                                style: TextStyle(
                                  fontWeight: FontWeight.w700,
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

  Future<void> forgetPassword(String email) async {
    try {
      final response = await http.post(
        Uri.parse(
            'https://mental-health-ef371ab8b1fd.herokuapp.com/api/forget_password'),
        headers: <String, String>{
          'Content-Type': 'application/json',
          'Accept': 'application/json',
        },
        body: jsonEncode(<String, String>{
          'email': email,
        }),
      );

      if (response.statusCode == 200) {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => ResetPasswordScreen(email: email),
          ),
        );
        showSnackBar(context, 'Password reset instructions sent to your email');
      } else {
        showSnackBar(context, 'Email address not found');
      }
    } catch (e) {
      print(e.toString());
      showSnackBar(context, 'Failed to connect to the server');
    }
  }

  Future<void> loginUser() async {
    try {
      final response = await http.post(
        Uri.parse('https://mental-health-ef371ab8b1fd.herokuapp.com/api/login'),
        headers: <String, String>{
          'Content-Type': 'application/json',
        },
        body: jsonEncode(<String, String>{
          'email': email!,
          'password': password!,
        }),
      );

      if (response.statusCode == 200) {
        Map<String, dynamic> responseData = jsonDecode(response.body);
        String userId = responseData['id'].toString();
        String name = responseData['Name'];
        String userEmail = responseData['email'];
        String token = responseData['token'];

        print('User ID: $userId');
        print('Name: $name');
        print('Email: $userEmail');
        print('Token: $token');
        setToken(token);
        setToken(token); // Save token locally
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder: (context) => NavigationTabs(
              userId: userId,
              moodRecordings: moodRecordings,
              onMoodSelected: (moodRecording) {
                if (mounted) {
                  setState(() {
                    moodRecordings.add(moodRecording);
                  });
                }
              },
              selectedMoodPercentage: 0.0,
              token: responseData['token'],
              name: responseData['Name'],
              email: responseData['email'],
            ),
          ),
        );
      } else if (response.statusCode == 401) {
        throw Exception('Email not registered or wrong password');
      } else if (response.statusCode == 403) {
        throw Exception('Invalid user information');
      } else {
        throw Exception('Failed to log in');
      }
    } catch (e) {
      print(e.toString());
      showSnackBar(context, 'Failed to connect to the server');
    } finally {
      setState(() {
        isLoading = false;
      });
    }
  }
}
