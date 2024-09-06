part of 'movie_list_bloc.dart';

enum MovieListStatus { initial, sucess, failure }

final class MovieListState extends Equatable{
  const MovieListState({
    this.status = MovieListStatus.initial,
    this.movies = const <Movie>[],
    this.hasReachedMax = false,
  });

  final MovieListStatus status;
  final List<Movie> movies;
  final bool hasReachedMax;

  MovieListState copyWith({
    MovieListStatus? status,
    List<Movie>? movies,
    bool? hasReachedMax, 
  }) {
    return MovieListState(
      status: status ?? this.status,
      movies: movies ?? this.movies,
      hasReachedMax: hasReachedMax ?? this.hasReachedMax,
    );
  }

  @override
  String toString() {
    return '''MovieListState { status: $status, hasReachedMax: $hasReachedMax, movies: ${movies.length}}''';
  }

  @override
  List<Object?> get props => [status, movies, hasReachedMax];
}