import 'package:dio/dio.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:movie_app/features/movie_list/data/models/movie_model.dart';
import 'package:movie_app/features/movie_list/data/repositories/movie_repository.dart';
import 'package:movie_app/features/movie_list/domain/usecases/search_controller.dart';

// Cria uma classe mock para o MovieRepository
class MockMovieRepository extends Mock implements MovieRepository {}

void main() {
  late SearchService searchService;
  late MockMovieRepository mockMovieRepository;

  setUp(() {
    mockMovieRepository = MockMovieRepository();
    searchService = SearchService(Dio());
  });

  test('Deve retornar uma lista de filmes ao buscar filmes com sucesso', () async {
    // Arrange
    const query = 'Inception';
    final movies = <Movie>[
      Movie(
        id: 1,
        title: 'Inception',
        posterPath: null,
        releaseDate: DateTime.now(),
        overview: 'A thief who steals corporate secrets through the use of dream-sharing technology.',
        voteAverage: 8.8,
        backdropPath: null,
      ),
      Movie(
        id: 12,
        title: 'Inception2',
        posterPath: null,
        releaseDate: DateTime.now(),
        overview: 'A thief who steals corporate secrets through the use of dream-sharing technology.',
        voteAverage: 8.8,
        backdropPath: null,
      )
    ];

    when(mockMovieRepository.searchMovies(query)).thenAnswer((_) async => movies);

    // Act
    final result = await searchService.searchMovies(query);

    // Assert
    expect(result, isA<List<Movie>>());
    expect(result, equals(movies));
  });

  test('Deve retornar uma lista vazia em caso de erro', () async {
    // Arrange
    const query = 'inception';
    when(mockMovieRepository.searchMovies(query)).thenThrow(Exception('Erro ao buscar filmes'));

    // Act
    final result = await searchService.searchMovies(query);

    // Assert
    expect(result, isA<List<Movie>>());
    expect(result, isEmpty);
  });
}
