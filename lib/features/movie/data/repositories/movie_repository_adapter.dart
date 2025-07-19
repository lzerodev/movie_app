import 'package:dio/dio.dart';
import 'package:movie_app/core/error/result.dart';
import 'package:movie_app/core/error/failure.dart';
import 'package:movie_app/core/utils/app_constants.dart';
import 'package:movie_app/core/utils/secrets.dart';

import '../../domain/repositories/i_movie_repository.dart';
import '../models/movie.dart';

/// Implementação moderna do repositório de filmes usando Result Pattern.
/// 
/// Esta classe implementa IMovieRepository e faz requisições diretas à API
/// seguindo os princípios da Clean Architecture.
class MovieRepositoryAdapter implements IMovieRepository {
  final Dio _dio;

  MovieRepositoryAdapter(this._dio);

  @override
  Future<Result<List<Movie>>> getNowPlayingMovies({int page = 1}) async {
    try {
      final response = await _dio.get(
        '${AppConstants.tmdbBaseUrl}/movie/now_playing',
        queryParameters: {
          'api_key': AppSecrets.tmdbApiKey,
          'page': page,
          'language': 'pt-BR',
        },
      );

      if (response.statusCode == 200) {
        final List<dynamic> results = response.data['results'] ?? [];
        final movies = results.map((movie) => Movie.fromJson(movie)).toList();
        return Success(movies);
      } else {
        return Error(ServerFailure(message: 'Falha ao buscar filmes em cartaz: ${response.statusCode}'));
      }
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
      final response = await _dio.get(
        '${AppConstants.tmdbBaseUrl}/search/movie',
        queryParameters: {
          'api_key': AppSecrets.tmdbApiKey,
          'query': query,
          'page': page,
          'language': 'pt-BR',
        },
      );

      if (response.statusCode == 200) {
        final List<dynamic> results = response.data['results'] ?? [];
        final movies = results.map((json) => Movie.fromJson(json)).toList();
        return Success(movies);
      } else {
        return Error(ServerFailure(message: 'Falha ao pesquisar filmes: ${response.statusCode}'));
      }
    } on DioException catch (e) {
      return Error(_mapDioExceptionToFailure(e));
    } catch (e) {
      return Error(ServerFailure(message: 'Erro inesperado ao pesquisar filmes: $e'));
    }
  }

  @override
  Future<Result<Movie>> getMovieDetails(int movieId) async {
    // TODO: Implementar quando o método existir no repositório legado
    return const Error(ServerFailure(message: 'Método getMovieDetails não implementado ainda'));
  }

  /// Mapeia DioException para Failure apropriado.
  Failure _mapDioExceptionToFailure(DioException dioError) {
    switch (dioError.type) {
      case DioExceptionType.connectionTimeout:
      case DioExceptionType.sendTimeout:
      case DioExceptionType.receiveTimeout:
        return const NetworkFailure(message: 'Timeout na conexão');
      case DioExceptionType.badResponse:
        final statusCode = dioError.response?.statusCode;
        switch (statusCode) {
          case 401:
            return const ServerFailure(message: 'Erro de autenticação - verifique a API key');
          case 404:
            return const ServerFailure(message: 'Endpoint não encontrado');
          case 429:
            return const ServerFailure(message: 'Muitas requisições - rate limit atingido');
          default:
            return ServerFailure(message: 'Erro do servidor: $statusCode');
        }
      case DioExceptionType.cancel:
        return const NetworkFailure(message: 'Requisição cancelada');
      case DioExceptionType.connectionError:
        return const NetworkFailure(message: 'Erro de conexão com a internet');
      default:
        return ServerFailure(message: 'Erro de rede desconhecido: ${dioError.message}');
    }
  }
}
