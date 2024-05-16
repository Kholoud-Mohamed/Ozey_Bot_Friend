// HOMEScreen file
import 'dart:convert';
import 'package:flutter/cupertino.dart';
import 'package:flutter/widgets.dart';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:mapfeature_project/helper/constants.dart';
import 'package:mapfeature_project/moodTracer/mood_selector.dart';
import 'package:mapfeature_project/moodTracer/sentiment.dart';
import 'package:mapfeature_project/screens/ChatScreen.dart';
import 'package:mapfeature_project/moodTracer/graph.dart';
import 'package:mapfeature_project/widgets/decoration.dart';

class HOMEScreen extends StatefulWidget {
  final String userId;
  final List<SentimentRecording> moodRecordings;
  final Function(SentimentRecording) onMoodSelected;
  final double selectedMoodPercentage;
  final String token;
  final String? email;
  final String? username;
  final String? name;

  HOMEScreen({
    required this.userId,
    required this.moodRecordings,
    required this.onMoodSelected,
    required this.selectedMoodPercentage,
    required this.token,
    this.email,
    this.username,
    this.name,
  });

  @override
  _HOMEScreenState createState() => _HOMEScreenState();
}

class _HOMEScreenState extends State<HOMEScreen> {
  late Map<String, List<double>> moodData;
  late DateTime selectedDate; // Define selectedDate

  @override
  void initState() {
    super.initState();
    userName = widget.name ?? "";
    moodData = {};
    loadMoodData();
    selectedDate = DateTime.now();
  }

  void loadMoodData() async {
    final url =
        'https://mental-health-ef371ab8b1fd.herokuapp.com/api/user_moods/${widget.userId}';

    final response = await http.get(
      Uri.parse(url),
      headers: {
        'Accept': 'application/json',
        'Authorization': 'Bearer ${widget.token}',
      },
    );

    if (response.statusCode == 200) {
      final List<dynamic> moodList = jsonDecode(response.body);

      // Clear existing mood data
      moodData.clear();

      // Parse mood data and update moodData map
      moodList.forEach((mood) {
        final DateTime date = DateTime.parse(mood['date']);
        final String day = DateFormat('E').format(date);
        final double moodValue =
            mood['value'] / 4.0; // Normalize mood value to percentage

        moodData.update(day, (value) => [moodValue],
            ifAbsent: () => [moodValue]);
      });

      if (mounted) {
        // Check if the widget is still mounted before calling setState
        setState(() {});
      }
    } else {
      print('Failed to load mood data. Status code: ${response.statusCode}');
    }
  }

  String userName = '';
  double selectedMoodPercentage = 0.0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: ListView(
        padding: const EdgeInsets.only(top: 0),
        children: [
          Padding(
            padding: const EdgeInsets.all(0),
            child: Stack(
              children: [
                Padding(
                  padding: const EdgeInsets.only(left: 0),
                  child: Padding(
                    padding: const EdgeInsets.only(left: 25.0),
                    child: Card(
                      elevation: 6.0,
                      shape: const ContinuousRectangleBorder(
                        borderRadius: BorderRadius.only(
                          bottomLeft: Radius.circular(100),
                          // topLeft: Radius.circular(100),
                        ),
                      ),
                      color: primaryColor,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          Padding(
                            padding: const EdgeInsets.only(
                              left: 30.0,
                              top: 20.0,
                            ),
                            child: Padding(
                              padding: const EdgeInsets.only(left: 120),
                              child: Image.asset(
                                'images/photo_2024-01-17_04-23-53-removebg-preview.png',
                                width: 160.0,
                                height: 290.0,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
                Positioned(
                  top: 175,
                  left: 60,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Hello $userName,',
                        style: const TextStyle(
                            fontWeight: FontWeight.w900,
                            fontSize: 18.0,
                            fontFamily: interFont, //inter
                            color: Colors.white),
                      ),
                      const Text(
                        'How are you feeling today ? ',
                        style: TextStyle(
                            fontWeight: FontWeight.w900,
                            fontSize: 13,
                            fontFamily: interFont, //inter
                            color: Colors.white),
                      ),
                    ],
                  ),
                ),
                const Padding(
                  padding: EdgeInsets.only(top: 70, left: 5),
                  child: decoration(),
                ),
                Positioned(
                  top: 250,
                  left: 12,
                  child: MoodSelector(
                    token: widget.token,
                    userId: widget.userId,
                    onSelected: widget.onMoodSelected,
                    updateSelectedMood:
                        _updateSelectedMood, // Pass the callback here
                  ),
                ),
                Positioned(
                  top: 350,
                  left: 20,
                  // padding: const EdgeInsets.all(8.0),
                  child: Row(
                    children: [
                      _labelText('Mood Insights'),
                      Padding(
                        padding: const EdgeInsets.only(left: 90.0),
                        child: ElevatedButton(
                          onPressed: () {
                            //navigation
                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor:
                                const Color.fromARGB(255, 233, 240, 241),
                            padding: const EdgeInsets.symmetric(
                                horizontal: 10, vertical: 2),
                            textStyle: const TextStyle(fontSize: 16),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(20),
                            ),
                          ),
                          child: Text(
                            'View Report',
                            style: TextStyle(
                                color: fontGray,
                                fontFamily: interFont,
                                fontSize: 10,
                                fontWeight: FontWeight.w800),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(top: 400, right: 20, left: 20),
                  child: MoodGraph(
                    moodData: moodData,
                    selectedMoodPercentage: selectedMoodPercentage,
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(top: 580, right: 10, left: 10),
                  child: _buildFeatureList(),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _labelText(String labelText) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Text(
        labelText,
        style: const TextStyle(
          fontWeight: FontWeight.w900,
          fontSize: 17.0,
          fontFamily: interFont,
          color: Color(0xff1F5D6B),
        ),
      ),
    );
  }

  Widget _buildFeatureList() {
    return Padding(
      padding: const EdgeInsets.all(5.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _labelText('AI Friend'),
          GestureDetector(
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => ChatBot(
                    userId: widget.userId,
                    userName: userName,
                  ),
                ),
              );
            },
            child: Card(
              elevation: 5,
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(20)),
              color: secodaryColor,
              child: Row(
                children: [
                  Padding(
                    padding: const EdgeInsets.only(
                        left: 10, right: 6, top: 10, bottom: 4),
                    child: Image.asset(
                      'images/photo_2024-01-17_04-14-54-removebg-preview.png',
                      width: 100,
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(top: 70.0),
                    child: Text(
                      'How was your Day ?',
                      style: TextStyle(
                        fontFamily: interFont,
                        fontSize: 18,
                        fontWeight: FontWeight.w800,
                        color: fontGray,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 15),
          _labelText('SELF TEST'),
          GestureDetector(
            onTap: () {
              Navigator.pushNamed(context, 'test');
            },
            child: Card(
              elevation: 5,
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(20)),
              color: primaryColor,
              child: Row(
                children: [
                  const Padding(
                    padding: EdgeInsets.only(left: 15, top: 70.0),
                    child: Text(
                      'Beck Depression Test',
                      style: TextStyle(
                          fontFamily: interFont,
                          fontSize: 17,
                          fontWeight: FontWeight.w800,
                          color: Colors.white),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(
                        left: 0, right: 3, top: 0, bottom: 0),
                    child: Image.asset(
                      'images/photo_2024-01-18_02-56-42-removebg-preview.png',
                      width: 120,
                      height: 160,
                    ),
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 15),
          _labelText('SELF CARE KIT'),
          GestureDetector(
            onTap: () {
              Navigator.pushNamed(context, 'recommendation');
            },
            child: Card(
              elevation: 5,
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(20)),
              color: secodaryColor,
              child: Row(
                children: [
                  Padding(
                    padding: const EdgeInsets.only(left: 15, top: 5, bottom: 4),
                    child: Image.asset(
                      'images/photo_2024-01-18_02-56-32-removebg-preview.png',
                      width: 100,
                      height: 150,
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(top: 30.0, left: 30),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          '100+',
                          style: TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.w800,
                            fontFamily: interFont,
                            color: fontGray,
                          ),
                        ),
                        Text(
                          'Recommendations',
                          style: TextStyle(
                            fontFamily: interFont,
                            fontSize: 17,
                            fontWeight: FontWeight.bold,
                            color: fontGray,
                          ),
                        ),
                        Text(
                          'To Ease Your Mind',
                          style: TextStyle(
                            fontFamily: interFont,
                            fontSize: 17,
                            fontWeight: FontWeight.w800,
                            color: fontGray,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 15),
          _labelText('TIME KEEPER'),
          GestureDetector(
            onTap: () {
              Navigator.pushNamed(context, 'Todo');
            },
            child: Card(
              elevation: 5,
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(20)),
              color: primaryColor,
              child: Row(
                children: [
                  const Padding(
                    padding: EdgeInsets.only(top: 30.0, left: 20),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Time Table Companion',
                          style: TextStyle(
                              fontFamily: interFont,
                              fontSize: 17,
                              fontWeight: FontWeight.w800,
                              color: Colors.white),
                        ),
                      ],
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(left: 15, top: 5, bottom: 4),
                    child: Image.asset(
                      "images/photo_2024-01-18_05-46-33-removebg-preview.png",
                      width: 90,
                      height: 150,
                    ),
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(
            height: 5,
          )
        ],
      ),
    );
  }

  int _getMoodValue(double moodPercentage) {
    if (moodPercentage == 1.0) {
      return 4;
    } else if (moodPercentage == 0.75) {
      return 3;
    } else if (moodPercentage == 0.5) {
      return 2;
    } else if (moodPercentage == 0.25) {
      return 1;
    } else {
      return 0;
    }
  }

  void _postMood(String userId, double moodPercentage) async {
    final url =
        'https://mental-health-ef371ab8b1fd.herokuapp.com/api/store_mood';

    // Format the current date and time
    final now = DateTime.now();
    final formattedDate = DateFormat('yyyy/MM/dd HH:mm').format(now);

    final moodValue = _getMoodValue(moodPercentage);

    final body = jsonEncode({
      "user_id": userId,
      "value": moodValue,
      "date": formattedDate,
    });

    final response = await http.post(
      Uri.parse(url),
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer ${widget.token}', // Include the token here
      },
      body: body,
    );

    if (response.statusCode == 200) {
      final responseData = jsonDecode(response.body);
      if (responseData['message'] == 'Mood has been added') {
        print('Mood has been successfully added.');
      } else {
        print('Failed to add mood: ${responseData['message']}');
      }
    } else {
      print('Failed to add mood. Status code: ${response.statusCode}');
    }
  }

  void _updateSelectedMood(double moodPercentage) {
    setState(() {
      selectedMoodPercentage = moodPercentage;
    });
    _postMood(widget.userId, moodPercentage);
  }
}
