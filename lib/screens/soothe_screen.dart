import 'package:flutter/material.dart';
import 'package:mapfeature_project/helper/constants.dart';
import 'package:mapfeature_project/widgets/customButton.dart';
import 'package:widget_and_text_animator/widget_and_text_animator.dart';

class sotheeScreen extends StatelessWidget {
  const sotheeScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: backgroundsoothe,
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
        ),
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              TextAnimator(
                "HI , I'm Ozey",
                style: TextStyle(
                  fontSize: 35,
                  fontFamily: AlegreyaFont,
                  fontWeight: FontWeight.w900,
                  color: labelColor,
                  letterSpacing: 2.0, // Adjust letter spacing
                  wordSpacing: 5.0,
                ),
                incomingEffect:
                    WidgetTransitionEffects.incomingSlideInFromBottom(
                  curve: Curves.bounceOut,
                  duration: const Duration(milliseconds: 1500),
                ),
                atRestEffect: WidgetRestingEffects.wave(),
                outgoingEffect:
                    WidgetTransitionEffects.outgoingSlideOutToRight(),
              ),
              const SizedBox(
                height: 20,
              ),

              WidgetAnimator(
                incomingEffect:
                    WidgetTransitionEffects.incomingSlideInFromBottom(),
                child: Image.asset(
                  'images/photo_2024-01-17_04-14-54-removebg-preview.png',
                  height: 300,
                ),
              ),
              // const SizedBox(
              //   height: 20,
              // ),
              CustomButton(
                text: 'Get Started',
                onTap: () {
                  Navigator.pushReplacementNamed(context, 'login');
                },
              ),
              const SizedBox(
                height: 10,
              ),
              const Text(
                'Everyday Therapy in your hands',
                style: TextStyle(
                  fontWeight: FontWeight.w700,
                  fontFamily: latoFont,
                  color: Color(0xff1F5D6B),
                  fontSize: 15.5,
                ),
              ),
              const SizedBox(
                height: 8,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Text(
                    "Don't have an account?",
                    style: TextStyle(
                        fontWeight: FontWeight.w700,
                        fontFamily: latoFont,
                        color: Color.fromARGB(255, 136, 136, 136)),
                  ),
                  GestureDetector(
                    onTap: () {
                      Navigator.pushNamed(context, 'signup');
                    },
                    child: const Text(
                      ' Sign up',
                      style: TextStyle(
                        fontWeight: FontWeight.w900,
                        fontFamily: latoFont,
                        color: Color(0xff1F5D6B),
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
