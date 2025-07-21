import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mocktail/mocktail.dart';
import 'package:movie_app/core/error/failure.dart';
import 'package:movie_app/core/error/result.dart';
import 'package:movie_app/features/movie/presentation/bloc/movie_modern_bloc.dart';
import 'package:movie_app/features/movie/data/models/movie.dart';
import 'package:movie_app/features/movie/domain/usecases/get_now_playing_movies_usecase.dart';
import 'package:movie_app/features/movie/domain/usecases/search_movies_usecase.dart';

// Mocks
class MockSearchMoviesUseCase extends Mock implements SearchMoviesUseCase {}
class MockGetNowPlayingMoviesUseCase extends Mock implements GetNowPlayingMoviesUseCase {}

// Fakes para registerFallbackValue
class FakeGetNowPlayingMoviesParams extends Fake implements GetNowPlayingMoviesParams {}
class FakeSearchMoviesParams extends Fake implements SearchMoviesParams {}

void main() {
  group('Testes de Integração Simples - MovieModernBloc', () {
    late MockSearchMoviesUseCase mockSearchUseCase;
    late MockGetNowPlayingMoviesUseCase mockNowPlayingUseCase;
    late MovieModernBloc bloc;

    setUp(() {
      registerFallbackValue(FakeGetNowPlayingMoviesParams());
      registerFallbackValue(FakeSearchMoviesParams());
      
      mockSearchUseCase = MockSearchMoviesUseCase();
      mockNowPlayingUseCase = MockGetNowPlayingMoviesUseCase();
      bloc = MovieModernBloc(
        searchMoviesUseCase: mockSearchUseCase,
        getNowPlayingMoviesUseCase: mockNowPlayingUseCase,
      );
    });

    tearDown(() {
      bloc.close();
    });

    group('BLoC Logic Tests', () {
      test('deve emitir estado de loading e sucesso ao buscar filmes', () async {
        // Arrange
        final testMovies = [
          Movie(
            id: 1,
            title: 'Test Movie 1',
            posterPath: '/poster1.jpg',
            backdropPath: '/backdrop1.jpg',
            releaseDate: DateTime(2024, 1, 1),
            overview: 'Test movie overview 1',
            voteAverage: 7.5,
          ),
        ];

        when(() => mockNowPlayingUseCase(any())).thenAnswer(
          (_) async => Success(testMovies),
        );

        // Act & Assert
        expectLater(
          bloc.stream,
          emitsInOrder([
            const MovieModernState(status: MovieModernStatus.loading),
            MovieModernState(
              status: MovieModernStatus.success,
              movies: testMovies,
              hasReachedMax: true,
            ),
          ]),
        );

        bloc.add(const MovieModernNowPlayingFetched());
      });

      test('deve emitir estado de erro quando usecase falha', () async {
        // Arrange
        when(() => mockNowPlayingUseCase(any())).thenAnswer(
          (_) async => Error(NetworkFailure(message: 'Network error')),
        );

        // Act & Assert
        expectLater(
          bloc.stream,
          emitsInOrder([
            const MovieModernState(status: MovieModernStatus.loading),
            const MovieModernState(
              status: MovieModernStatus.failure,
              errorMessage: 'Network error',
            ),
          ]),
        );

        bloc.add(const MovieModernNowPlayingFetched());
      });
    });

    group('Widget Tests', () {
      testWidgets('deve renderizar básico sem crashes', (WidgetTester tester) async {
        // Arrange
        final testMovies = [
          Movie(
            id: 1,
            title: 'Test Movie',
            posterPath: '/poster.jpg',
            backdropPath: '/backdrop.jpg',
            releaseDate: DateTime(2024, 1, 1),
            overview: 'Test overview',
            voteAverage: 7.5,
          ),
        ];

        when(() => mockNowPlayingUseCase(any())).thenAnswer(
          (_) async => Success(testMovies),
        );

        // Act
        await tester.pumpWidget(
          MaterialApp(
            home: BlocProvider.value(
              value: bloc,
              child: Scaffold(
                body: BlocBuilder<MovieModernBloc, MovieModernState>(
                  builder: (context, state) {
                    if (state.status == MovieModernStatus.loading) {
                      return const Center(child: CircularProgressIndicator());
                    }
                    if (state.status == MovieModernStatus.failure) {
                      return Center(child: Text('Erro: ${state.errorMessage}'));
                    }
                    return ListView.builder(
                      itemCount: state.movies.length,
                      itemBuilder: (context, index) {
                        final movie = state.movies[index];
                        return ListTile(
                          title: Text(movie.title),
                          subtitle: Text(movie.overview),
                        );
                      },
                    );
                  },
                ),
              ),
            ),
          ),
        );

        bloc.add(const MovieModernNowPlayingFetched());
        await tester.pump();

        // Assert - não deve crashar
        expect(find.byType(MaterialApp), findsOneWidget);
      });
    });
  });
}
