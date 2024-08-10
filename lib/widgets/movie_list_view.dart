import 'package:flutter/material.dart';
import '../data/models/movie_model.dart';
import '../screens/movie_detail.dart';

class MovieListView extends StatelessWidget {
  final ScrollController? scrollController;
  final List<Movie> movies;
  final bool isLoading;
  final Function? fetchMoreMovies;

  const MovieListView({
    super.key,
    this.scrollController,
    required this.movies,
    this.isLoading = false,
    this.fetchMoreMovies,
  });

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      controller: scrollController,
      itemCount: movies.length + (isLoading ? 1 : 0),
      itemBuilder: (context, index) {
        if (index == movies.length) {
          return isLoading ? const 
          Center(
            child: CircularProgressIndicator(color: Colors.black)) : Container();
        }

        final movie = movies[index];
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
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(9.0), 
                    child: Image.network(
                      'https://image.tmdb.org/t/p/w500${movie.posterPath}',
                      fit: BoxFit.cover,
                      width: 50.0,
                      height: 60.0,
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
                    Text(
                      'Rating: $voteAverage',
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
