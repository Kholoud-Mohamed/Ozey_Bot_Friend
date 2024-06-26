import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:mapfeature_project/helper/constants.dart';

class MovieReviews extends StatefulWidget {
  const MovieReviews({
    Key? key,
    required this.movieID,
  }) : super(key: key);
  final String movieID;

  @override
  State<MovieReviews> createState() => _MovieReviewsState();
}

class _MovieReviewsState extends State<MovieReviews>
    with TickerProviderStateMixin {
  List movieReviews = [];
  late AnimationController controller;

  Future<void> _getMovieReviews() async {
    final url = Uri.parse(
        'https://api.themoviedb.org/3/movie/${widget.movieID}/reviews?api_key=e65d3d95be7d1f9a6e3c1e4dcc60cb57');
    final response = await http.get(url);

    if (mounted) {
      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        setState(() {
          movieReviews = data['results'];
        });
      } else {
        throw Exception('Failed to load reviews.');
      }
    }
  }

  @override
  void initState() {
    super.initState();
    _getMovieReviews();
    controller = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 5),
    )..addListener(() {
        setState(() {});
      });
    controller.repeat(reverse: true);
  }

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    CircularProgressIndicator(value: controller.value);
    if (movieReviews.isEmpty) {
      return const Center(
        child: Text(
          'No reviews to display',
          style: TextStyle(color: CupertinoColors.systemOrange),
        ),
      );
    } else {
      return Scaffold(
        backgroundColor: Color.fromARGB(255, 220, 223, 225),
        body: ListView.separated(
          itemCount: movieReviews.length,
          itemBuilder: (BuildContext context, index) {
            return ListTile(
              leading: Container(
                width: 50,
                height: 50,
                alignment: Alignment.topLeft,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(20),
                  image: DecorationImage(
                    image: (movieReviews[index]['author_details']['avatar_path'] !=
                                null &&
                            (Uri.parse(movieReviews[index]['author_details']['avatar_path'].substring(1, movieReviews[index]['author_details']['avatar_path'].length))
                                    .isAbsolute) !=
                                true)
                        ? NetworkImage(
                            'https://image.tmdb.org/t/p/original/${movieReviews[index]['author_details']['avatar_path']}')
                        : (movieReviews[index]['author_details']['avatar_path'] !=
                                        null &&
                                    Uri.parse(movieReviews[index]['author_details']['avatar_path'].substring(1, movieReviews[index]['author_details']['avatar_path'].length))
                                        .isAbsolute) !=
                                false
                            ? NetworkImage(movieReviews[index]['author_details']
                                    ['avatar_path']
                                .substring(
                                    1, movieReviews[index]['author_details']['avatar_path'].length))
                            : const AssetImage('assets/images/avatar_unavailable.png') as ImageProvider,
                    fit: BoxFit.fill,
                  ),
                ),
              ),
              title: Text(
                movieReviews[index]['content'],
                style: const TextStyle(
                    fontSize: 13,
                    fontWeight: FontWeight.w700,
                    fontFamily: AlegreyaFont),
                maxLines: 5,
                overflow: TextOverflow.ellipsis,
              ),
              subtitle: Text(
                movieReviews[index]['author'],
                style: const TextStyle(fontSize: 13),
              ),
            );
          },
          separatorBuilder: (BuildContext context, int index) {
            return const Divider();
          },
        ),
      );
    }
  }
}
