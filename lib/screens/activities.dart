import 'package:flutter/material.dart';
import 'package:mapfeature_project/helper/constants.dart';

class HeadlineText extends StatelessWidget {
  final String text;

  const HeadlineText({Key? key, required this.text}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Text(
        text,
        style: const TextStyle(fontSize: 20),
      ),
    );
  }
}

class HintText extends StatelessWidget {
  final String text;

  const HintText({Key? key, required this.text}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Text(
      text,
      style: const TextStyle(
        fontFamily: 'Langar',
        fontSize: 10,
        color: Color.fromARGB(255, 177, 180, 180),
      ),
    );
  }
}

class RecommendationsScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color.fromARGB(255, 244, 242, 242),
      appBar: AppBar(
        backgroundColor: const Color.fromARGB(255, 244, 242, 242),
        automaticallyImplyLeading: false,
        title: const Text(
          'Recommendations',
          style: TextStyle(
            fontSize: 22,
            fontFamily: AlegreyaFont,
            color: Color(0xff1F5D6B),
            fontWeight: FontWeight.w900,
          ),
        ),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Text(
              'What would you like to do today?',
              style: TextStyle(
                fontFamily: AlegreyaFont,
                fontSize: 16,
                fontWeight: FontWeight.w800,
                color: fontGray,
              ),
            ),
            const SizedBox(height: 10),
            Expanded(
              child: GestureDetector(
                onTap: () {
                  Navigator.pushNamed(context, 'movies');
                },
                child: Card(
                  elevation: 5,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Container(
                    width: double.infinity,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(20),
                      gradient: LinearGradient(
                        colors: gradientcard,
                        begin: Alignment.topCenter,
                        end: Alignment.bottomCenter,
                      ),
                    ),
                    child: Row(
                      children: [
                        const Padding(
                          padding: EdgeInsets.all(15),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text(
                                'Movies Time',
                                style: TextStyle(
                                  fontFamily: AlegreyaFont,
                                  fontSize: 18,
                                  fontWeight: FontWeight.w800,
                                  color: Colors.white,
                                ),
                              ),
                              SizedBox(height: 10),
                              HintText(
                                text: 'Movies have a positive impact on',
                              ),
                              HintText(
                                text:
                                    ' mental health by providing stress relief',
                              ),
                              HintText(
                                text:
                                    ' and fostering empathy through escapism.',
                              ),
                            ],
                          ),
                        ),
                        Expanded(
                          child: Padding(
                            padding: const EdgeInsets.all(0),
                            child: Image.asset(
                              'images/photo_2024-04-09_00-18-58-removebg-preview.png',
                              fit: BoxFit.cover,
                              // width: 80,
                              height: 100,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
            const SizedBox(height: 10),
            Expanded(
              child: GestureDetector(
                onTap: () {
                  Navigator.pushNamed(context, 'music');
                },
                child: Card(
                  elevation: 5,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Container(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(20),
                      gradient: LinearGradient(
                        colors: gradientcard,
                        begin: Alignment.topCenter,
                        end: Alignment.bottomCenter,
                      ),
                    ),
                    child: Row(
                      children: [
                        const Padding(
                          padding: EdgeInsets.all(15),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text(
                                'Listen to Music',
                                style: TextStyle(
                                  fontFamily: AlegreyaFont,
                                  fontSize: 18,
                                  fontWeight: FontWeight.w800,
                                  color: Colors.white,
                                ),
                              ),
                              SizedBox(height: 10),
                              HintText(
                                text: 'Music gives a soul to the universe',
                              ),
                              HintText(
                                text: ' wings to the mind,flight to the ',
                              ),
                              HintText(
                                text: 'imagination and life to everything. ',
                              ),
                            ],
                          ),
                        ),
                        Expanded(
                          child: Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Image.asset(
                              'images/photo_2024-04-09_00-35-23-removebg-preview (1).png',
                              fit: BoxFit.cover,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
            const SizedBox(height: 10),
            Expanded(
              child: GestureDetector(
                onTap: () {
                  Navigator.pushNamed(context, 'QCategory');
                },
                child: Card(
                  elevation: 5,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Container(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(20),
                      gradient: LinearGradient(
                        colors: gradientcard,
                        begin: Alignment.topCenter,
                        end: Alignment.bottomCenter,
                      ),
                    ),
                    child: Row(
                      children: [
                        const Padding(
                          padding: EdgeInsets.all(15),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text(
                                'Find Your Quotes',
                                style: TextStyle(
                                  fontFamily: AlegreyaFont,
                                  fontSize: 18,
                                  fontWeight: FontWeight.w800,
                                  color: Colors.white,
                                ),
                              ),
                              SizedBox(height: 10),
                              HintText(
                                text: 'Quotes are like windows.',
                              ),
                              HintText(
                                text: 'They open up new views of the world.',
                              ),
                            ],
                          ),
                        ),
                        Expanded(
                          child: Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Image.asset(
                              'images/photo_2024-04-09_00-35-11-removebg-preview (1).png',
                              fit: BoxFit.cover,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
