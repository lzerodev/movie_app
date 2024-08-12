import 'package:flutter/material.dart';
import '../data/models/movie_model.dart';
import '../screens/movie_detail.dart';

class MovieListView extends StatefulWidget {
  final ScrollController? scrollController;
  final List<Movie> movies;
  final bool isLoading;
  final Future<void> Function()? fetchMoreMovies;

  const MovieListView({
    super.key,
    this.scrollController,
    required this.movies,
    this.isLoading = false,
    this.fetchMoreMovies,
  });

  @override
  // ignore: library_private_types_in_public_api
  _MovieListViewState createState() => _MovieListViewState();
}

class _MovieListViewState extends State<MovieListView> {
  @override
  void initState() {
    super.initState();

    // Adiciona o listener de scroll caso o scrollController não seja nulo
    if (widget.scrollController != null) {
      widget.scrollController!.addListener(_scrollListener);
    }
  }

  @override
  void dispose() {
    // Remove o listener de scroll ao descartar o widget para evitar vazamentos de memória
    if (widget.scrollController != null) {
      widget.scrollController!.removeListener(_scrollListener);
    }
    super.dispose();
  }

  void _scrollListener() {
    if (widget.scrollController != null &&
        widget.scrollController!.position.pixels >=
            widget.scrollController!.position.maxScrollExtent - 50 &&
        widget.fetchMoreMovies != null &&
        !widget.isLoading) {
      widget.fetchMoreMovies!();
    }
  }

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      controller: widget.scrollController,
      itemCount: widget.movies.length + (widget.isLoading ? 1 : 0),
      itemBuilder: (context, index) {
        if (index == widget.movies.length) {
          return widget.isLoading
              ? const Center(
                  child: CircularProgressIndicator(color: Colors.black),
                )
              : Container();
        }

        final movie = widget.movies[index];
        final voteAverage = movie.voteAverage;
        final releaseDate = movie.releaseDate;

        return Padding(
          padding: const EdgeInsets.symmetric(vertical: 5.0, horizontal: 10.0),
          child: Material(
            elevation: 5.0,
            borderRadius: BorderRadius.circular(8.0),
            child: Container(
              padding: const EdgeInsets.symmetric(vertical: 5.0, horizontal: 5.0),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(8.0),
                color: Colors.white,
              ),
              child: ListTile(
                leading: Container(
                  width: 70.0,
                  height: 90.0,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(15.0),
                    color: Colors.white,
                  ),
                  child: Hero(
                    tag: 'movie_${movie.id}',
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(9.0),
                      child: Image.network(
                        'https://image.tmdb.org/t/p/w500${movie.posterPath}',
                        fit: BoxFit.cover,
                        width: 50.0,
                        height: 60.0,
                        errorBuilder: (context, error, stackTrace) {
                          return const Icon(Icons.error, color: Colors.red);
                        },
                      ),
                    ),
                  ),
                ),
                title: Text(
                  movie.title,
                  style: const TextStyle(
                    fontFamily: 'Poppins',
                    fontSize: 14.0,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                subtitle: Row(
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
                    const SizedBox(width: 50),
                    const Icon(Icons.star, color: Colors.amber, size: 24.0),
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
