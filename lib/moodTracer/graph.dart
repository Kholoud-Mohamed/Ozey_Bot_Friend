import 'package:flutter/material.dart';

class MoodGraph extends StatelessWidget {
  final Map<String, List<double>> moodData;
  final double selectedMoodPercentage;

  MoodGraph({
    required this.moodData,
    required this.selectedMoodPercentage,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 15.0, horizontal: 10),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          _buildDayColumn(
              'Mon', moodData['Mon'] != null ? moodData['Mon']![0] : 0.0),
          _buildDayColumn(
              'Tue', moodData['Tue'] != null ? moodData['Tue']![0] : 0.0),
          _buildDayColumn(
              'Wed', moodData['Wed'] != null ? moodData['Wed']![0] : 0.0),
          _buildDayColumn(
              'Thu', moodData['Thu'] != null ? moodData['Thu']![0] : 0.0),
          _buildDayColumn(
              'Fri', moodData['Fri'] != null ? moodData['Fri']![0] : 0.0),
          _buildDayColumn(
              'Sat', moodData['Sat'] != null ? moodData['Sat']![0] : 0.0),
          _buildDayColumn(
              'Sun', moodData['Sun'] != null ? moodData['Sun']![0] : 0.0),
        ],
      ),
    );
  }

  Widget _buildDayColumn(String day, double moodPercentage) {
    final double maxHeight = 120.0;
    bool isCurrentDay = _isCurrentDay(day);

    return Column(
      children: [
        Container(
          width: 20.0,
          height: maxHeight,
          decoration: BoxDecoration(
            borderRadius: const BorderRadius.all(Radius.circular(55)),
            border: Border.all(color: Colors.grey),
          ),
          child: Stack(
            alignment: Alignment.bottomCenter,
            children: [
              Container(
                height: maxHeight * (1 - moodPercentage),
                color: Colors.grey.withOpacity(0.2),
              ),
              if (isCurrentDay)
                Positioned(
                  bottom: 0,
                  child: Padding(
                    padding: const EdgeInsets.all(0.3),
                    child: Container(
                      height: maxHeight *
                          selectedMoodPercentage, // Use selectedMoodPercentage
                      width: 15,
                      decoration: BoxDecoration(
                        borderRadius:
                            const BorderRadius.all(Radius.circular(70)),
                        color: _getColorForMood(moodPercentage),
                      ),
                    ),
                  ),
                )
              else
                Positioned(
                  bottom: 0,
                  child: Container(
                    decoration: BoxDecoration(
                      color: _getColorForMood(selectedMoodPercentage),
                      borderRadius: const BorderRadius.all(Radius.circular(70)),
                    ),
                    height: maxHeight * moodPercentage,
                    width: 15,
                  ),
                ),
            ],
          ),
        ),
        const SizedBox(height: 5.0),
        Text(
          day,
          style: const TextStyle(
            fontSize: 14.0,
          ),
        ),
      ],
    );
  }

  Color _getColorForMood(double moodPercentage) {
    if (moodPercentage == 0.1) {
      return const Color.fromARGB(255, 158, 195, 214);
    } else if (moodPercentage == 0.75) {
      return const Color.fromARGB(255, 200, 207, 218).withAlpha(200);
    } else if (moodPercentage == 0.50) {
      return const Color.fromARGB(255, 190, 194, 194);
    } else if (moodPercentage == 0.25) {
      return const Color.fromARGB(255, 186, 221, 238);
    } else {
      return const Color.fromARGB(255, 184, 199, 210);
    }
  }

  bool _isCurrentDay(String day) {
    DateTime now = DateTime.now();
    String currentDay = _getDayName(now.weekday);
    return currentDay == day;
  }

  String _getDayName(int dayIndex) {
    switch (dayIndex) {
      case 1:
        return 'Mon';
      case 2:
        return 'Tue';
      case 3:
        return 'Wed';
      case 4:
        return 'Thu';
      case 5:
        return 'Fri';
      case 6:
        return 'Sat';
      case 7:
        return 'Sun';
      default:
        return '';
    }
  }
}
