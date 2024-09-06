import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../../data/models/movie.dart';
import '../pages/movie_detail.dart';

class MovieListItem extends StatelessWidget {
  const MovieListItem({required this.movie, super.key});

  final Movie movie;
                      
  @override
  Widget build(BuildContext context) {
    
    final voteAverage = movie.voteAverage;
    final releaseDate = DateFormat.yMMMd('pt_BR').format(movie.releaseDate);

    return Material(
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
          constraints:
              const BoxConstraints(maxHeight: 20, maxWidth: double.infinity),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Lançamento: $releaseDate',
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
          constraints: const BoxConstraints(maxHeight: 50, maxWidth: 50),
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
              builder: (context) =>
                  MovieDetailPage(movie: movie),
            ),
          );
        },
      ),
    );
  }
}
