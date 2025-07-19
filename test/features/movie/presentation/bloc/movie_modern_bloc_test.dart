import 'package:bloc_test/bloc_test.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:movie_app/core/error/failure.dart';
import 'package:movie_app/core/error/result.dart';
import 'package:movie_app/features/movie/data/models/movie.dart';
import 'package:movie_app/features/movie/domain/usecases/get_now_playing_movies_usecase.dart';
import 'package:movie_app/features/movie/domain/usecases/search_movies_usecase.dart';
import 'package:movie_app/features/movie/presentation/bloc/movie_modern_bloc.dart';

// Mocks dos UseCases
class MockSearchMoviesUseCase extends Mock implements SearchMoviesUseCase {}
class MockGetNowPlayingMoviesUseCase extends Mock implements GetNowPlayingMoviesUseCase {}

// Fakes para registerFallbackValue
class FakeGetNowPlayingMoviesParams extends Fake implements GetNowPlayingMoviesParams {}
class FakeSearchMoviesParams extends Fake implements SearchMoviesParams {}

void main() {
  late MovieModernBloc bloc;
  late MockSearchMoviesUseCase mockSearchMoviesUseCase;
  late MockGetNowPlayingMoviesUseCase mockGetNowPlayingMoviesUseCase;

  setUpAll(() {
    registerFallbackValue(FakeGetNowPlayingMoviesParams());
    registerFallbackValue(FakeSearchMoviesParams());
  });

  setUp(() {
    mockSearchMoviesUseCase = MockSearchMoviesUseCase();
    mockGetNowPlayingMoviesUseCase = MockGetNowPlayingMoviesUseCase();
    bloc = MovieModernBloc(
      searchMoviesUseCase: mockSearchMoviesUseCase,
      getNowPlayingMoviesUseCase: mockGetNowPlayingMoviesUseCase,
    );
  });

  tearDown(() {
    bloc.close();
  });

  group('MovieModernBloc - Testes Simples', () {
    final movieList = [
      Movie(
        id: 1,
        title: 'Test Movie 1',
        posterPath: '/poster1.jpg',
        backdropPath: '/backdrop1.jpg',
        releaseDate: DateTime(2024, 1, 1),
        overview: 'A test movie',
        voteAverage: 8.0,
      ),
      Movie(
        id: 2,
        title: 'Test Movie 2',
        posterPath: '/poster2.jpg',
        backdropPath: '/backdrop2.jpg',
        releaseDate: DateTime(2024, 2, 1),
        overview: 'Another test movie',
        voteAverage: 7.5,
      ),
    ];

    test('estado inicial deve ser MovieModernState inicial', () {
      expect(bloc.state, equals(const MovieModernState()));
    });

    blocTest<MovieModernBloc, MovieModernState>(
      'deve buscar filmes com sucesso',
      build: () {
        when(() => mockGetNowPlayingMoviesUseCase(any()))
            .thenAnswer((_) async => Success(movieList));
        return bloc;
      },
      act: (bloc) => bloc.add(const MovieModernNowPlayingFetched()),
      expect: () => [
        const MovieModernState(status: MovieModernStatus.loading),
        isA<MovieModernState>()
            .having((s) => s.status, 'status', MovieModernStatus.success)
            .having((s) => s.movies.length, 'movies length', 2)
            .having((s) => s.hasReachedMax, 'hasReachedMax', true),
      ],
    );

    blocTest<MovieModernBloc, MovieModernState>(
      'deve falhar ao buscar filmes',
      build: () {
        when(() => mockGetNowPlayingMoviesUseCase(any()))
            .thenAnswer((_) async => const Error(NetworkFailure(message: 'Network error')));
        return bloc;
      },
      act: (bloc) => bloc.add(const MovieModernNowPlayingFetched()),
      expect: () => [
        const MovieModernState(status: MovieModernStatus.loading),
        isA<MovieModernState>()
            .having((s) => s.status, 'status', MovieModernStatus.failure)
            .having((s) => s.errorMessage, 'errorMessage', 'Network error'),
      ],
    );

    blocTest<MovieModernBloc, MovieModernState>(
      'deve buscar filmes por query',
      build: () {
        when(() => mockSearchMoviesUseCase(any()))
            .thenAnswer((_) async => Success(movieList));
        return bloc;
      },
      act: (bloc) => bloc.add(const MovieModernSearchRequested('test')),
      expect: () => [
        isA<MovieModernState>()
            .having((s) => s.status, 'status', MovieModernStatus.loading)
            .having((s) => s.isSearchMode, 'isSearchMode', true),
        isA<MovieModernState>()
            .having((s) => s.status, 'status', MovieModernStatus.success)
            .having((s) => s.movies.length, 'movies length', 2)
            .having((s) => s.isSearchMode, 'isSearchMode', true)
            .having((s) => s.searchQuery, 'searchQuery', 'test'),
      ],
    );

    blocTest<MovieModernBloc, MovieModernState>(
      'deve resetar estado no refresh',
      build: () {
        when(() => mockGetNowPlayingMoviesUseCase(any()))
            .thenAnswer((_) async => Success(movieList));
        return bloc;
      },
      seed: () => MovieModernState(
        status: MovieModernStatus.success,
        movies: movieList,
        isSearchMode: true,
        searchQuery: 'test',
      ),
      act: (bloc) => bloc.add(const MovieModernRefreshRequested()),
      expect: () => [
        const MovieModernState(), // Reset para estado inicial
        const MovieModernState(status: MovieModernStatus.loading),
        isA<MovieModernState>().having((s) => s.status, 'status', MovieModernStatus.success),
      ],
    );
  });

  group('MovieModernState', () {
    test('deve suportar value equality', () {
      const state1 = MovieModernState(
        status: MovieModernStatus.success,
        movies: [],
        hasReachedMax: false,
      );
      const state2 = MovieModernState(
        status: MovieModernStatus.success,
        movies: [],
        hasReachedMax: false,
      );

      expect(state1, equals(state2));
    });

    test('copyWith deve trabalhar corretamente', () {
      const state = MovieModernState();
      final newState = state.copyWith(
        status: MovieModernStatus.loading,
        movies: [
          Movie(
            id: 1,
            title: 'Test',
            posterPath: '/test.jpg',
            backdropPath: '/backdrop.jpg',
            releaseDate: DateTime(2024),
            overview: 'Test',
            voteAverage: 8.0,
          ),
        ],
      );

      expect(newState.status, MovieModernStatus.loading);
      expect(newState.movies.length, 1);
      expect(newState.hasReachedMax, false); // Valor default mantido
    });

    test('copyWith deve limpar errorMessage quando passado null', () {
      const state = MovieModernState(errorMessage: 'Some error');
      final newState = state.copyWith(errorMessage: null);

      expect(newState.errorMessage, isNull);
    });
  });
}
