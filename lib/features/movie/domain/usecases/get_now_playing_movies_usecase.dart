import 'package:movie_app/core/error/result.dart';
import 'package:movie_app/core/error/failure.dart';
import 'package:movie_app/core/usecases/usecase.dart';
import '../../data/models/movie.dart';
import '../repositories/i_movie_repository.dart';

/// Parâmetros para buscar filmes em cartaz.
class GetNowPlayingMoviesParams {
  final int page;

  const GetNowPlayingMoviesParams({
    this.page = 1,
  });
}

/// UseCase para buscar filmes em cartaz.
/// 
/// Retorna lista de filmes atualmente em exibição nos cinemas.
class GetNowPlayingMoviesUseCase implements UseCase<List<Movie>, GetNowPlayingMoviesParams> {
  final IMovieRepository repository;

  const GetNowPlayingMoviesUseCase(this.repository);

  @override
  Future<Result<List<Movie>>> call(GetNowPlayingMoviesParams params) async {
    if (params.page < 1) {
      return const Error(ValidationFailure(message: 'Página deve ser maior que 0'));
    }

    return await repository.getNowPlayingMovies(page: params.page);
  }
}
