import 'package:dio/dio.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:movie_app/core/error/failure.dart';
import 'package:movie_app/core/error/result.dart';
import 'package:movie_app/core/utils/app_constants.dart';
import 'package:movie_app/features/movie/data/models/movie.dart';
import 'package:movie_app/features/movie/data/repositories/movie_repository_adapter.dart';

class _MockDio extends Mock implements Dio {}

void main() {
  late _MockDio dio;
  late MovieRepositoryAdapter repository;
  const path = '${AppConstants.tmdbBaseUrl}/movie/42';

  setUp(() {
    dio = _MockDio();
    repository = MovieRepositoryAdapter(dio, apiKeyProvider: () => 'test-key');
  });

  test('detalhes consulta o endpoint por ID e converte a resposta', () async {
    when(
      () => dio.get<dynamic>(
        path,
        queryParameters: any(named: 'queryParameters'),
      ),
    ).thenAnswer(
      (_) async => Response(
        requestOptions: RequestOptions(path: path),
        statusCode: 200,
        data: {
          'id': 42,
          'title': 'Filme de teste',
          'poster_path': null,
          'backdrop_path': null,
          'release_date': '2026-11-12',
          'overview': 'Sinopse',
          'vote_average': 8.0,
        },
      ),
    );
    final result = await repository.getMovieDetails(42);
    expect(
      result,
      isA<Success<Movie>>()
          .having((r) => r.data.id, 'id', 42)
          .having((r) => r.data.title, 'title', 'Filme de teste'),
    );
    verify(
      () => dio.get<dynamic>(
        path,
        queryParameters: {'api_key': 'test-key', 'language': 'pt-BR'},
      ),
    ).called(1);
  });

  test('ID inválido não faz requisição', () async {
    expect(
      await repository.getMovieDetails(0),
      isA<Error<Movie>>().having(
        (r) => r.failure,
        'failure',
        isA<ValidationFailure>(),
      ),
    );
    verifyZeroInteractions(dio);
  });

  test('404 retorna falha de servidor', () async {
    when(
      () => dio.get<dynamic>(
        path,
        queryParameters: any(named: 'queryParameters'),
      ),
    ).thenThrow(
      DioException(
        requestOptions: RequestOptions(path: path),
        type: DioExceptionType.badResponse,
        response: Response(
          requestOptions: RequestOptions(path: path),
          statusCode: 404,
        ),
      ),
    );
    expect(
      await repository.getMovieDetails(42),
      isA<Error<Movie>>().having(
        (r) => r.failure,
        'failure',
        isA<ServerFailure>(),
      ),
    );
  });

  test('timeout retorna falha de rede', () async {
    when(
      () => dio.get<dynamic>(
        path,
        queryParameters: any(named: 'queryParameters'),
      ),
    ).thenThrow(
      DioException(
        requestOptions: RequestOptions(path: path),
        type: DioExceptionType.connectionTimeout,
      ),
    );
    expect(
      await repository.getMovieDetails(42),
      isA<Error<Movie>>().having(
        (r) => r.failure,
        'failure',
        isA<NetworkFailure>(),
      ),
    );
  });

  test('resposta não bem-sucedida é tratada mesmo sem DioException', () async {
    when(
      () => dio.get<dynamic>(
        path,
        queryParameters: any(named: 'queryParameters'),
      ),
    ).thenAnswer(
      (_) async =>
          Response(requestOptions: RequestOptions(path: path), statusCode: 503),
    );
    expect(
      await repository.getMovieDetails(42),
      isA<Error<Movie>>().having(
        (r) => r.failure.message,
        'message',
        contains('503'),
      ),
    );
  });

  test('payload inválido é convertido em falha sem lançar para a UI', () async {
    when(
      () => dio.get<dynamic>(
        path,
        queryParameters: any(named: 'queryParameters'),
      ),
    ).thenAnswer(
      (_) async => Response(
        requestOptions: RequestOptions(path: path),
        statusCode: 200,
        data: {'id': 42},
      ),
    );
    expect(
      await repository.getMovieDetails(42),
      isA<Error<Movie>>().having(
        (r) => r.failure,
        'failure',
        isA<ServerFailure>(),
      ),
    );
  });
}
