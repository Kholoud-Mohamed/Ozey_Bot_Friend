import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:mapfeature_project/movies/movieconst.dart';
import 'moviesmodel.dart';

const apiKey = "e65d3d95be7d1f9a6e3c1e4dcc60cb57";

class Api {
  final upComingApiUrl =
      "https://api.themoviedb.org/3/movie/upcoming?api_key=$apiKey";
  final popularApiUrl =
      "https://api.themoviedb.org/3/movie/popular?api_key=$apiKey";
  final topRatedApiUrl =
      "https://api.themoviedb.org/3/movie/top_rated?api_key=$apiKey";

  Future<List<Movie>> getUpcomingMovies() async {
    final response = await http.get(Uri.parse(upComingApiUrl));

    if (response.statusCode == 200) {
      final List<dynamic> data = json.decode(response.body)['results'];

      List<Movie> movies = data.map((movie) => Movie.fromMap(movie)).toList();
      return movies;
    } else {
      throw Exception('Failed to load upcoming movies');
    }
  }

  Future<List<Movie>> getPopularMovies() async {
    final response = await http.get(Uri.parse(popularApiUrl));

    if (response.statusCode == 200) {
      final List<dynamic> data = json.decode(response.body)['results'];

      List<Movie> movies = data.map((movie) => Movie.fromMap(movie)).toList();
      return movies;
    } else {
      throw Exception('Failed to load popular movies');
    }
  }

  Future<List<Movie>> getTopRatedMovies() async {
    final response = await http.get(Uri.parse(topRatedApiUrl));

    if (response.statusCode == 200) {
      final List<dynamic> data = json.decode(response.body)['results'];

      List<Movie> movies = data.map((movie) => Movie.fromMap(movie)).toList();
      return movies;
    } else {
      throw Exception('Failed to load top rated movies');
    }
  }

  Future<MovieDetails> getMovieDetails(int movieId) async {
    final response = await http.get(
      Uri.parse("https://api.themoviedb.org/3/movie/$movieId?api_key=$apiKey"),
    );

    if (response.statusCode == 200) {
      final Map<String, dynamic> data = json.decode(response.body);
      return MovieDetails.fromMap(data);
    } else {
      throw Exception('Failed to load movie details');
    }
  }

  Future<String> getMovieVideoKey(int movieId) async {
    final response = await http.get(
      Uri.parse(
          "https://api.themoviedb.org/3/movie/$movieId/videos?api_key=$apiKey"),
    );

    if (response.statusCode == 200) {
      final List<dynamic> data = json.decode(response.body)['results'];
      if (data.isNotEmpty) {
        return data[0]['key'];
      } else {
        throw Exception('No video found for this movie');
      }
    } else {
      throw Exception('Failed to load movie video');
    }
  }
}
