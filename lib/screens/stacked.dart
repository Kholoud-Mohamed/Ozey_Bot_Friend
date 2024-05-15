import 'package:mapfeature_project/screens/indicator.dart';
import 'package:syncfusion_flutter_charts/sparkcharts.dart';
import 'package:syncfusion_flutter_charts/sparkcharts.dart';
import 'package:flutter/material.dart';
import 'package:syncfusion_flutter_charts/charts.dart';

class Stack1 extends StatefulWidget {
  const Stack1({Key? key}) : super(key: key);

  @override
  State<Stack1> createState() => _Stack1State();
}

class _Stack1State extends State<Stack1> {
  final List<ChartData> chartData = [
    ChartData('day1', 35, 30),
    ChartData('day2', 30, 45),
    ChartData('day3', 55, 20),
    ChartData('day4', 16, 50),
  ];
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Colors.grey[200],
        body: Column(children: [
          Container(
              child: SfCartesianChart(
                  primaryXAxis: CategoryAxis(),
                  series: <CartesianSeries>[
                StackedColumnSeries<ChartData, String>(
                  dataSource: chartData,
                  xValueMapper: (ChartData data, _) => data.x,
                  yValueMapper: (ChartData data, _) => data.y1,
                  color: Color(0xFFBCA5C6).withOpacity(.75),
                ),
                StackedColumnSeries<ChartData, String>(
                  dataSource: chartData,
                  xValueMapper: (ChartData data, _) => data.x,
                  yValueMapper: (ChartData data, _) => data.y2,
                  color: Color(0xFFD9D9D9),
                ),
              ])),
          SizedBox(height: 2),
          Row(
            children: [
              // مسافة بين العناصر
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: <Widget>[
                  Indicator(
                    key: UniqueKey(),
                    color: const Color(0xFFBCA5C6).withOpacity(.75),
                    text: 'Cognitive-Affective Depressive ',
                    isSquare: false,
                  ),
                  Indicator(
                    key: UniqueKey(),
                    color: const Color(0xFFD9D9D9),
                    text: 'Somatic Depression',
                    isSquare: false,
                  ),
                ],
              ),
            ],
          )
        ]));
  }
}

class ChartData {
  final String x;
  final int y1;
  final int y2;

  ChartData(this.x, this.y1, this.y2);
}
