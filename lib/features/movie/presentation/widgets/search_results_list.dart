import 'package:flutter/material.dart';
import 'package:movie_app/features/movie/presentation/widgets/movie_list_item.dart';

import '../../data/models/movie.dart';

class SearchResultsList extends StatelessWidget {
  final List<Movie> movies;

  const SearchResultsList({
    super.key,
    required this.movies,
  });

  @override
  Widget build(BuildContext context) {
    if (movies.isEmpty) {
      return const Center(
        child: Text(
          'Nenhum filme encontrado.',
          style: TextStyle(
            fontFamily: 'Poppins',
            fontSize: 16,
            color: Colors.grey,
          ),
        ),
      );
    }

    return ListView.builder(
      itemCount: movies.length,
      itemBuilder: (BuildContext context, int index) {
        return Padding(
          padding: const EdgeInsets.symmetric(
            vertical: 3.0,
            horizontal: 3.0,
          ),
          child: Material(
            type: MaterialType.canvas,
            elevation: 2.0,
            borderRadius: BorderRadius.circular(8.0),
            child: Container(
              padding: const EdgeInsets.symmetric(
                vertical: 1.0,
                horizontal: 1.0,
              ),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(8.0),
                color: Colors.white,
              ),
              child: MovieListItem(movie: movies[index]),
            ),
          ),
        );
      },
    );
  }
}
