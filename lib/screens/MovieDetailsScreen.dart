import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:mapfeature_project/helper/constants.dart';
import 'package:mapfeature_project/movies/moviesmodel.dart';
import 'package:mapfeature_project/movies/api.dart';
import 'package:mapfeature_project/movies/reviews.dart';
import 'package:youtube_player_flutter/youtube_player_flutter.dart';

class MovieDetailsScreen extends StatefulWidget {
  final int movieId;

  const MovieDetailsScreen({Key? key, required this.movieId}) : super(key: key);

  @override
  _MovieDetailsScreenState createState() => _MovieDetailsScreenState();
}

class _MovieDetailsScreenState extends State<MovieDetailsScreen>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;
  late Future<MovieDetails> _futureMovieDetails;

  @override
  void initState() {
    _tabController = TabController(vsync: this, length: 2);
    _futureMovieDetails = Api().getMovieDetails(widget.movieId);
    super.initState();
  }

  Future<void> _showMovieTrailer(BuildContext context) async {
    try {
      final String videoKey = await Api().getMovieVideoKey(widget.movieId);
      if (videoKey.isNotEmpty) {
        // Show the trailer in an alert dialog
        showDialog(
          context: context,
          builder: (BuildContext context) {
            return AlertDialog(
              contentPadding: EdgeInsets.zero,
              insetPadding: const EdgeInsets.all(10),
              backgroundColor: Colors.transparent,
              content: YoutubePlayer(
                controller: YoutubePlayerController(
                  initialVideoId: videoKey,
                  flags: const YoutubePlayerFlags(
                    autoPlay: true,
                    mute: false,
                  ),
                ),
                showVideoProgressIndicator: true,
                bottomActions: [
                  CurrentPosition(),
                  ProgressBar(
                    isExpanded: true,
                    colors: const ProgressBarColors(
                      playedColor: Colors.orange,
                      handleColor: Colors.orangeAccent,
                    ),
                  ),
                  const PlaybackSpeedButton(),
                  FullScreenButton(),
                ],
              ),
              actions: <Widget>[
                TextButton(
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                  child: const Text(
                    'Close',
                    style: TextStyle(fontSize: 16, color: Colors.white),
                  ),
                ),
              ],
            );
          },
        );
      } else {
        // Show a snackbar if the trailer is not available
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Movie trailer not available'),
            backgroundColor: Colors.orange,
          ),
        );
      }
    } catch (e) {
      print('Error fetching movie trailer: $e');
      // Show a snackbar if an error occurs
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Failed to load movie trailer'),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color.fromARGB(255, 220, 223, 225),
      appBar: PreferredSize(
        preferredSize:
            const Size.fromHeight(70.0), // Adjust the height as needed
        child: AppBar(
          backgroundColor: Color.fromARGB(255, 220, 223, 225),
          automaticallyImplyLeading: false,
          title: FutureBuilder<MovieDetails>(
            future: _futureMovieDetails,
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return const Text(
                  'Loading...',
                  style: TextStyle(
                    fontSize: 25,
                    fontFamily: 'Alegreya',
                    color: Color(0xff1F5D6B),
                    fontWeight: FontWeight.bold,
                  ),
                );
              } else if (snapshot.hasError) {
                return const Text(
                  'Error',
                  style: TextStyle(
                    fontSize: 20,
                    fontFamily: 'Alegreya',
                    color: Color(0xff1F5D6B),
                    fontWeight: FontWeight.bold,
                  ),
                );
              } else {
                final movieDetails = snapshot.data!;
                return Text(
                  movieDetails.title,
                  style: const TextStyle(
                    fontSize: 20,
                    fontFamily: AlegreyaFont,
                    color: Color(0xff1F5D6B),
                    fontWeight: FontWeight.w900,
                  ),
                );
              }
            },
          ),
          centerTitle: true,
          bottom: TabBar(
            controller: _tabController,
            labelColor: const Color(0xff1F5D6B),
            labelStyle: const TextStyle(
              fontFamily: 'Alegreya',
              fontWeight: FontWeight.bold,
            ),
            indicatorColor: const Color(0xffA8C9CF),
            tabs: const [
              Tab(text: 'Description'),
              Tab(text: 'Reviews'),
            ],
          ),
        ),
      ),
      body: FutureBuilder<MovieDetails>(
        future: _futureMovieDetails,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          } else if (snapshot.hasError) {
            return Center(
              child: Text(
                'Error: ${snapshot.error}',
                style: const TextStyle(color: Colors.white),
              ),
            );
          } else {
            final movieDetails = snapshot.data!;
            return TabBarView(
              controller: _tabController,
              children: [
                SingleChildScrollView(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Stack(
                        alignment: Alignment.center,
                        children: [
                          Image.network(
                            movieDetails.posterUrl,
                            fit: BoxFit.cover,
                            width: double.infinity,
                            height: 450, // Adjust this height as needed
                          ),
                          GestureDetector(
                            onTap: () => _showMovieTrailer(context),
                            child: Container(
                              width: 80, // Adjust the width as needed
                              height: 80, // Adjust the height as needed
                              decoration: BoxDecoration(
                                color: Colors.red,
                                shape: BoxShape.circle,
                              ),
                              child: Icon(
                                Icons.play_arrow,
                                size:
                                    70, // Adjust the size of the icon as needed
                                color: Colors.white,
                              ),
                            ),
                          ),
                        ],
                      ),
                      Padding(
                        padding: const EdgeInsets.all(20.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const SizedBox(height: 10),
                            Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    'Overview:',
                                    style: TextStyle(
                                      fontSize: 22,
                                      fontWeight: FontWeight.w900,
                                      color: labelColor,
                                      fontFamily: AlegreyaFont,
                                    ),
                                  ),
                                  const SizedBox(height: 5),
                                  Text(
                                    movieDetails.overview,
                                    style: TextStyle(
                                      fontFamily: AlegreyaFont,
                                      fontWeight: FontWeight.w800,
                                      fontSize: 17,
                                      color: fontGray,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            const SizedBox(height: 10),
                            Row(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  'Genres:',
                                  style: TextStyle(
                                    fontSize: 20,
                                    fontWeight: FontWeight.w900,
                                    color: labelColor,
                                    fontFamily: AlegreyaFont,
                                  ),
                                ),
                                const SizedBox(width: 5),
                                Expanded(
                                  child: Text(
                                    movieDetails.genres.join(", "),
                                    style: TextStyle(
                                      fontFamily: AlegreyaFont,
                                      fontWeight: FontWeight.w800,
                                      fontSize: 17,
                                      color: fontGray,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: 10),
                            Row(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  'Duration:',
                                  style: TextStyle(
                                    fontSize: 20,
                                    fontWeight: FontWeight.w900,
                                    color: labelColor,
                                    fontFamily: AlegreyaFont,
                                  ),
                                ),
                                const SizedBox(width: 5),
                                Expanded(
                                  child: Text(
                                    movieDetails.duration,
                                    style: TextStyle(
                                      fontFamily: AlegreyaFont,
                                      fontWeight: FontWeight.w800,
                                      fontSize: 17,
                                      color: fontGray,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: 10),
                            Row(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  'Release Date:',
                                  style: TextStyle(
                                    fontSize: 20,
                                    fontWeight: FontWeight.w900,
                                    color: labelColor,
                                    fontFamily: AlegreyaFont,
                                  ),
                                ),
                                const SizedBox(width: 5),
                                Expanded(
                                  child: Text(
                                    movieDetails.releaseDate,
                                    style: TextStyle(
                                      fontFamily: AlegreyaFont,
                                      fontWeight: FontWeight.w800,
                                      fontSize: 17,
                                      color: fontGray,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: 10),
                            RatingBarIndicator(
                              rating: movieDetails.rating / 2,
                              itemBuilder: (context, _) => const Icon(
                                Icons.star,
                                color: Colors.amber,
                              ),
                              itemCount: 5,
                              itemSize: 30.0,
                              direction: Axis.horizontal,
                            ),
                            const SizedBox(height: 20),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
                MovieReviews(movieID: widget.movieId.toString()),
              ],
            );
          }
        },
      ),
    );
  }
}
