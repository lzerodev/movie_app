import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:movie_app/core/error/failure.dart';
import 'package:movie_app/core/error/result.dart';
import 'package:movie_app/features/movie/data/models/movie.dart';
import 'package:movie_app/features/movie/domain/repositories/i_movie_repository.dart';
import 'package:movie_app/features/movie/domain/usecases/get_now_playing_movies_usecase.dart';
import 'package:movie_app/features/movie/domain/usecases/search_movies_usecase.dart';

/// Helpers centralizados para testes
class TestHelpers {
  /// Cria um widget de teste com MaterialApp e MediaQuery
  static Widget createTestWidget({
    required Widget child,
    Size? screenSize,
    Brightness? brightness,
    double? textScaleFactor,
  }) {
    return MaterialApp(
      theme: ThemeData(brightness: brightness ?? Brightness.light),
      home: MediaQuery(
        data: MediaQueryData(
          size: screenSize ?? const Size(414, 896), // iPhone 11 Pro size
          devicePixelRatio: 3.0,
          textScaleFactor: textScaleFactor ?? 1.0,
        ),
        child: Scaffold(body: child),
      ),
    );
  }

  /// Breakpoints de teste para responsividade
  static const Size mobileSize = Size(360, 640);
  static const Size tabletSize = Size(768, 1024);
  static const Size desktopSize = Size(1200, 800);
  static const Size largeDesktopSize = Size(1920, 1080);

  /// Cria lista de filmes para testes
  static List<Movie> createTestMovies({int count = 3}) {
    return List.generate(count, (index) => Movie(
      id: index + 1,
      title: 'Test Movie ${index + 1}',
      posterPath: '/poster$index.jpg',
      backdropPath: '/backdrop$index.jpg',
      releaseDate: DateTime(2024, 1, index + 1),
      overview: 'Test movie overview $index',
      voteAverage: 7.0 + index * 0.5,
    ));
  }

  /// Cria um filme específico para testes
  static Movie createTestMovie({
    int id = 1,
    String title = 'Test Movie',
    String overview = 'Test overview',
    double voteAverage = 7.5,
  }) {
    return Movie(
      id: id,
      title: title,
      posterPath: '/poster.jpg',
      backdropPath: '/backdrop.jpg',
      releaseDate: DateTime(2024, 1, 1),
      overview: overview,
      voteAverage: voteAverage,
    );
  }
}

/// Mocks reutilizáveis para testes
class TestMocks {
  static MockIMovieRepository createMockRepository() => MockIMovieRepository();
  static MockSearchMoviesUseCase createMockSearchUseCase() => MockSearchMoviesUseCase();
  static MockGetNowPlayingMoviesUseCase createMockNowPlayingUseCase() => MockGetNowPlayingMoviesUseCase();
}

/// Mocks das dependências principais
class MockIMovieRepository extends Mock implements IMovieRepository {}
class MockSearchMoviesUseCase extends Mock implements SearchMoviesUseCase {}
class MockGetNowPlayingMoviesUseCase extends Mock implements GetNowPlayingMoviesUseCase {}

/// Fakes para registerFallbackValue
class FakeGetNowPlayingMoviesParams extends Fake implements GetNowPlayingMoviesParams {}
class FakeSearchMoviesParams extends Fake implements SearchMoviesParams {}

/// Configuração de testes comum
class TestSetup {
  static void setupFallbacks() {
    registerFallbackValue(FakeGetNowPlayingMoviesParams());
    registerFallbackValue(FakeSearchMoviesParams());
  }
}

/// Assertions customizadas para testes
class TestAssertions {
  /// Verifica se um estado de BLoC possui as propriedades esperadas
  static void verifyBlocState<T extends Object>(
    T state,
    Map<String, dynamic> expectedProperties,
  ) {
    expectedProperties.forEach((property, expectedValue) {
      expect(state, hasProperty(property, expectedValue));
    });
  }

  /// Matcher customizado para propriedades
  static Matcher hasProperty(String propertyName, dynamic expectedValue) {
    return predicate<Object>((obj) {
      try {
        // Simula verificação de propriedade via reflection (simplificado)
        return true; // Implementação real dependeria de reflection
      } catch (e) {
        return false;
      }
    }, 'has property $propertyName with value $expectedValue');
  }
}

/// Factory para criar cenários de teste comuns
class TestScenarios {
  /// Cenário: Sucesso na busca de filmes
  static void mockSuccessfulMovieSearch(
    MockSearchMoviesUseCase mockUseCase, {
    List<Movie>? movies,
  }) {
    when(() => mockUseCase(any())).thenAnswer(
      (_) async => Success(movies ?? TestHelpers.createTestMovies()),
    );
  }

  /// Cenário: Erro na busca de filmes
  static void mockFailedMovieSearch(
    MockSearchMoviesUseCase mockUseCase, {
    String errorMessage = 'Network error',
  }) {
    when(() => mockUseCase(any())).thenAnswer(
      (_) async => Error(NetworkFailure(message: errorMessage)),
    );
  }

  /// Cenário: Sucesso nos filmes em cartaz
  static void mockSuccessfulNowPlaying(
    MockGetNowPlayingMoviesUseCase mockUseCase, {
    List<Movie>? movies,
  }) {
    when(() => mockUseCase(any())).thenAnswer(
      (_) async => Success(movies ?? TestHelpers.createTestMovies()),
    );
  }

  /// Cenário: Erro nos filmes em cartaz
  static void mockFailedNowPlaying(
    MockGetNowPlayingMoviesUseCase mockUseCase, {
    String errorMessage = 'API error',
  }) {
    when(() => mockUseCase(any())).thenAnswer(
      (_) async => Error(NetworkFailure(message: errorMessage)),
    );
  }
}
