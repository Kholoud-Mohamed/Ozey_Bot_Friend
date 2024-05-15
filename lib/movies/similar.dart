import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:mapfeature_project/movies/movieconst.dart';
import 'moviesmodel.dart';

class SimilarMovies extends StatefulWidget {
  const SimilarMovies({
    Key? key,
    required this.movieID,
  }) : super(key: key);
  final String movieID; // Update to String type

  @override
  State<SimilarMovies> createState() => _SimilarMoviesState();
}

class _SimilarMoviesState extends State<SimilarMovies> {
  List<Movie> similarMovies = [];

  Future<void> _getSimilarMovies() async {
    final response = await http.get(Uri.parse(
        "https://api.themoviedb.org/3/movie/${widget.movieID}/similar?api_key=$apiKey"));

    if (response.statusCode == 200) {
      final List<dynamic> data = json.decode(response.body)['results'];
      setState(() {
        similarMovies = data.map((movie) => Movie.fromMap(movie)).toList();
      });
    } else {
      throw Exception('Failed to load similar movies.');
    }
  }

  @override
  void initState() {
    super.initState();
    _getSimilarMovies();
  }

  @override
  Widget build(BuildContext context) {
    if (similarMovies.isEmpty) {
      return const Center(
        child: Text(
          'No similar movies to display',
          style: TextStyle(color: CupertinoColors.systemOrange),
        ),
      );
    } else {
      return Scaffold(
        body: GridView.builder(
          itemCount: similarMovies.length,
          padding: const EdgeInsets.all(20),
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            childAspectRatio: (120.0 / 185.0),
            crossAxisCount: 3,
            crossAxisSpacing: 10.0,
            mainAxisSpacing: 10.0,
          ),
          itemBuilder: (BuildContext context, int index) {
            return GestureDetector(
              onTap: () {
                // Handle movie tap
              },
              child: Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(20.0),
                  image: DecorationImage(
                    image: similarMovies[index].posterUrl != null
                        ? NetworkImage(similarMovies[index].posterUrl!)
                        : const AssetImage(
                                'assets/images/poster_unavailable.png')
                            as ImageProvider,
                    fit: BoxFit.cover,
                  ),
                ),
              ),
            );
          },
        ),
      );
    }
  }
}
