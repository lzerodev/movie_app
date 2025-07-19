import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:movie_app/core/error/failure.dart';
import 'package:movie_app/core/error/result.dart';
import 'package:movie_app/features/movie/data/models/movie.dart';
import 'package:movie_app/features/movie/domain/repositories/i_movie_repository.dart';
import 'package:movie_app/features/movie/domain/usecases/get_now_playing_movies_usecase.dart';

// Mock do repositório
class MockIMovieRepository extends Mock implements IMovieRepository {}

void main() {
  late GetNowPlayingMoviesUseCase useCase;
  late MockIMovieRepository mockRepository;

  setUp(() {
    mockRepository = MockIMovieRepository();
    useCase = GetNowPlayingMoviesUseCase(mockRepository);
  });

  group('GetNowPlayingMoviesUseCase', () {
    const page = 1;
    const params = GetNowPlayingMoviesParams(page: page);

    final movieList = [
      Movie(
        id: 1,
        title: 'Now Playing Movie 1',
        posterPath: '/poster1.jpg',
        backdropPath: '/backdrop1.jpg',
        releaseDate: DateTime(2024, 1, 15),
        overview: 'A thrilling action movie currently in theaters.',
        voteAverage: 8.5,
      ),
      Movie(
        id: 2,
        title: 'Now Playing Movie 2',
        posterPath: '/poster2.jpg',
        backdropPath: '/backdrop2.jpg',
        releaseDate: DateTime(2024, 2, 1),
        overview: 'A romantic comedy playing this week.',
        voteAverage: 7.2,
      ),
    ];

    test('deve retornar lista de filmes em cartaz quando a busca for bem-sucedida', () async {
      // Arrange
      when(() => mockRepository.getNowPlayingMovies(page: page))
          .thenAnswer((_) async => Success(movieList));

      // Act
      final result = await useCase(params);

      // Assert
      expect(result, isA<Success<List<Movie>>>());
      final success = result as Success<List<Movie>>;
      expect(success.data, equals(movieList));
      expect(success.data.length, equals(2));
      expect(success.data.first.title, equals('Now Playing Movie 1'));
      
      verify(() => mockRepository.getNowPlayingMovies(page: page)).called(1);
    });

    test('deve retornar ValidationFailure quando page for menor que 1', () async {
      // Arrange
      const invalidParams = GetNowPlayingMoviesParams(page: 0);

      // Act
      final result = await useCase(invalidParams);

      // Assert
      expect(result, isA<Error<List<Movie>>>());
      final error = result as Error<List<Movie>>;
      expect(error.failure, isA<ValidationFailure>());
      expect(error.failure.message, contains('Página deve ser maior que 0'));
      
      verifyNever(() => mockRepository.getNowPlayingMovies(page: any(named: 'page')));
    });

    test('deve retornar NetworkFailure quando repositório falhar com erro de rede', () async {
      // Arrange
      const networkFailure = NetworkFailure(message: 'Falha de conectividade');
      when(() => mockRepository.getNowPlayingMovies(page: page))
          .thenAnswer((_) async => const Error(networkFailure));

      // Act
      final result = await useCase(params);

      // Assert
      expect(result, isA<Error<List<Movie>>>());
      final error = result as Error<List<Movie>>;
      expect(error.failure, isA<NetworkFailure>());
      expect(error.failure.message, equals('Falha de conectividade'));
      
      verify(() => mockRepository.getNowPlayingMovies(page: page)).called(1);
    });

    test('deve retornar ServerFailure quando repositório falhar com erro do servidor', () async {
      // Arrange
      const serverFailure = ServerFailure(message: 'Erro 500 - Servidor indisponível');
      when(() => mockRepository.getNowPlayingMovies(page: page))
          .thenAnswer((_) async => const Error(serverFailure));

      // Act
      final result = await useCase(params);

      // Assert
      expect(result, isA<Error<List<Movie>>>());
      final error = result as Error<List<Movie>>;
      expect(error.failure, isA<ServerFailure>());
      expect(error.failure.message, equals('Erro 500 - Servidor indisponível'));
      
      verify(() => mockRepository.getNowPlayingMovies(page: page)).called(1);
    });

    test('deve retornar lista vazia quando não houver filmes em cartaz', () async {
      // Arrange
      when(() => mockRepository.getNowPlayingMovies(page: page))
          .thenAnswer((_) async => const Success(<Movie>[]));

      // Act
      final result = await useCase(params);

      // Assert
      expect(result, isA<Success<List<Movie>>>());
      final success = result as Success<List<Movie>>;
      expect(success.data, isEmpty);
      
      verify(() => mockRepository.getNowPlayingMovies(page: page)).called(1);
    });

    test('deve usar page 1 como valor padrão quando não especificado', () async {
      // Arrange
      const defaultParams = GetNowPlayingMoviesParams();
      when(() => mockRepository.getNowPlayingMovies(page: 1))
          .thenAnswer((_) async => Success(movieList));

      // Act
      final result = await useCase(defaultParams);

      // Assert
      expect(result, isA<Success<List<Movie>>>());
      verify(() => mockRepository.getNowPlayingMovies(page: 1)).called(1);
    });
  });

  group('GetNowPlayingMoviesParams', () {
    test('deve criar parâmetros com page especificada', () {
      // Act
      const params = GetNowPlayingMoviesParams(page: 5);

      // Assert
      expect(params.page, equals(5));
    });

    test('deve usar page 1 como padrão', () {
      // Act
      const params = GetNowPlayingMoviesParams();

      // Assert
      expect(params.page, equals(1));
    });

    test('deve implementar Equatable corretamente', () {
      // Act
      const params1 = GetNowPlayingMoviesParams(page: 2);
      const params2 = GetNowPlayingMoviesParams(page: 2);
      const params3 = GetNowPlayingMoviesParams(page: 3);

      // Assert
      expect(params1, equals(params2));
      expect(params1, isNot(equals(params3)));
    });
  });
}
