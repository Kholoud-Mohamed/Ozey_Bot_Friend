import 'package:flutter/material.dart';
import 'package:syncfusion_flutter_charts/charts.dart';

import 'indicator.dart';

class Donought extends StatefulWidget {
  const Donought({Key? key}) : super(key: key);

  @override
  State<Donought> createState() => _DonoughtState();
}

class _DonoughtState extends State<Donought> {
  double completed = 25;
  double inprogress = 38;
  double non_completed = 34;
  double average = 0;
  final List<ChartData> chartData = [
    ChartData('A', 25, Color(0xff9CAFB3)),
    ChartData('B', 38, Color(0xFFBCA5C6)),
    ChartData('C', 34, Color(0xFFBAA9E9)),
  ];
  @override
  void initState() {
    super.initState();
    calculateAverage();
  }

  void calculateAverage() {
    setState(() {
      average = (completed + non_completed + inprogress) / 3;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[200],
      body: Column(
        children: [
          Stack(
            children: [
              Container(
                width: double.infinity,
                height: MediaQuery.of(context).size.width * 0.8,
                child: SfCircularChart(
                  series: <CircularSeries>[
                    DoughnutSeries<ChartData, String>(
                      dataSource: chartData,
                      xValueMapper: (ChartData data, _) => data.label,
                      yValueMapper: (ChartData data, _) => data.y,
                      pointColorMapper: (ChartData data, _) => data.color,
                      explode: true,
                      explodeAll: true,
                      dataLabelSettings: DataLabelSettings(
                        isVisible: true,
                        labelPosition: ChartDataLabelPosition.outside,
                        textStyle: TextStyle(fontSize: 18),
                      ),
                    )
                  ],
                  annotations: <CircularChartAnnotation>[
                    CircularChartAnnotation(
                        height: '100%',
                        width: '100%',
                        widget: PhysicalModel(
                          shape: BoxShape.circle,
                          elevation: 10,
                          color: const Color.fromRGBO(230, 230, 230, 1),
                          child: Container(),
                        )),
                    CircularChartAnnotation(
                      widget: Text(
                        '       ${average.toStringAsFixed(2)}\nAverage range',
                        style: TextStyle(
                            color: Color.fromRGBO(0, 0, 0, 0.5),
                            fontSize: 18,
                            fontWeight: FontWeight.bold),
                      ),
                    ),
                  ],
                ),
              ),
              SizedBox(
                height: 30,
              ),
            ],
          ),
          SizedBox(height: 0),
          Row(
            children: [
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
                  ),
                  Indicator(
                    key: UniqueKey(),
                    color: const Color(0xFFBCA5C6),
                    text: 'In Progress',
                    isSquare: false,
                  ),
                  Indicator(
                    key: UniqueKey(),
                    color: const Color(0xFFBAA9E9),
                    text: 'Non Completed',
                    isSquare: false,
                  ),
                ],
              ),
              SizedBox(
                width: 55,
              ),
              Column(
                mainAxisAlignment: MainAxisAlignment.end,
                crossAxisAlignment: CrossAxisAlignment.end,
                children: <Widget>[
                  Text('$completed',
                      style: TextStyle(fontSize: 16, color: Colors.grey)),
                  Text('$inprogress',
                      style: TextStyle(fontSize: 16, color: Colors.grey)),
                  Text('$non_completed',
                      style: TextStyle(fontSize: 16, color: Colors.grey)),
                ],
              ),
            ],
          )
        ],
      ),
    );
  }
}

class ChartData {
  ChartData(this.label, this.y, this.color);
  final String label;
  final double y;
  final Color color;
}
