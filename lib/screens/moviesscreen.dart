import 'package:flutter/material.dart';
import 'package:mapfeature_project/helper/constants.dart';
import 'package:mapfeature_project/movies/api.dart';
import 'package:mapfeature_project/movies/moviesmodel.dart';
import 'package:mapfeature_project/screens/MovieDetailsScreen.dart';
import 'package:carousel_slider/carousel_slider.dart';

class MoviesScreen extends StatefulWidget {
  const MoviesScreen({Key? key}) : super(key: key);

  @override
  State<MoviesScreen> createState() => _MoviesScreenState();
}

class _MoviesScreenState extends State<MoviesScreen> {
  late Future<List<Movie>> upcomingMovies;
  late Future<List<Movie>> popularMovies;
  late Future<List<Movie>> topRatedMovies;

  @override
  void initState() {
    upcomingMovies = Api().getUpcomingMovies();
    popularMovies = Api().getPopularMovies();
    topRatedMovies = Api().getTopRatedMovies();
    super.initState();
  }

  void openMovieDetails(BuildContext context, int movieId) async {
    try {
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => MovieDetailsScreen(
            movieId: movieId,
          ),
        ),
      );
    } catch (e) {
      print('Error opening movie details: $e');
    }
  }

  Widget _labelText(String labelText) {
    return Padding(
      padding: const EdgeInsets.only(left: 12.0),
      child: Text(
        labelText,
        style: const TextStyle(
          fontWeight: FontWeight.w900,
          fontSize: 20.0,
          fontFamily: AlegreyaFont,
          color: Color(0xff1F5D6B),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color.fromARGB(255, 244, 242, 242),
      appBar: AppBar(
        backgroundColor: const Color.fromARGB(255, 244, 242, 242),
        automaticallyImplyLeading: false,
        title: const Text(
          "Movies",
          style: TextStyle(
            fontSize: 25,
            fontFamily: AlegreyaFont,
            color: Color(0xff1F5D6B),
            fontWeight: FontWeight.w900,
          ),
        ),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(6.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _labelText('Upcoming'),
              //Carousel
              FutureBuilder<List<Movie>>(
                future: upcomingMovies,
                builder: (context, AsyncSnapshot<List<Movie>> snapshot) {
                  if (!snapshot.hasData) {
                    return const Center(
                      child: CircularProgressIndicator(),
                    );
                  }
                  final List<Movie> movies = snapshot.data!;

                  return CarouselSlider.builder(
                    itemCount: movies.length,
                    itemBuilder: (context, index, movieIndex) {
                      final Movie movie = movies[index];
                      return GestureDetector(
                        onTap: () => openMovieDetails(context, movie.id),
                        child: Container(
                          width: double.infinity,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: Image.network(
                            movie.bannerUrl,
                          ),
                        ),
                      );
                    },
                    options: CarouselOptions(
                      autoPlay: true,
                      enlargeCenterPage: true,
                      aspectRatio: 1.4,
                      autoPlayInterval: const Duration(seconds: 3),
                    ),
                  );
                },
              ),

              _labelText('Popular'),
              Container(
                margin: const EdgeInsets.symmetric(vertical: 20),
                height: 250,
                child: FutureBuilder<List<Movie>>(
                  future: popularMovies,
                  builder: (context, AsyncSnapshot<List<Movie>> snapshot) {
                    if (!snapshot.hasData) {
                      return const Center(
                        child: CircularProgressIndicator(),
                      );
                    }
                    final List<Movie> movies = snapshot.data!;
                    return ListView.builder(
                      scrollDirection: Axis.horizontal,
                      itemCount: movies.length,
                      itemBuilder: (context, index) {
                        final Movie movie = movies[index];
                        return GestureDetector(
                          onTap: () => openMovieDetails(context, movie.id),
                          child: Container(
                            width: 150,
                            margin: const EdgeInsets.symmetric(horizontal: 10),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                Container(
                                  height: 180,
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(15),
                                    image: DecorationImage(
                                      image: NetworkImage(movie.posterUrl),
                                      fit: BoxFit.cover,
                                    ),
                                  ),
                                ),
                                const SizedBox(height: 10),
                                Text(
                                  movie.title,
                                  textAlign: TextAlign.center,
                                  style: const TextStyle(
                                    color: Color(0xff1F5D6B),
                                    fontSize: 16,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        );
                      },
                    );
                  },
                ),
              ),

              _labelText('Top Rated'),
              Container(
                margin: const EdgeInsets.symmetric(vertical: 20),
                height: 250,
                child: FutureBuilder<List<Movie>>(
                  future: topRatedMovies,
                  builder: (context, AsyncSnapshot<List<Movie>> snapshot) {
                    if (!snapshot.hasData) {
                      return const Center(
                        child: CircularProgressIndicator(),
                      );
                    }
                    final List<Movie> movies = snapshot.data!;
                    return ListView.builder(
                      scrollDirection: Axis.horizontal,
                      itemCount: movies.length,
                      itemBuilder: (context, index) {
                        final Movie movie = movies[index];
                        return GestureDetector(
                          onTap: () => openMovieDetails(context, movie.id),
                          child: Container(
                            width: 150,
                            margin: const EdgeInsets.symmetric(horizontal: 10),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                Container(
                                  height: 180,
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(15),
                                    image: DecorationImage(
                                      image: NetworkImage(movie.posterUrl),
                                      fit: BoxFit.cover,
                                    ),
                                  ),
                                ),
                                const SizedBox(height: 10),
                                Text(
                                  movie.title,
                                  textAlign: TextAlign.center,
                                  style: const TextStyle(
                                    color: Color(0xff1F5D6B),
                                    fontSize: 16,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        );
                      },
                    );
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
