class Movie {
  final int id;
  final String title;
  final String backDropPath;
  final String overview;
  final String posterPath;
  final String bannerUrl; // New field for banner URL
  final String posterUrl; // New field for poster URL

  Movie({
    required this.id,
    required this.title,
    required this.backDropPath,
    required this.overview,
    required this.posterPath,
    required this.bannerUrl,
    required this.posterUrl,
  });

  factory Movie.fromMap(Map<String, dynamic> map) {
    return Movie(
      id: map['id'],
      title: map['title'],
      backDropPath: map['backdrop_path'],
      overview: map['overview'],
      posterPath: map['poster_path'],
      bannerUrl: "https://image.tmdb.org/t/p/original/${map['backdrop_path']}",
      posterUrl: "https://image.tmdb.org/t/p/original/${map['poster_path']}",
    );
  }
}

class MovieDetails {
  final int id;
  final String title;
  final String overview;
  final String releaseDate;
  final String posterPath;
  final String bannerUrl;
  final List<String> genres;
  final double rating;
  final String duration;
  final String posterUrl; // Add posterUrl property
  // final String videoUrl;

  MovieDetails({
    required this.id,
    required this.title,
    required this.overview,
    required this.releaseDate,
    required this.posterPath,
    required this.bannerUrl,
    required this.genres,
    required this.rating,
    required this.duration,
    required this.posterUrl,
    // required this.videoUrl, // Initialize posterUrl property
  });

  factory MovieDetails.fromMap(Map<String, dynamic> map) {
    List<String> genres = [];
    if (map['genres'] != null) {
      genres = List<String>.from(map['genres'].map((genre) => genre['name']));
    }
    // // Extract the video URL from the API response
    // String videoUrl = "";
    // if (map['videos'] != null && map['videos']['results'] != null) {
    //   videoUrl =
    //       "https://www.youtube.com/watch?v=${map['videos']['results'][0]['key']}";
    // }

    return MovieDetails(
      id: map['id'],
      title: map['title'],
      overview: map['overview'],
      releaseDate: map['release_date'],
      posterPath: map['poster_path'],
      bannerUrl: "https://image.tmdb.org/t/p/original/${map['backdrop_path']}",
      genres: genres,
      rating: map['vote_average'].toDouble(),
      duration: '${map['runtime']} min',
      posterUrl: "https://image.tmdb.org/t/p/original/${map['poster_path']}",
      // videoUrl: videoUrl,
    );
  }
}
