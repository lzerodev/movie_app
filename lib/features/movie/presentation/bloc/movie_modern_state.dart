part of 'movie_modern_bloc.dart';

/// Status possíveis para o MovieModernBloc
enum MovieModernStatus {
  initial,
  loading,
  success,
  failure,
}

/// Estado do MovieModernBloc
class MovieModernState extends Equatable {
  final MovieModernStatus status;
  final List<Movie> movies;
  final bool hasReachedMax;
  final String? errorMessage;
  final bool isSearchMode;
  final String? searchQuery;

  const MovieModernState({
    this.status = MovieModernStatus.initial,
    this.movies = const [],
    this.hasReachedMax = false,
    this.errorMessage,
    this.isSearchMode = false,
    this.searchQuery,
  });

  /// Cria uma cópia do estado com valores opcionais alterados
  MovieModernState copyWith({
    MovieModernStatus? status,
    List<Movie>? movies,
    bool? hasReachedMax,
    String? errorMessage,
    bool? isSearchMode,
    String? searchQuery,
  }) {
    return MovieModernState(
      status: status ?? this.status,
      movies: movies ?? this.movies,
      hasReachedMax: hasReachedMax ?? this.hasReachedMax,
      errorMessage: errorMessage,
      isSearchMode: isSearchMode ?? this.isSearchMode,
      searchQuery: searchQuery,
    );
  }

  @override
  List<Object?> get props => [
        status,
        movies,
        hasReachedMax,
        errorMessage,
        isSearchMode,
        searchQuery,
      ];
}
