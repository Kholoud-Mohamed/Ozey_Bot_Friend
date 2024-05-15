import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:mapfeature_project/screens/donught.dart';
import 'package:mapfeature_project/screens/line_chart.dart';
import 'package:mapfeature_project/screens/stacked.dart';
import 'package:percent_indicator/circular_percent_indicator.dart';

class Report extends StatefulWidget {
  const Report({Key? key}) : super(key: key);

  @override
  State<Report> createState() => _ReportState();
}

class _ReportState extends State<Report> {
  bool isLeftPressed1 = true;
  bool isLeftPressed2 = true;

  double _percent = 0.75;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Padding(
                padding: const EdgeInsets.fromLTRB(10, 10, 10, 5),
                child: Row(
                  children: [
                    IconButton(
                      icon: Icon(Icons.arrow_back),
                      onPressed: () {
                        Navigator.of(context).pop();
                      },
                    ),
                    SizedBox(width: 10),
                    Text(
                      "Your Monthly Report",
                      textAlign: TextAlign.center,
                      style:
                          TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
                    ),
                  ],
                ),
              ),
              SizedBox(height: 16),
              Container(
                height: 450,
                decoration: BoxDecoration(
                  color: Colors.grey[200],
                  borderRadius: BorderRadius.circular(25),
                ),
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        "Statistics",
                        style: TextStyle(color: Colors.grey, fontSize: 18),
                      ),
                      SizedBox(height: 1),
                      Row(
                        children: [
                          Text(
                            "Mood tracker",
                            style: TextStyle(
                                fontWeight: FontWeight.bold, fontSize: 20),
                          ),
                          SizedBox(width: 20),
                          Container(
                            height: 60,
                            width: 230,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(20),
                              color: Color(0xFFFDCE6E3),
                            ),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                SizedBox(width: 8),
                                GestureDetector(
                                  onTap: () {
                                    setState(() {
                                      isLeftPressed1 = true;
                                    });
                                  },
                                  child: Container(
                                    height: 40,
                                    width: 99,
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(20),
                                      color: isLeftPressed1
                                          ? Color(0xFFF2A5651)
                                          : Color(0xFFFDCE6E3),
                                    ),
                                    child: Center(
                                      child: Text(
                                        "30 days",
                                        style: TextStyle(
                                          color: Colors.white,
                                          fontWeight: FontWeight.bold,
                                          fontSize: 16,
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                                SizedBox(width: 8),
                                GestureDetector(
                                  onTap: () {
                                    setState(() {
                                      isLeftPressed1 = false;
                                    });
                                  },
                                  child: Container(
                                    height: 40,
                                    width: 96,
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(20),
                                      color: !isLeftPressed1
                                          ? Color(0xFFF2A5651)
                                          : Color(0xFFFDCE6E3),
                                    ),
                                    child: Center(
                                      child: Text(
                                        "7 days",
                                        style: TextStyle(
                                          color: Colors.white,
                                          fontWeight: FontWeight.bold,
                                          fontSize: 16,
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                                SizedBox(width: 8),
                              ],
                            ),
                          ),
                        ],
                      ),
                      SizedBox(height: 8),
                      Divider(
                        color: Colors.grey,
                      ),
                      SizedBox(height: 8),
                      Expanded(
                        child: ExpenseGraphDesign(
                          isLeftPressed1: isLeftPressed1,
                        ),
                      ),
                      SizedBox(height: 8),
                    ],
                  ),
                ),
              ),
              SizedBox(height: 18),
              Container(
                height: 310,
                color: Colors.grey[200],
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        "Statistics",
                        style: TextStyle(color: Colors.grey, fontSize: 18),
                      ),
                      SizedBox(height: 1),
                      Row(
                        children: [
                          Text(
                            "Monthly activity",
                            style: TextStyle(
                                fontWeight: FontWeight.bold, fontSize: 20),
                          ),
                          SizedBox(width: 20),
                          Container(
                            height: 60,
                            width: 200,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(20),
                              color: Color(0xFFFDCE6E3),
                            ),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                SizedBox(width: 8),
                                GestureDetector(
                                  onTap: () {
                                    setState(() {
                                      isLeftPressed2 = true;
                                      _percent = 0.75;
                                    });
                                  },
                                  child: Container(
                                    height: 40,
                                    width: 90,
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(20),
                                      color: isLeftPressed2
                                          ? Color(0xFFF2A5651)
                                          : Color(0xFFFDCE6E3),
                                    ),
                                    child: Center(
                                      child: Text(
                                        "30 days",
                                        style: TextStyle(
                                          color: Colors.white,
                                          fontWeight: FontWeight.bold,
                                          fontSize: 16,
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                                SizedBox(width: 6),
                                GestureDetector(
                                  onTap: () {
                                    setState(() {
                                      isLeftPressed2 = false;
                                      _percent = 0.85;
                                    });
                                  },
                                  child: Container(
                                    height: 40,
                                    width: 90,
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(20),
                                      color: !isLeftPressed2
                                          ? Color(0xFFF2A5651)
                                          : Color(0xFFFDCE6E3),
                                    ),
                                    child: Center(
                                      child: Text(
                                        "7 days",
                                        style: TextStyle(
                                          color: Colors.white,
                                          fontWeight: FontWeight.bold,
                                          fontSize: 16,
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                                SizedBox(width: 8),
                              ],
                            ),
                          ),
                        ],
                      ),
                      SizedBox(height: 8),
                      Divider(
                        color: Colors.grey,
                      ),
                      SizedBox(height: 30),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          CircularPercentIndicator(
                            radius: 100.0,
                            lineWidth: 20.0,
                            animationDuration: 1800,
                            percent: _percent,
                            arcType: ArcType.HALF,
                            circularStrokeCap: CircularStrokeCap.round,
                            backgroundColor: Colors.grey,
                            center: Text(
                              '   ${(_percent * 100).toInt()}%\n tasks',
                              style: TextStyle(
                                fontSize: 28,
                                color: Colors.grey,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            progressColor: Color(0xFF8CBAB1),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
              SizedBox(height: 20),
              Container(
                color: Colors.grey[200],
                height: 480,
                margin: EdgeInsets.symmetric(horizontal: 8),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        "Statistics",
                        style: TextStyle(color: Colors.grey, fontSize: 18),
                      ),
                      SizedBox(height: 1),
                      Text(
                        "Monthly activity",
                        style: TextStyle(
                            fontWeight: FontWeight.bold, fontSize: 20),
                      ),
                      SizedBox(height: 8),
                      Expanded(
                        child: Donought(),
                      ),

                      // Add your other widgets here
                    ],
                  ),
                ),
              ),
              SizedBox(height: 20),
              Container(
                color: Colors.grey[200],
                height: 460,
                margin: EdgeInsets.symmetric(horizontal: 8),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        "Statistics",
                        style: TextStyle(color: Colors.grey, fontSize: 18),
                      ),
                      SizedBox(height: 1),
                      Text(
                        "Test Activty",
                        style: TextStyle(
                            fontWeight: FontWeight.bold, fontSize: 20),
                      ),
                      SizedBox(height: 8),
                      Expanded(
                        child: Stack1(),
                      ),

                      // Add your other widgets here
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
