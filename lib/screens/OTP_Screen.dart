import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:mapfeature_project/NavigationBar.dart';
import 'package:mapfeature_project/helper/show_snack_bar.dart';
import 'package:mapfeature_project/moodTracer/sentiment.dart';
import 'package:mapfeature_project/widgets/customButton.dart';
import 'package:mapfeature_project/widgets/customTextField.dart';
import 'package:modal_progress_hud_nsn/modal_progress_hud_nsn.dart';
import 'dart:convert';

class OtpScreen extends StatefulWidget {
  final String? userId;
  final String? token;

  const OtpScreen({Key? key, this.userId, this.token}) : super(key: key);

  @override
  _OtpScreenState createState() => _OtpScreenState();
}

class _OtpScreenState extends State<OtpScreen> {
  String? otp;
  bool isLoading = false;
  List<SentimentRecording> moodRecordings = [];

  @override
  Widget build(BuildContext context) {
    return ModalProgressHUD(
      inAsyncCall: isLoading,
      child: Scaffold(
        backgroundColor: Colors.white,
        body: Container(
          padding: EdgeInsets.all(20.0),
          child: Card(
            color: Color(0xffF6F8F8),
            elevation: 5,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(15),
            ),
            child: Padding(
              padding: EdgeInsets.all(20),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Text(
                    'Verify Your Email',
                    style: TextStyle(
                        fontSize: 17,
                        color: Color(0xff1F5D6B),
                        fontFamily: 'Langar',
                        fontWeight: FontWeight.w700),
                  ),
                  SizedBox(height: 20.0),
                  CustomFormTextField(
                    onChanged: (data) {
                      otp = data;
                    },
                    hintText: 'OTP',
                  ),
                  SizedBox(height: 20.0),
                  CustomButton(
                    onTap: () async {
                      if (otp != null && otp!.isNotEmpty) {
                        _handleVerifyOtp();
                      } else {
                        showSnackBar(context, 'Please enter OTP');
                      }
                    },
                    text: 'VERIFY OTP',
                  ),
                  SizedBox(height: 10.0),
                  CustomButton(
                    onTap: () async {
                      _handleResendOtp();
                    },
                    text: 'RESEND OTP',
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Future<void> _handleVerifyOtp() async {
    try {
      setState(() {
        isLoading = true;
      });
      await verifyOtp(widget.userId ?? '', otp!);
    } catch (e) {
      showSnackBar(context, 'Failed to verify OTP');
    } finally {
      setState(() {
        isLoading = false;
      });
    }
  }

  Future<void> _handleResendOtp() async {
    try {
      setState(() {
        isLoading = true;
      });
      await resendOtp(widget.userId ?? '');
      showSnackBar(context, 'OTP resent successfully');
    } catch (e) {
      showSnackBar(context, 'Failed to resend OTP');
    } finally {
      setState(() {
        isLoading = false;
      });
    }
  }

  Future<void> verifyOtp(String userId, String otp) async {
    try {
      final response = await http.post(
        Uri.parse(
            'https://mental-health-ef371ab8b1fd.herokuapp.com/api/verify'),
        headers: <String, String>{
          'Accept': 'application/json',
        },
        body: <String, String>{
          'otp': otp,
          'id': userId,
        },
      );

      if (response.statusCode == 200) {
        // Parse the response JSON
        Map<String, dynamic> responseData = jsonDecode(response.body);

        // Extract required fields
        String id = responseData['id'].toString();
        String name = responseData['Name'];
        String email = responseData['email'];
        String token = responseData['token'];

        // Proceed with navigation or further processing
        // For demonstration purposes, print the extracted data
        print('ID: $id');
        print('Name: $name');
        print('Email: $email');
        print('Token: $token');

        // Example: Navigate to the next screen
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder: (context) => NavigationTabs(
              userId: id,
              token: token,
              email: email, // Pass the email here
              moodRecordings: moodRecordings,
              onMoodSelected: (moodRecording) {
                setState(() {
                  moodRecordings.add(moodRecording);
                });
              },
              selectedMoodPercentage: 0.0,

              name: name,
            ),
          ),
        );
      } else {
        // OTP verification failed
        // Handle error
        throw Exception('Failed to verify OTP');
      }
    } catch (e) {
      // Handle network errors or parsing errors
      throw Exception('Failed to connect to the server');
    }
  }

  Future<void> resendOtp(String userId) async {
    try {
      final response = await http.post(
        Uri.parse(
            'https://mental-health-ef371ab8b1fd.herokuapp.com/api/resend_otp'),
        headers: <String, String>{
          'Accept': 'application/json',
        },
        body: <String, String>{
          'id': userId,
        },
      );

      if (response.statusCode != 200) {
        // Failed to resend OTP
        throw Exception('Failed to resend OTP');
      }
    } catch (e) {
      // Handle network errors
      throw Exception('Failed to connect to the server');
    }
  }
}
