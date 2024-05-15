import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';

class ExpenseGraphDesign extends StatefulWidget {
  final bool isLeftPressed1;

  const ExpenseGraphDesign({Key? key, required this.isLeftPressed1})
      : super(key: key);

  @override
  State<ExpenseGraphDesign> createState() => _ExpenseGraphDesignState();
}

class _ExpenseGraphDesignState extends State<ExpenseGraphDesign> {
  late List<FlSpot> spots;

  List<FlSpot> _get30DaysSpots() {
    // Implementation for 30 days spots
    return [
      FlSpot(1, 4),
      FlSpot(2, 2),
      FlSpot(3, 6),
      FlSpot(4, 1),
      FlSpot(5, 7),
    ];
  }

  List<FlSpot> _get7DaysSpots() {
    // Implementation for 7 days spots
    return [
      FlSpot(1, 3),
      FlSpot(2, 5),
      FlSpot(3, 4),
      FlSpot(4, 2),
      FlSpot(5, 6),
    ];
  }

  @override
  void initState() {
    super.initState();
    spots = widget.isLeftPressed1 ? _get30DaysSpots() : _get7DaysSpots();
  }

  @override
  void didUpdateWidget(covariant ExpenseGraphDesign oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.isLeftPressed1 != widget.isLeftPressed1) {
      setState(() {
        spots = widget.isLeftPressed1 ? _get30DaysSpots() : _get7DaysSpots();
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Expanded(
          child: Stack(
            children: [
              LineChart(
                LineChartData(
                  minX: 1,
                  maxX: 5,
                  minY: 0,
                  maxY: 7,
                  lineBarsData: [
                    LineChartBarData(
                      spots: spots,
                      isCurved: true,
                      gradient: const LinearGradient(
                        colors: [Color(0xFF8CBAB1), Color(0xff6f958e)],
                      ),
                      barWidth: 3,
                      belowBarData: BarAreaData(
                        show: true,
                        gradient: LinearGradient(
                          colors: [
                            Color(0xFF418675).withOpacity(.2),
                            Color(0xffAEDCD5).withOpacity(.2),
                            Color(0xffFFFFFF).withOpacity(.2),
                          ],
                        ),
                      ),
                      dotData: FlDotData(show: false),
                    ),
                  ],
                  gridData: FlGridData(
                    show: true,
                    drawHorizontalLine: false,
                    drawVerticalLine: true,
                    getDrawingVerticalLine: (value) {
                      return FlLine(
                        color: Colors.white,
                        strokeWidth: 0.8,
                      );
                    },
                  ),
                  titlesData: FlTitlesData(
                    leftTitles: AxisTitles(
                      sideTitles: SideTitles(showTitles: false),
                    ),
                    rightTitles: AxisTitles(
                      sideTitles: SideTitles(showTitles: false),
                    ),
                    topTitles: AxisTitles(
                      sideTitles: SideTitles(showTitles: false),
                    ),
                    bottomTitles: AxisTitles(
                      sideTitles: SideTitles(
                        showTitles: true,
                        reservedSize: 12,
                        getTitlesWidget: (value, meta) {
                          String text = '';
                          switch (value.toInt()) {
                            case 1:
                              text = "1";
                              break;
                            case 2:
                              text = "2";
                              break;
                            case 3:
                              text = "3";
                              break;
                            case 4:
                              text = "4";
                              break;
                            case 5:
                              text = "5";
                              break;
                            default:
                              return Container();
                          }
                          return Text(
                            text,
                            style: const TextStyle(
                              color: Colors.white,
                              fontSize: 10,
                            ),
                          );
                        },
                      ),
                    ),
                  ),
                ),
              ),
              Positioned(
                bottom: 0,
                left: 0,
                right: 0,
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Row(
                    children: const [
                      Padding(
                        padding: EdgeInsets.only(left: 0),
                        child: Icon(
                          Icons.sentiment_very_satisfied,
                          color: Color(0xFF8CBAB1),
                          size: 30,
                        ),
                      ),
                      SizedBox(width: 38),
                      Icon(
                        Icons.sentiment_satisfied,
                        color: Color(0xFF8CBAB1),
                        size: 30,
                      ),
                      SizedBox(width: 68),
                      Icon(
                        Icons.sentiment_neutral,
                        color: Color(0xFF8CBAB1),
                        size: 30,
                      ),
                      SizedBox(width: 64),
                      Icon(
                        Icons.sentiment_dissatisfied,
                        color: Color(0xFF8CBAB1),
                        size: 30,
                      ),
                      SizedBox(width: 45),
                      Icon(
                        Icons.sentiment_very_dissatisfied,
                        color: Color(0xFF8CBAB1),
                        size: 30,
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
