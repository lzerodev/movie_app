import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:movie_app/services/movie_controller.dart';
import '../data/models/movie_model.dart';
import '../screens/movie_detail.dart';

class MovieListView extends StatefulWidget {
  final MovieController? movieController;
  final List<Movie> movies;
  final bool isLoading;
  
  const MovieListView({
    super.key,
    this.movieController, 
    required this.movies, 
    required this.isLoading, 
  });

  @override
  // ignore: library_private_types_in_public_api
  _MovieListViewState createState() => _MovieListViewState();
}

class _MovieListViewState extends State<MovieListView> {

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      controller: ScrollController(),
      itemCount: widget.movies.length + (widget.isLoading ? 1 : 0),
      itemBuilder: (context, index) {
        if (index == widget.movies.length) {
          return widget.isLoading
              ? const Padding(
                  padding: EdgeInsets.symmetric(vertical: 250),
                  child: Center(
                    child: CircularProgressIndicator(color: Colors.black),
                  ),
                )
              : Container();
        }

        final movie = widget.movies[index];
        final voteAverage = movie.voteAverage;
        final releaseDate = DateFormat.yMMMd('pt_BR').format(movie.releaseDate);

        return Padding(
          padding: const EdgeInsets.symmetric(vertical: 3.0, horizontal: 3.0),
          child: Material(
            type: MaterialType.canvas,
            elevation: 2.0,
            borderRadius: BorderRadius.circular(8.0),
            child: Container(
              padding:
                  const EdgeInsets.symmetric(vertical: 1.0, horizontal: 1.0),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(8.0),
                color: Colors.white,
              ),
              child: ListTile(
                hoverColor: Colors.black,
                minLeadingWidth: 90,
                leading: ConstrainedBox(
                  constraints: const BoxConstraints(
                      maxHeight: double.infinity, maxWidth: double.infinity),
                  child: Hero(
                    tag: 'movie_${movie.id}',
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(9.0),
                      child: Image.network(
                        cacheWidth: 100,
                        'https://image.tmdb.org/t/p/w500${movie.posterPath}',
                        fit: BoxFit.cover,
                        width: 100.0,
                        errorBuilder: (context, error, stackTrace) {
                          return const Icon(Icons.error, color: Colors.red);
                        },
                      ),
                    ),
                  ),
                ),
                title: ConstrainedBox(
                  constraints: const BoxConstraints(
                      maxWidth: double.infinity, maxHeight: double.infinity),
                  child: Text(
                    movie.title,
                    style: const TextStyle(
                      fontFamily: 'Poppins',
                      fontSize: 14.0,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                subtitle: ConstrainedBox(
                  constraints: const BoxConstraints(
                      maxHeight: 20, maxWidth: double.infinity),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'Release: $releaseDate',
                        style: const TextStyle(
                          fontFamily: 'Poppins',
                          fontSize: 10.0,
                          fontWeight: FontWeight.normal,
                        ),
                      ),
                    ],
                  ),
                ),
                trailing: ConstrainedBox(
                  constraints:
                      const BoxConstraints(maxHeight: 50, maxWidth: 50),
                  child: Row(
                    children: [
                      const Icon(Icons.star, color: Colors.amber, size: 24.0),
                      const SizedBox(width: 5),
                      Text(
                        '$voteAverage',
                        style: const TextStyle(
                          fontFamily: 'Poppins',
                          fontSize: 12.0,
                          fontWeight: FontWeight.bold,
                          color: Colors.grey,
                        ),
                      ),
                    ],
                  ),
                ),
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => MovieDetailPage(movie: movie),
                    ),
                  );
                },
              ),
            ),
          ),
        );
      },
    );
  }
}
