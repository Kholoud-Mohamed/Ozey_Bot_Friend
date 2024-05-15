import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class Description extends StatelessWidget {
  final String name, description, bannerurl, posterurl, vote, launch_on;

  const Description({
    required Key key,
    required this.name,
    required this.description,
    required this.bannerurl,
    required this.posterurl,
    required this.vote,
    required this.launch_on,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: Container(
        child: ListView(
          children: [
            Container(
              height: 250,
              child: Stack(
                children: [
                  Positioned(
                    child: Container(
                      height: 250,
                      width: MediaQuery.of(context).size.width,
                      child: Image.network(
                        bannerurl,
                        fit: BoxFit.cover,
                      ),
                    ),
                  ),
                  Positioned(
                    bottom: 10,
                    child: modified_text(
                      text: '⭐ Average Rating - $vote',
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(height: 15),
            Container(
              padding: EdgeInsets.all(10),
              child: modified_text(
                text: name != null ? name : 'Not Loaded',
                size: 24,
              ),
            ),
            Container(
              padding: EdgeInsets.only(left: 10),
              child: modified_text(
                text: 'Releasing On - $launch_on',
                size: 14,
              ),
            ),
            Row(
              children: [
                Container(
                  height: 200,
                  width: 100,
                  child: Image.network(posterurl),
                ),
                Flexible(
                  child: Container(
                    padding: EdgeInsets.all(10),
                    child: modified_text(
                      text: description,
                      size: 18,
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class modified_text extends StatelessWidget {
  final String text;
  final Color? color; // Make color nullable

  // Provide a default color value (black) if color is not provided
  final Color defaultColor = Colors.black;

  final double? size;

  const modified_text({
    Key? key,
    required this.text,
    this.color, // Make color nullable
    this.size,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // Use the color provided or use the default color if it's null
    final actualColor = color ?? defaultColor;

    return Text(
      text,
      style: GoogleFonts.roboto(color: actualColor, fontSize: size),
    );
  }
}
