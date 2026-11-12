import 'package:equatable/equatable.dart';

final class Movie extends Equatable {
  const Movie(
      {required this.id,
      required this.title,
      required this.posterPath,
      required this.backdropPath,
      required this.releaseDate,
      required this.overview,
      required this.voteAverage});

  final int id;
  final String title;
  final String? posterPath;
  final String? backdropPath;
  final DateTime releaseDate;
  final String overview;
  final double voteAverage;

  @override
  List<Object?> get props =>
      [id, title, posterPath, backdropPath, releaseDate, overview, voteAverage];

  factory Movie.fromJson(Map<String, dynamic> json) {
    return Movie(
      id: json['id'] as int,
      title: json['title'] ?? 'Título Desconhecido',
      posterPath: json['poster_path'] as String?,
      backdropPath: json['backdrop_path'] as String?,
      releaseDate: DateTime.parse(json['release_date']),
      overview: json['overview'] ?? 'Sem descrição disponível',
      voteAverage: double.parse((json['vote_average']).toStringAsFixed(1)),
    );
  }
}
