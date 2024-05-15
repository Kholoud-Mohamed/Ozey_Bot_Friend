import 'package:flutter/material.dart';
import 'package:mapfeature_project/helper/constants.dart';

class decoration extends StatelessWidget {
  const decoration({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 50,
      height: 150,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(50),
        color: Colors.white,
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          CircleAvatar(
            radius: 12,
            backgroundColor: labelColor,
            child: const CircleAvatar(
              radius: 9,
              backgroundColor: Colors.white,
            ),
          ),
          const CircleAvatar(
            radius: 12,
            backgroundColor: Color.fromARGB(255, 214, 235, 239),
            child: CircleAvatar(
              radius: 9,
              backgroundColor: Color(0xffC4DEE4),
            ),
          ),
          const CircleAvatar(
            radius: 12,
            backgroundColor: Color.fromARGB(255, 33, 99, 113),
          ),
        ],
      ),
    );
  }
}
