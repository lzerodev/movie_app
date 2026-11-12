import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mocktail/mocktail.dart';
import 'package:movie_app/core/error/result.dart';
import 'package:movie_app/features/movie/presentation/bloc/movie_modern_bloc.dart';
import 'package:movie_app/features/movie/presentation/pages/now_playing_movies.dart';
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
  group('Testes de Integração - MovieModernBloc + UI', () {
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

    group('Cenários de Sucesso', () {
      testWidgets('deve carregar e exibir filmes em cartaz com sucesso', (WidgetTester tester) async {
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
          Movie(
            id: 2,
            title: 'Test Movie 2',
            posterPath: '/poster2.jpg',
            backdropPath: '/backdrop2.jpg',
            releaseDate: DateTime(2024, 1, 2),
            overview: 'Test movie overview 2',
            voteAverage: 8.0,
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
              child: const NowPlayingMoviesPage(),
            ),
          ),
        );

        // Dispara evento de carregamento
        bloc.add(const MovieModernNowPlayingFetched());
        await tester.pump();

        // Assert
        for (final movie in testMovies) {
          expect(find.text(movie.title), findsOneWidget);
        }
      });

      testWidgets('deve realizar busca de filmes com sucesso', (WidgetTester tester) async {
        // Arrange
        final searchResults = TestHelpers.createTestMovies(count: 3);
        TestScenarios.mockSuccessfulMovieSearch(mockSearchUseCase, movies: searchResults);

        await tester.pumpWidget(
          TestHelpers.createTestWidget(
            child: BlocProvider.value(
              value: bloc,
              child: const NowPlayingMoviesPage(),
            ),
          ),
        );

        // Act
        bloc.add(const MovieModernSearchRequested('test search'));
        await tester.pump();
        await tester.pump();

        // Assert
        for (final movie in searchResults) {
          expect(find.text(movie.title), findsOneWidget);
        }
      });

      testWidgets('deve alternar entre modo normal e busca', (WidgetTester tester) async {
        // Arrange
        final nowPlayingMovies = TestHelpers.createTestMovies(count: 3);
        final searchMovies = [TestHelpers.createTestMovie(title: 'Search Result')];
        
        TestScenarios.mockSuccessfulNowPlaying(mockNowPlayingUseCase, movies: nowPlayingMovies);
        TestScenarios.mockSuccessfulMovieSearch(mockSearchUseCase, movies: searchMovies);

        await tester.pumpWidget(
          TestHelpers.createTestWidget(
            child: BlocProvider.value(
              value: bloc,
              child: const NowPlayingMoviesPage(),
            ),
          ),
        );

        // Act & Assert
        // 1. Carrega filmes em cartaz
        bloc.add(const MovieModernNowPlayingFetched());
        await tester.pump();
        await tester.pump();

        expect(find.text('Test Movie 1'), findsOneWidget);

        // 2. Alterna para busca
        bloc.add(const MovieModernSearchRequested('search'));
        await tester.pump();
        await tester.pump();

        expect(find.text('Search Result'), findsOneWidget);
        expect(find.text('Test Movie 1'), findsNothing);

        // 3. Refresh para voltar ao modo normal (usando evento que existe)
        bloc.add(const MovieModernRefreshRequested());
        await tester.pump();

        expect(find.text('Test Movie 1'), findsOneWidget);
        expect(find.text('Search Result'), findsNothing);
      });
    });

    group('Cenários de Erro', () {
      testWidgets('deve exibir erro ao falhar no carregamento de filmes', (WidgetTester tester) async {
        // Arrange
        TestScenarios.mockFailedNowPlaying(mockNowPlayingUseCase, errorMessage: 'Erro de rede');

        await tester.pumpWidget(
          TestHelpers.createTestWidget(
            child: BlocProvider.value(
              value: bloc,
              child: const NowPlayingMoviesPage(),
            ),
          ),
        );

        // Act
        bloc.add(const MovieModernNowPlayingFetched());
        await tester.pump();
        await tester.pump();

        // Assert
        expect(find.textContaining('Erro de rede'), findsOneWidget);
      });

      testWidgets('deve exibir erro ao falhar na busca', (WidgetTester tester) async {
        // Arrange
        TestScenarios.mockFailedMovieSearch(mockSearchUseCase, errorMessage: 'Falha na busca');

        await tester.pumpWidget(
          TestHelpers.createTestWidget(
            child: BlocProvider.value(
              value: bloc,
              child: const NowPlayingMoviesPage(),
            ),
          ),
        );

        // Act
        bloc.add(const MovieModernSearchRequested('failing search'));
        await tester.pump();
        await tester.pump();

        // Assert
        expect(find.textContaining('Falha na busca'), findsOneWidget);
      });

      testWidgets('deve permitir retry após erro', (WidgetTester tester) async {
        // Arrange
        TestScenarios.mockFailedNowPlaying(mockNowPlayingUseCase);

        await tester.pumpWidget(
          TestHelpers.createTestWidget(
            child: BlocProvider.value(
              value: bloc,
              child: const NowPlayingMoviesPage(),
            ),
          ),
        );

        // Act - primeira tentativa (falha)
        bloc.add(const MovieModernNowPlayingFetched());
        await tester.pump();
        await tester.pump();

        // Configura sucesso para retry
        final successMovies = TestHelpers.createTestMovies(count: 2);
        TestScenarios.mockSuccessfulNowPlaying(mockNowPlayingUseCase, movies: successMovies);

        // Act - retry
        bloc.add(const MovieModernNowPlayingFetched());
        await tester.pump();
        await tester.pump();

        // Assert
        for (final movie in successMovies) {
          expect(find.text(movie.title), findsOneWidget);
        }
      });
    });

    group('Performance e Estados Complexos', () {
      testWidgets('deve lidar com múltiplas requisições sequenciais', (WidgetTester tester) async {
        // Arrange
        final movies1 = [TestHelpers.createTestMovie(title: 'Movie 1')];
        final movies2 = [TestHelpers.createTestMovie(title: 'Movie 2')];

        await tester.pumpWidget(
          TestHelpers.createTestWidget(
            child: BlocProvider.value(
              value: bloc,
              child: const NowPlayingMoviesPage(),
            ),
          ),
        );

        // Act - primeira busca
        TestScenarios.mockSuccessfulMovieSearch(mockSearchUseCase, movies: movies1);
        bloc.add(const MovieModernSearchRequested('first'));
        await tester.pump();
        await tester.pump();

        expect(find.text('Movie 1'), findsOneWidget);

        // Act - segunda busca
        TestScenarios.mockSuccessfulMovieSearch(mockSearchUseCase, movies: movies2);
        bloc.add(const MovieModernSearchRequested('second'));
        await tester.pump();
        await tester.pump();

        // Assert
        expect(find.text('Movie 2'), findsOneWidget);
        expect(find.text('Movie 1'), findsNothing);
      });

      testWidgets('deve manter estado durante navegação', (WidgetTester tester) async {
        // Arrange
        final testMovies = TestHelpers.createTestMovies(count: 3);
        TestScenarios.mockSuccessfulNowPlaying(mockNowPlayingUseCase, movies: testMovies);

        await tester.pumpWidget(
          TestHelpers.createTestWidget(
            child: BlocProvider.value(
              value: bloc,
              child: const NowPlayingMoviesPage(),
            ),
          ),
        );

        // Act
        bloc.add(const MovieModernNowPlayingFetched());
        await tester.pump();
        await tester.pump();

        // Simula navegação (rebuild do widget)
        await tester.pumpWidget(
          TestHelpers.createTestWidget(
            child: BlocProvider.value(
              value: bloc,
              child: const NowPlayingMoviesPage(),
            ),
          ),
        );

        // Assert - estado deve ser mantido
        for (final movie in testMovies) {
          expect(find.text(movie.title), findsOneWidget);
        }
      });
    });

    group('Edge Cases', () {
      testWidgets('deve lidar com lista vazia', (WidgetTester tester) async {
        // Arrange
        TestScenarios.mockSuccessfulNowPlaying(mockNowPlayingUseCase, movies: []);

        await tester.pumpWidget(
          TestHelpers.createTestWidget(
            child: BlocProvider.value(
              value: bloc,
              child: const NowPlayingMoviesPage(),
            ),
          ),
        );

        // Act
        bloc.add(const MovieModernNowPlayingFetched());
        await tester.pump();
        await tester.pump();

        // Assert - deve mostrar estado vazio
        expect(find.byType(CircularProgressIndicator), findsNothing);
        // O comportamento exato depende da implementação da UI
      });

      testWidgets('deve lidar com busca por string vazia', (WidgetTester tester) async {
        // Arrange
        await tester.pumpWidget(
          TestHelpers.createTestWidget(
            child: BlocProvider.value(
              value: bloc,
              child: const NowPlayingMoviesPage(),
            ),
          ),
        );

        // Act
        bloc.add(const MovieModernSearchRequested(''));
        await tester.pump();

        // Assert - deve lidar graciosamente com string vazia
        expect(tester.takeException(), isNull);
      });

      testWidgets('deve lidar com caracteres especiais na busca', (WidgetTester tester) async {
        // Arrange
        final searchResults = [TestHelpers.createTestMovie(title: 'Special Movie')];
        TestScenarios.mockSuccessfulMovieSearch(mockSearchUseCase, movies: searchResults);

        await tester.pumpWidget(
          TestHelpers.createTestWidget(
            child: BlocProvider.value(
              value: bloc,
              child: const NowPlayingMoviesPage(),
            ),
          ),
        );

        // Act
        bloc.add(const MovieModernSearchRequested('test@#\$%'));
        await tester.pump();
        await tester.pump();

        // Assert
        expect(find.text('Special Movie'), findsOneWidget);
      });
    });

    group('Acessibilidade e UX', () {
      testWidgets('deve fornecer feedback adequado durante loading', (WidgetTester tester) async {
        // Arrange
        when(() => mockNowPlayingUseCase(any())).thenAnswer(
          (_) async => Future.delayed(
            const Duration(milliseconds: 100),
            () => Success(TestHelpers.createTestMovies()),
          ),
        );

        await tester.pumpWidget(
          TestHelpers.createTestWidget(
            child: BlocProvider.value(
              value: bloc,
              child: const NowPlayingMoviesPage(),
            ),
          ),
        );

        // Act
        bloc.add(const MovieModernNowPlayingFetched());
        await tester.pump();

        // Assert - deve mostrar loading
        expect(find.byType(CircularProgressIndicator), findsOneWidget);

        // Aguarda conclusão
        await tester.pump(const Duration(milliseconds: 150));

        // Assert - loading deve ter desaparecido
        expect(find.byType(CircularProgressIndicator), findsNothing);
      });

      testWidgets('deve manter semântica adequada para screen readers', (WidgetTester tester) async {
        // Arrange
        final testMovies = TestHelpers.createTestMovies(count: 2);
        TestScenarios.mockSuccessfulNowPlaying(mockNowPlayingUseCase, movies: testMovies);

        await tester.pumpWidget(
          TestHelpers.createTestWidget(
            child: BlocProvider.value(
              value: bloc,
              child: const NowPlayingMoviesPage(),
            ),
          ),
        );

        // Act
        bloc.add(const MovieModernNowPlayingFetched());
        await tester.pump();
        await tester.pump();

        // Assert - verifica se elementos têm semântica adequada
        final semantics = tester.getSemantics(find.byType(NowPlayingMoviesPage));
        expect(semantics, isNotNull);
      });
    });
  });
}
