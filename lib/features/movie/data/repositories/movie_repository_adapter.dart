import 'package:dio/dio.dart';
import 'package:movie_app/core/error/result.dart';
import 'package:movie_app/core/error/failure.dart';

import '../../domain/repositories/i_movie_repository.dart';
import '../models/movie.dart';
import 'movie_repository.dart';

/// Implementação do repositório de filmes que adapta o repositório legado
/// para usar o novo padrão Result.
/// 
/// Esta classe serve como ponte entre a arquitetura legada e a nova arquitetura.
class MovieRepositoryAdapter implements IMovieRepository {
  final MovieRepository _legacyRepository;

  MovieRepositoryAdapter(Dio dio) : _legacyRepository = MovieRepository(dio);

  @override
  Future<Result<List<Movie>>> getNowPlayingMovies({int page = 1}) async {
    try {
      final movies = await _legacyRepository.getNowPlayingMovies(startIndex: page);
      return Success(movies);
    } on DioException catch (e) {
      return Error(_mapDioExceptionToFailure(e));
    } catch (e) {
      return Error(ServerFailure(message: 'Erro inesperado ao buscar filmes em cartaz: $e'));
    }
  }

  @override
  Future<Result<List<Movie>>> searchMovies({
    required String query,
    int page = 1,
  }) async {
    try {
      final movies = await _legacyRepository.searchMovies(query, page: page);
      return Success(movies);
    } on DioException catch (e) {
      return Error(_mapDioExceptionToFailure(e));
    } catch (e) {
      return Error(ServerFailure(message: 'Erro inesperado ao pesquisar filmes: $e'));
    }
  }

  @override
  Future<Result<Movie>> getMovieDetails(int movieId) async {
    // TODO: Implementar quando o método existir no repositório legado
    return Error(ServerFailure(message: 'Método getMovieDetails não implementado ainda'));
  }

  /// Mapeia DioException para Failure apropriado.
  Failure _mapDioExceptionToFailure(DioException dioError) {
    switch (dioError.type) {
      case DioExceptionType.connectionTimeout:
      case DioExceptionType.sendTimeout:
      case DioExceptionType.receiveTimeout:
        return NetworkFailure(message: 'Timeout na conexão');
      case DioExceptionType.badResponse:
        final statusCode = dioError.response?.statusCode;
        switch (statusCode) {
          case 401:
            return ServerFailure(message: 'Erro de autenticação - verifique a API key');
          case 404:
            return ServerFailure(message: 'Endpoint não encontrado');
          case 429:
            return ServerFailure(message: 'Muitas requisições - rate limit atingido');
          default:
            return ServerFailure(message: 'Erro do servidor: $statusCode');
        }
      case DioExceptionType.cancel:
        return NetworkFailure(message: 'Requisição cancelada');
      case DioExceptionType.connectionError:
        return NetworkFailure(message: 'Erro de conexão com a internet');
      default:
        return ServerFailure(message: 'Erro de rede desconhecido: ${dioError.message}');
    }
  }
}
