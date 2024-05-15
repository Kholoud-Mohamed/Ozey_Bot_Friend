import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:mapfeature_project/screens/resetpassScreen.dart';
import 'dart:io';
import 'package:mapfeature_project/screens/settings.dart';
import 'package:intl_phone_field/intl_phone_field.dart';

class EditProfilePage extends StatefulWidget {
  final String? email;
  final String? username;
  final String userId;
  final String token;
  final String? name;

  EditProfilePage({
    this.email,
    this.username,
    required this.userId,
    required this.token,
    this.name,
  });

  @override
  _EditProfilePageState createState() => _EditProfilePageState();
}

class _EditProfilePageState extends State<EditProfilePage> {
  File? _selectedImage;
  TextEditingController fullNameController = TextEditingController();

  TextEditingController phoneNumberController =
      TextEditingController(text: '01033886818');
  String? selectedGender;
  TextEditingController dobController =
      TextEditingController(text: "22/2/2002");
  bool showPassword = false;
  bool isEditMode = false;

  @override
  void initState() {
    super.initState();

    // Initialize the controllers with default values
    fullNameController.text = widget.name ?? "";
    phoneNumberController.text = '01033886818';
    selectedGender = null;
    dobController.text = "22/2/2002";

    _fetchProfileData();
  }

  Future<void> _fetchProfileData() async {
    // Prepare the headers
    Map<String, String> headers = {
      "Authorization": "Bearer ${widget.token}",
      "Accept": "application/json",
    };

    String apiUrl =
        'https://mental-health-ef371ab8b1fd.herokuapp.com/api/users/${widget.userId}';

    // Make the HTTP GET request to fetch the profile data
    http.Response response = await http.get(
      Uri.parse(apiUrl),
      headers: headers,
    );

    if (mounted) {
      if (response.statusCode == 200) {
        Map<String, dynamic> responseData = json.decode(response.body);

        setState(() {
          fullNameController.text = responseData['name'] ?? '';
          phoneNumberController.text = responseData['phone'] ?? '';
          selectedGender = responseData['gender'];
          dobController.text = responseData['DOB'] ?? '';
          // Update other fields if needed
        });
      } else {
        print("Error: ${response.body}");
      }
    }
  }

  @override
  void dispose() {
    fullNameController.dispose();
    phoneNumberController.dispose();
    dobController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).scaffoldBackgroundColor,
        elevation: 1,
        leading: IconButton(
          icon: const Icon(
            Icons.arrow_back,
            color: Colors.black,
          ),
          onPressed: () {
            Navigator.of(context).pop();
          },
        ),
        title: const Text('       Personal Info'),
        actions: [
          if (isEditMode) // Show save button only in edit mode
            ElevatedButton(
              onPressed: () {
                setState(() {
                  isEditMode = false; // Exit edit mode
                });
                // Save functionality
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFFB7C3C5),
                padding: const EdgeInsets.symmetric(horizontal: 20),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(20),
                ),
              ),
              child: const Text(
                "SAVE",
                style: TextStyle(
                  fontSize: 14,
                  letterSpacing: 2.2,
                  color: Colors.white,
                ),
              ),
            ),
          IconButton(
            icon: const Icon(
              Icons.edit,
              color: Colors.black,
            ),
            onPressed: () {
              setState(() {
                isEditMode = !isEditMode; // Toggle edit mode
              });
            },
          ),
        ],
      ),
      body: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 25),
        child: ListView(
          children: [
            Center(
              child: Stack(
                children: [
                  GestureDetector(
                    onTap: () {
                      if (isEditMode) {
                        _pickImage(); // Open gallery only in edit mode
                      }
                    },
                    child: Container(
                      width: 130,
                      height: 130,
                      decoration: BoxDecoration(
                        border: Border.all(
                          width: 4,
                          color: Theme.of(context).scaffoldBackgroundColor,
                        ),
                        boxShadow: [
                          BoxShadow(
                            spreadRadius: 2,
                            blurRadius: 10,
                            color: Colors.black.withOpacity(0.1),
                            offset: const Offset(0, 10),
                          )
                        ],
                        shape: BoxShape.circle,
                      ),
                      child: GestureDetector(
                        onTap: () {
                          if (isEditMode) {
                            _pickImage(); // Open gallery only in edit mode
                          }
                        },
                        child: CircleAvatar(
                          backgroundImage: _selectedImage != null
                              ? FileImage(_selectedImage!)
                                  as ImageProvider<Object>
                              : const AssetImage(
                                  "images/photo_2024-01-17_04-23-53-removebg-preview.png"),
                        ),
                      ),
                    ),
                  ),
                  Positioned(
                    bottom: 0,
                    right: 0,
                    child: Visibility(
                      visible: isEditMode,
                      child: GestureDetector(
                        onTap: () {
                          _pickImage(); // Open gallery when edit icon is tapped
                        },
                        child: Container(
                          height: 40,
                          width: 40,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            border: Border.all(
                              width: 4,
                              color: Theme.of(context).scaffoldBackgroundColor,
                            ),
                            color: const Color(0xFFB7C3C5),
                          ),
                          child: const Icon(
                            Icons.edit,
                            color: Colors.white,
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(
              height: 35,
            ),
            const Text(
              'Full Name',
              style: TextStyle(
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 10.0),
            buildTextField('.', fullNameController),
            const Text(
              'Phone Number',
              style: TextStyle(
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 10.0),
            buildTextField('..', phoneNumberController),
            const Text(
              'Gender',
              style: TextStyle(
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 10.0),
            buildGenderDropdown(),
            const Text(
              'Date of Birth',
              style: TextStyle(
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 10.0),
            buildTextField('...', dobController,
                onTap: () => _selectDate(context)),
            const SizedBox(
              height: 10,
            ),
            GestureDetector(
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) =>
                        ResetPasswordScreen(email: widget.email ?? ""),
                  ),
                );
              },
              child: Container(
                padding: const EdgeInsets.symmetric(
                    horizontal: 20.0, vertical: 10.0),
                decoration: BoxDecoration(
                  color: Colors.grey[200],
                  borderRadius: BorderRadius.circular(25.0),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text(
                      'Reset your password',
                      style:
                          TextStyle(fontSize: 16.0, color: Color(0xFF355A5C)),
                    ),
                    Icon(
                      Icons.check,
                      color: Colors.grey[700],
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(
              height: 10,
            ),
            GestureDetector(
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) =>
                            SettingsPage()), // تستبدل SecondScreen بشاشة الوجهة الثانية الخاصة بك
                  );
                },
                child: Container(
                  padding: const EdgeInsets.symmetric(
                      horizontal: 20.0, vertical: 10.0),
                  decoration: BoxDecoration(
                    color: Colors.grey[200],
                    borderRadius: BorderRadius.circular(25.0),
                  ),
                  child: const Row(
                    children: [
                      Icon(
                        Icons.logout,
                        color: Colors.red,
                      ),
                      Text('  Log Out',
                          style: TextStyle(fontSize: 16, color: Colors.red)),
                    ],
                  ),
                ))
          ],
        ),
      ),
    );
  }

  Widget buildTextField(String labelText, TextEditingController controller,
      {VoidCallback? onTap}) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 35.0),
      child: labelText == "."
          ? TextFormField(
              controller: controller,
              readOnly: !isEditMode, // Set readOnly based on edit mode
              onTap: onTap,
              decoration: InputDecoration(
                filled: true,
                fillColor: Colors.grey[100],
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(35),
                ),
                prefixIcon: Icon(
                  Icons.person,
                  color: Colors.grey[500],
                ),
                contentPadding: const EdgeInsets.symmetric(horizontal: 16),
              ),
              style: const TextStyle(
                fontWeight: FontWeight.bold, // تجعل النص داخل الحقل bold
              ),
            )
          : labelText == ".."
              ? IntlPhoneField(
                  decoration: InputDecoration(
                    filled: true,
                    fillColor: Colors.grey[100],
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(35),
                    ),
                  ),
                  style: const TextStyle(
                    fontWeight: FontWeight.bold, // تجعل النص داخل الحقل bold
                  ),
                  controller: controller,
                  enabled: isEditMode,
                  initialCountryCode: 'EG', // تعيين رمز البلد لمصر
                  onChanged: (phone) {
                    // يمكنك إضافة العمليات التي تريدها هنا على أساس التغييرات في الحقل
                  },
                )
              : TextFormField(
                  controller: controller,
                  readOnly: !isEditMode, // Set readOnly based on edit mode
                  onTap: onTap,
                  decoration: InputDecoration(
                    filled: true,
                    fillColor: Colors.grey[100],
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(35),
                    ),
                    suffixIcon: labelText == "..."
                        ? Icon(
                            Icons.calendar_today,
                            color: Colors.grey[500],
                          )
                        : null,
                  ),
                  style: const TextStyle(
                    fontWeight: FontWeight.bold, // تجعل النص داخل الحقل bold
                  ),
                ),
    );
  }

  Widget buildGenderDropdown() {
    return Padding(
      padding: const EdgeInsets.only(bottom: 35.0),
      child: DropdownButtonFormField<String>(
        value: selectedGender,
        onChanged: isEditMode
            ? (value) {
                setState(() {
                  selectedGender = value;
                });
              }
            : null, // Disable onChanged outside edit mode
        decoration: InputDecoration(
          filled: true,
          fillColor: Colors.grey[100],
          labelText: "",
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(35),
          ),
        ),
        items: ["Male", "Female"].map((String gender) {
          return DropdownMenuItem<String>(
            value: gender,
            child: Text(gender),
          );
        }).toList(),
      ),
    );
  }

  Future<void> _saveProfile() async {
    // Prepare the request body
    Map<String, dynamic> requestBody = {
      "name": fullNameController.text,
      "phone": phoneNumberController.text,
      "gender": selectedGender,
      "DOB": dobController.text,
      // You can add 'image' field here if needed
    };

    // Prepare the headers
    Map<String, String> headers = {
      "Authorization": "Bearer ${widget.token}",
      "Accept": "application/json",
      "Content-Type": "application/json",
    };

    // Make the HTTP POST request to update the profile
    http.Response response = await http.post(
      Uri.parse(
          "https://mental-health-ef371ab8b1fd.herokuapp.com/api/user/update_profile"),
      headers: headers,
      body: json.encode(requestBody),
    );

    // Parse the response
    if (response.statusCode == 200) {
      // Successful update
      // Fetch the latest profile data from the API
      await _fetchProfileData();
      // You can display a success message or perform any other actions here
    } else {
      // Error occurred
      print("Error: ${response.body}");
      // You can display an error message to the user
      // or handle the error in any appropriate way for your app
    }
  }

  Future<void> _selectDate(BuildContext context) async {
    if (!isEditMode) return; // Exit if not in edit mode

    final DateTime? pickedDate = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(1900),
      lastDate: DateTime.now(),
    );
    if (pickedDate != null) {
      setState(() {
        dobController.text =
            "${pickedDate.day}/${pickedDate.month}/${pickedDate.year}";
      });
    }
  }

  Future<void> _pickImage() async {
    final pickedFile =
        await ImagePicker().getImage(source: ImageSource.gallery);
    if (pickedFile != null) {
      setState(() {
        _selectedImage = File(pickedFile.path);
      });
    }
  }
}
