import 'package:movie_app/core/error/result.dart';
import '../../data/models/movie.dart';

/// Interface abstrata para repositório de filmes.
/// 
/// Define contratos para operações de filmes seguindo
/// os princípios da Clean Architecture.
abstract class IMovieRepository {
  /// Busca filmes em cartaz.
  Future<Result<List<Movie>>> getNowPlayingMovies({int page = 1});

  /// Pesquisa filmes por query.
  Future<Result<List<Movie>>> searchMovies({
    required String query,
    int page = 1,
  });

  /// Obtém detalhes de um filme específico.
  Future<Result<Movie>> getMovieDetails(int movieId);
}
