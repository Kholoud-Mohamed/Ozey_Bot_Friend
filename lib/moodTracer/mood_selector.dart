import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'sentiment.dart';

class MoodSelector extends StatefulWidget {
  final String userId;

  final Function(SentimentRecording) onSelected;
  final void Function(double) updateSelectedMood;
  final String token;

  const MoodSelector({
    Key? key,
    required this.token,
    required this.onSelected,
    required this.updateSelectedMood,
    required this.userId,
  }) : super(key: key);

  @override
  createState() => new MoodSelectorState(
        onSelected,
        updateSelectedMood,
      );
}

class MoodSelectorState extends State<MoodSelector> {
  var timeFormatter = new DateFormat('jm');
  var dayFormatter = new DateFormat('MMMd');
  DateTime selectedDate = DateTime.now();

  final ValueSetter<SentimentRecording> onSelected;
  final void Function(double) updateSelectedMood;

  MoodSelectorState(this.onSelected, this.updateSelectedMood);

  double selectedMoodPercentage = 0.0;

  void _handleSentiment(Sentiment sentiment) async {
    double moodPercentage = 0.0;

    if (sentiment == Sentiment.veryHappy) {
      moodPercentage = 1.0;
    } else if (sentiment == Sentiment.happy) {
      moodPercentage = 0.75;
    } else if (sentiment == Sentiment.neutral) {
      moodPercentage = 0.5;
    } else if (sentiment == Sentiment.unhappy) {
      moodPercentage = 0.25;
    } else if (sentiment == Sentiment.veryUnhappy) {
      moodPercentage = 0.1;
    }

    // Save mood data to api
    _postMood(widget.userId, moodPercentage);

    // Update selected mood percentage and notify listeners
    setState(() {
      selectedMoodPercentage = moodPercentage;
    });

    widget.updateSelectedMood(selectedMoodPercentage);

    final recording = SentimentRecording(
      sentiment,
      DateTime.now(),
      activities: ['activity1', 'activity2'],
    );

    widget.onSelected(recording);
  }

  @override
  Widget build(BuildContext context) {
    return new Card(
      shape: const ContinuousRectangleBorder(
        borderRadius: BorderRadius.only(
          bottomLeft: Radius.circular(50),
          bottomRight: Radius.circular(50),
          topLeft: Radius.circular(50),
          topRight: Radius.circular(50),
        ),
      ),
      color: Color(0xffEFF5F7),
      child: Padding(
        padding: const EdgeInsets.all(1.0),
        child: Column(
          children: [
            ButtonBar(
              children: <Widget>[
                Padding(
                  padding: const EdgeInsets.only(left: 3, right: 10),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      IconButton(
                        onPressed: () => _handleSentiment(Sentiment.veryHappy),
                        icon: const Icon(Icons.sentiment_very_satisfied),
                        iconSize: 40.0,
                        color: Colors.blueGrey,
                      ),
                      IconButton(
                        onPressed: () => _handleSentiment(Sentiment.happy),
                        icon: const Icon(Icons.sentiment_satisfied),
                        iconSize: 40.0,
                        color: Colors.blueGrey,
                      ),
                      IconButton(
                        onPressed: () => _handleSentiment(Sentiment.neutral),
                        icon: const Icon(Icons.sentiment_neutral),
                        iconSize: 40.0,
                        color: Colors.blueGrey,
                      ),
                      IconButton(
                        onPressed: () => _handleSentiment(Sentiment.unhappy),
                        icon: const Icon(Icons.sentiment_dissatisfied),
                        iconSize: 40.0,
                        color: Colors.blueGrey,
                      ),
                      IconButton(
                        onPressed: () =>
                            _handleSentiment(Sentiment.veryUnhappy),
                        icon: const Icon(Icons.sentiment_very_dissatisfied),
                        iconSize: 40.0,
                        color: Colors.blueGrey,
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ],
        ),
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
}
