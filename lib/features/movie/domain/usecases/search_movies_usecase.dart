import 'package:movie_app/core/error/result.dart';
import 'package:movie_app/core/error/failure.dart';
import 'package:movie_app/core/usecases/usecase.dart';
import '../../data/models/movie.dart';
import '../repositories/i_movie_repository.dart';

/// Parâmetros para busca de filmes.
class SearchMoviesParams {
  final String query;
  final int page;

  const SearchMoviesParams({
    required this.query,
    this.page = 1,
  });
}

/// UseCase para pesquisar filmes na API.
/// 
/// Implementa validação de entrada e busca paginada
/// retornando Result<List<Movie>> para tratamento type-safe.
class SearchMoviesUseCase implements UseCase<List<Movie>, SearchMoviesParams> {
  final IMovieRepository repository;

  const SearchMoviesUseCase(this.repository);

  @override
  Future<Result<List<Movie>>> call(SearchMoviesParams params) async {
    // Validação de entrada
    final trimmedQuery = params.query.trim();
    
    if (trimmedQuery.isEmpty) {
      return const Error(ValidationFailure(message: 'Query de pesquisa não pode estar vazia'));
    }

    if (trimmedQuery.length < 2) {
      return const Error(ValidationFailure(message: 'Query deve ter pelo menos 2 caracteres'));
    }

    if (params.page < 1) {
      return const Error(ValidationFailure(message: 'Página deve ser maior que 0'));
    }

    // Executa a busca
    return await repository.searchMovies(
      query: trimmedQuery,
      page: params.page,
    );
  }
}
