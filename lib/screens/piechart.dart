import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';

import 'indicator.dart';

class PieChartSample1 extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => PieChartSample1State();
}

class PieChartSample1State extends State<PieChartSample1> {
  int touchedIndex = -1;
  double completed = 80;
  double inprogress = 65;
  double non_completed = 60;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFFF1F5F4),
      body: Padding(
        padding: EdgeInsets.all(60),
        child: Column(
          children: [
            ConstrainedBox(
              constraints: BoxConstraints(
                  maxHeight: MediaQuery.of(context).size.height * 0.2),
              child: AspectRatio(
                aspectRatio: 1,
                child: PieChart(
                  PieChartData(
                    startDegreeOffset: 180,
                    borderData: FlBorderData(show: true),
                    sectionsSpace: 12,
                    centerSpaceRadius: 36,
                    sections: showingSections(),
                  ),
                ),
              ),
            ),
            SizedBox(height: 31),
            Row(children: [
              // مسافة بين العناصر
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: <Widget>[
                  Indicator(
                    key: UniqueKey(),
                    color: const Color(0xFF9CAFB3),
                    text: 'Completed',
                    isSquare: false,
                    size: touchedIndex == 0 ? 18 : 16,
                    textColor: touchedIndex == 0 ? Colors.black : Colors.grey,
                  ),
                  Indicator(
                    key: UniqueKey(),
                    color: const Color(0xFFBCA5C6),
                    text: 'In Progress',
                    isSquare: false,
                    size: touchedIndex == 1 ? 18 : 16,
                    textColor: touchedIndex == 1 ? Colors.black : Colors.grey,
                  ),
                  Indicator(
                    key: UniqueKey(),
                    color: const Color(0xFFBAA9E9),
                    text: 'Non Completed',
                    isSquare: false,
                    size: touchedIndex == 2 ? 18 : 16,
                    textColor: touchedIndex == 2 ? Colors.black : Colors.grey,
                  ),
                ],
              ),
              SizedBox(
                width: 55,
              ),
              Column(
                mainAxisAlignment:
                    MainAxisAlignment.end, // يبدأ من نهاية العمود
                crossAxisAlignment:
                    CrossAxisAlignment.end, // يبدأ من بداية السطر
                children: <Widget>[
                  Text('$completed',
                      style: TextStyle(fontSize: 16, color: Colors.grey)),
                  Text('$inprogress',
                      style: TextStyle(fontSize: 16, color: Colors.grey)),
                  Text('$non_completed',
                      style: TextStyle(fontSize: 16, color: Colors.grey)),
                ],
              ),
            ])
          ],
        ),
      ),
    );
  }

  List<PieChartSectionData> showingSections() {
    return List.generate(
      4,
      (i) {
        final isTouched = i == touchedIndex;
        final double opacity = isTouched ? 1 : 0.6;
        switch (i) {
          case 0:
            return PieChartSectionData(
              color: const Color(0xFF9CAFB3).withOpacity(opacity),
              value: 25,
              title: '$completed',
              radius: completed,
              titleStyle: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
              titlePositionPercentageOffset: 0.55,
            );
          case 1:
            return PieChartSectionData(
              color: const Color(0xFFBCA5C6).withOpacity(opacity),
              value: 25,
              title: '$inprogress',
              radius: inprogress,
              titleStyle: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
              titlePositionPercentageOffset: 0.55,
            );
          case 2:
            return PieChartSectionData(
              color: const Color(0xFFBAA9E9).withOpacity(opacity),
              value: 25,
              title: '$non_completed',
              radius: non_completed,
              titleStyle: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
              titlePositionPercentageOffset: 0.6,
            );
          default:
            return PieChartSectionData(
              color: Colors.transparent,
              value: 0,
            );
        }
      },
    );
  }
}
