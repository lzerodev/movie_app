import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:movie_app/core/error/failure.dart';
import 'package:movie_app/core/error/result.dart';
import 'package:movie_app/features/movie/data/models/movie.dart';
import 'package:movie_app/features/movie/domain/repositories/i_movie_repository.dart';
import 'package:movie_app/features/movie/domain/usecases/search_movies_usecase.dart';

// Mock do repositório
class MockIMovieRepository extends Mock implements IMovieRepository {}

void main() {
  late SearchMoviesUseCase useCase;
  late MockIMovieRepository mockRepository;

  setUp(() {
    mockRepository = MockIMovieRepository();
    useCase = SearchMoviesUseCase(mockRepository);
  });

  group('SearchMoviesUseCase', () {
    const query = 'Inception';
    const page = 1;
    const params = SearchMoviesParams(query: query, page: page);

    final movieList = [
      Movie(
        id: 1,
        title: 'Inception',
        posterPath: '/path/to/poster.jpg',
        backdropPath: '/path/to/backdrop.jpg',
        releaseDate: DateTime(2010, 7, 16),
        overview: 'A thief who steals corporate secrets through the use of dream-sharing technology.',
        voteAverage: 8.8,
      ),
      Movie(
        id: 2,
        title: 'Inception: The Beginning',
        posterPath: '/path/to/poster2.jpg',
        backdropPath: '/path/to/backdrop2.jpg',
        releaseDate: DateTime(2011, 7, 16),
        overview: 'A sequel to Inception.',
        voteAverage: 7.5,
      ),
    ];

    test('deve retornar lista de filmes quando a busca for bem-sucedida', () async {
      // Arrange
      when(() => mockRepository.searchMovies(query: query, page: page))
          .thenAnswer((_) async => Success(movieList));

      // Act
      final result = await useCase(params);

      // Assert
      expect(result, isA<Success<List<Movie>>>());
      final success = result as Success<List<Movie>>;
      expect(success.data, equals(movieList));
      expect(success.data.length, equals(2));
      expect(success.data.first.title, equals('Inception'));
      
      verify(() => mockRepository.searchMovies(query: query, page: page)).called(1);
    });

    test('deve retornar ValidationFailure quando query estiver vazia', () async {
      // Arrange
      const emptyParams = SearchMoviesParams(query: '', page: page);

      // Act
      final result = await useCase(emptyParams);

      // Assert
      expect(result, isA<Error<List<Movie>>>());
      final error = result as Error<List<Movie>>;
      expect(error.failure, isA<ValidationFailure>());
      expect(error.failure.message, contains('Query de pesquisa não pode estar vazia'));
      
      verifyNever(() => mockRepository.searchMovies(query: any(named: 'query'), page: any(named: 'page')));
    });

    test('deve retornar ValidationFailure quando query tiver menos de 2 caracteres', () async {
      // Arrange
      const shortParams = SearchMoviesParams(query: 'a', page: page);

      // Act
      final result = await useCase(shortParams);

      // Assert
      expect(result, isA<Error<List<Movie>>>());
      final error = result as Error<List<Movie>>;
      expect(error.failure, isA<ValidationFailure>());
      expect(error.failure.message, contains('deve ter pelo menos 2 caracteres'));
      
      verifyNever(() => mockRepository.searchMovies(query: any(named: 'query'), page: any(named: 'page')));
    });

    test('deve retornar ValidationFailure quando page for menor que 1', () async {
      // Arrange
      const invalidPageParams = SearchMoviesParams(query: query, page: 0);

      // Act
      final result = await useCase(invalidPageParams);

      // Assert
      expect(result, isA<Error<List<Movie>>>());
      final error = result as Error<List<Movie>>;
      expect(error.failure, isA<ValidationFailure>());
      expect(error.failure.message, contains('Página deve ser maior que 0'));
      
      verifyNever(() => mockRepository.searchMovies(query: any(named: 'query'), page: any(named: 'page')));
    });

    test('deve retornar NetworkFailure quando repositório falhar com erro de rede', () async {
      // Arrange
      const networkFailure = NetworkFailure(message: 'Erro de conexão');
      when(() => mockRepository.searchMovies(query: query, page: page))
          .thenAnswer((_) async => const Error(networkFailure));

      // Act
      final result = await useCase(params);

      // Assert
      expect(result, isA<Error<List<Movie>>>());
      final error = result as Error<List<Movie>>;
      expect(error.failure, isA<NetworkFailure>());
      expect(error.failure.message, equals('Erro de conexão'));
      
      verify(() => mockRepository.searchMovies(query: query, page: page)).called(1);
    });

    test('deve retornar ServerFailure quando repositório falhar com erro do servidor', () async {
      // Arrange
      const serverFailure = ServerFailure(message: 'Erro interno do servidor');
      when(() => mockRepository.searchMovies(query: query, page: page))
          .thenAnswer((_) async => const Error(serverFailure));

      // Act
      final result = await useCase(params);

      // Assert
      expect(result, isA<Error<List<Movie>>>());
      final error = result as Error<List<Movie>>;
      expect(error.failure, isA<ServerFailure>());
      expect(error.failure.message, equals('Erro interno do servidor'));
      
      verify(() => mockRepository.searchMovies(query: query, page: page)).called(1);
    });

    test('deve retornar lista vazia quando não houver resultados', () async {
      // Arrange
      when(() => mockRepository.searchMovies(query: query, page: page))
          .thenAnswer((_) async => const Success(<Movie>[]));

      // Act
      final result = await useCase(params);

      // Assert
      expect(result, isA<Success<List<Movie>>>());
      final success = result as Success<List<Movie>>;
      expect(success.data, isEmpty);
      
      verify(() => mockRepository.searchMovies(query: query, page: page)).called(1);
    });
  });

  group('SearchMoviesParams', () {
    test('deve criar parâmetros válidos', () {
      // Act
      const params = SearchMoviesParams(query: 'test', page: 1);

      // Assert
      expect(params.query, equals('test'));
      expect(params.page, equals(1));
    });

    test('deve ter valores padrão corretos', () {
      // Act
      const params = SearchMoviesParams(query: 'test');

      // Assert
      expect(params.query, equals('test'));
      expect(params.page, equals(1));
    });

    test('deve implementar Equatable corretamente', () {
      // Act
      const params1 = SearchMoviesParams(query: 'test', page: 1);
      const params2 = SearchMoviesParams(query: 'test', page: 1);
      const params3 = SearchMoviesParams(query: 'other', page: 1);

      // Assert
      expect(params1, equals(params2));
      expect(params1, isNot(equals(params3)));
    });
  });
}
