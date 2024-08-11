class Movie {
  final int? id;
  final String title;
  final String posterPath;
  final String? backdropPath;
  final String releaseDate;
  final String overview;
  final double voteAverage;

  Movie(
      {required this.title,
      required this.posterPath,
      required this.backdropPath,
      required this.releaseDate,
      required this.id,
      required this.overview,
      required this.voteAverage});

  factory Movie.fromJson(Map<String, dynamic> json) {
    return Movie(
      id: json['id'],
      title: json['title'],
      posterPath: json['poster_path'],
      backdropPath: json['backdrop_path'],
      releaseDate: json['release_date'],
      overview: json['overview'],
      voteAverage: double.parse((json['vote_average']).toStringAsFixed(1)),
    );
  }
}
