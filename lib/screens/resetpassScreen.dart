import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:mapfeature_project/helper/show_snack_bar.dart';
import 'package:mapfeature_project/widgets/customButton.dart';
import 'package:mapfeature_project/widgets/passwordfield.dart';

class ResetPasswordScreen extends StatefulWidget {
  final String email; // Add email parameter here
  const ResetPasswordScreen({Key? key, required this.email}) : super(key: key);

  @override
  State<ResetPasswordScreen> createState() => _ResetPasswordScreenState();
}

class _ResetPasswordScreenState extends State<ResetPasswordScreen> {
  GlobalKey<FormState> formKey = GlobalKey();
  String? password, confirmPassword;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Card(
          color: Color(0xffF6F8F8),
          margin: const EdgeInsets.symmetric(horizontal: 20, vertical: 50),
          child: Padding(
            padding: const EdgeInsets.all(20),
            child: Form(
              key: formKey,
              child: ListView(
                shrinkWrap: true,
                children: [
                  SizedBox(
                    height: 0,
                  ),
                  Text(
                    'RESET PASSWORD',
                    style: TextStyle(
                        fontSize: 20,
                        color: Color(0xff1F5D6B),
                        fontFamily: 'Langar',
                        fontWeight: FontWeight.w700),
                  ),
                  const SizedBox(height: 20),
                  PasswordField(
                    onChanged: (data) {
                      password = data;
                    },
                    hintText: 'New Password',
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
                    hintText: 'Confirm New Password',
                    minLength: 6,
                    onValidate: (data) {
                      if (data == null || data.isEmpty) {
                        return 'Field is required';
                      }
                      if (data != password) {
                        return 'Passwords do not match';
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 20),
                  CustomButton(
                    onTap: () async {
                      if (formKey.currentState!.validate()) {
                        // Implement your logic to reset the password
                        // Call the API to reset the password
                        try {
                          await resetPassword();
                        } catch (ex) {
                          print(ex.toString());
                          showSnackBar(context, 'Failed to change password');
                        }
                      }
                    },
                    text: 'CHANGE PASSWORD',
                  ),
                  SizedBox(
                    height: 30,
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Future<void> resetPassword() async {
    try {
      final response = await http.post(
        Uri.parse(
            'https://mental-health-ef371ab8b1fd.herokuapp.com/api/reset_password'),
        headers: <String, String>{
          'Content-Type': 'application/json',
        },
        body: jsonEncode(<String, String>{
          'email': widget.email,
          'password': password!,
          'password_confirmation': confirmPassword!,
        }),
      );

      if (response.statusCode == 200) {
        final responseData = jsonDecode(response.body);
        final message = responseData['message'];
        showSnackBar(context, message);
        Navigator.pop(context); // Pop the ResetPasswordScreen
      } else {
        // Password change failed
        // Handle error
        throw Exception('Failed to change password');
      }
    } catch (e) {
      print(e.toString());
      // Handle network errors
      throw Exception('Failed to connect to the server');
    }
  }
}
